//
//  VNCServerConnection.m
//  VNC Server
//
//  Created by Alex Nichol on 11/3/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCServerConnection.h"

@interface VNCServerConnection (Private)

- (void)connectionMain;
- (void)delegateError;

// handshake
- (VNCVersion *)performVersionNegotiation;
- (BOOL)sendSecurityTypeList;
- (BOOL)sendPlainSecurityType;
- (BOOL)sendAuthenticationStatusMessage:(BOOL)failed;
- (BOOL)sendErrorMessage:(NSString *)message;
- (BOOL)performAuthFlow:(VNCVersion *)version;

// setup
- (BOOL)readClientInit:(BOOL *)allowOtherClients;
- (BOOL)sendServerInit;

// main connection loop
- (void)connectionDisplayLoop;

@end

@implementation VNCServerConnection

@synthesize delegate;

- (id)initWithHandle:(VNCFileHandle *)aHandle {
    if ((self = [super init])) {
        handle = aHandle;
    }
    return self;
}

- (void)closeConnection {
    [handle close];
    [backgroundThread cancel];
    backgroundThread = nil;
}

- (void)beginNegotiationWithSize:(CGSize)size authType:(VNCAuthenticationType)type authKey:(NSString *)keyOrNil {
    authType = type;
    displaySize = size;
    authKey = keyOrNil;
    NSAssert(!backgroundThread || !handle, @"Cannot begin negotiation more than once.");
    backgroundThread = [[NSThread alloc] initWithTarget:self selector:@selector(connectionMain) object:self];
    [backgroundThread start];
}

- (BOOL)prepareToSendRegions:(NSUInteger)numRegions {
    UInt16 typeAndPadding = 0;
    UInt16 numberBig = CFSwapInt16HostToBig(1);
    if (![handle writeData:&typeAndPadding ofLength:2]) return NO;
    if (![handle writeData:&numberBig ofLength:2]) return NO;
    return YES;
}

- (BOOL)sendRegion:(VNCPixelRegion)region ofFrameBuffer:(VNCFrameBuffer *)fb {
    NSData * encoded = [pixelEncoder encodeRegion:region frameBuffer:fb];
    UInt16 xBig = CFSwapInt16HostToBig(region.x);
    UInt16 yBig = CFSwapInt16HostToBig(region.y);
    UInt16 widthBig = CFSwapInt16HostToBig(region.width);
    UInt16 heightBig = CFSwapInt16HostToBig(region.height);
    SInt32 typeBig = CFSwapInt32HostToBig([pixelEncoder encodingTypeValue]);
    if (![handle writeData:&xBig ofLength:2]) return NO;
    if (![handle writeData:&yBig ofLength:2]) return NO;
    if (![handle writeData:&widthBig ofLength:2]) return NO;
    if (![handle writeData:&heightBig ofLength:2]) return NO;
    if (![handle writeData:&typeBig ofLength:4]) return NO;
    if (![handle writeData:[encoded bytes] ofLength:[encoded length]]) return NO;
    return YES;
}

#pragma mark - Private -

- (void)connectionMain {
    @autoreleasepool {
        VNCVersion * version = [self performVersionNegotiation];
        if (!version) {
            [self delegateError];
            return;
        }
        
        if ([version shouldListSecurityTypes]) {
            if (![self sendSecurityTypeList]) {
                [self delegateError];
                return;
            }
        } else {
            if (![self sendPlainSecurityType]) {
                [self delegateError];
                return;
            }
        }
        
        if (authType == VNCAuthenticationTypeNone) {
            if ([version shouldSendSecurityResultOnNoAuth]) {
                if (![self sendAuthenticationStatusMessage:NO]) {
                    [self delegateError];
                    return;
                }
            }
        } else {
            if (![self performAuthFlow:version]) {
                [handle close];
                return;
            }
        }
        
        if (![self sendAuthenticationStatusMessage:NO]) {
            [self delegateError];
            return;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(serverConnectionAuthenticationSuccessful:)]) {
                [delegate serverConnectionAuthenticationSuccessful:self];
            }
        });
        
        BOOL allowOthers = NO;
        if (![self readClientInit:&allowOthers]) {
            [self delegateError];
            return;
        }
        if (![self sendServerInit]) {
            [self delegateError];
            return;
        }
        
        [self connectionDisplayLoop];
        
        // close the handle on success
        [handle close];
    }
}

- (void)delegateError {
    [handle close];
    if ([[NSThread currentThread] isCancelled]) return;
    NSDictionary * desc = @{NSLocalizedDescriptionKey: [NSString stringWithUTF8String:strerror(errno)]};
    NSError * e = [NSError errorWithDomain:NSPOSIXErrorDomain
                                      code:errno
                                  userInfo:desc];
    dispatch_sync(dispatch_get_main_queue(), ^{
        backgroundThread = nil;
        if ([delegate respondsToSelector:@selector(serverConnection:failedWithError:)]) {
            [delegate serverConnection:self failedWithError:e];
        }
    });
}

#pragma mark Negotiation Flow

- (VNCVersion *)performVersionNegotiation {
    const char * initBuffer = "RFB 003.008\n";
    if (![handle writeData:initBuffer ofLength:strlen(initBuffer)]) {
        return nil;
    }
    char response[128];
    if ([handle getLine:response maxLength:128] == NULL) {
        return nil;
    }
    if (strlen(response) < 2) {
        errno = EINVAL;
        return nil;
    }
    if (response[strlen(response) - 1] == '\n') {
        response[strlen(response) - 1] = 0;
    }
    if (response[strlen(response) - 1] == '\r') {
        response[strlen(response) - 1] = 0;
    }
    return [[VNCVersion alloc] initWithClientVersionString:[NSString stringWithUTF8String:response]];
}

- (BOOL)sendSecurityTypeList {
    char data[2];
    data[0] = 1;
    if (authType == VNCAuthenticationTypeNone) {
        data[1] = 1;
    } else {
        data[1] = 2;
    }
    if (![handle writeData:data ofLength:2]) {
        return NO;
    }
    UInt8 result = 0;
    if (![handle readData:&result ofLength:1]) {
        return NO;
    }
    return YES;
}

- (BOOL)sendPlainSecurityType {
    UInt32 type = CFSwapInt32HostToBig(authType == VNCAuthenticationTypeNone ? 1 : 2);
    return [handle writeData:&type ofLength:4];
}

- (BOOL)sendAuthenticationStatusMessage:(BOOL)failed {
    UInt32 statusFlipped = CFSwapInt32HostToBig(failed);
    return [handle writeData:&statusFlipped ofLength:4];
}

- (BOOL)sendErrorMessage:(NSString *)message {
    const char * str = [message UTF8String];
    UInt32 lenFlipped = CFSwapInt32HostToBig((UInt32)strlen(str));
    if (![handle writeData:&lenFlipped ofLength:4]) {
        return NO;
    }
    if (![handle writeData:str ofLength:strlen(str)]) {
        return NO;
    }
    return YES;
}

#pragma mark Authentication Flow

- (BOOL)performAuthFlow:(VNCVersion *)version {
    VNCAuthFlow * flow = [[VNCAuthFlow alloc] initWithPassword:authKey];
    [flow generateRandomData];
    NSData * randomKey = flow.randomData;
    if (![handle writeData:[randomKey bytes] ofLength:[randomKey length]]) {
        [self delegateError];
        return NO;
    }
    char buffer[16];
    if (![handle readData:buffer ofLength:16]) {
        [self delegateError];
        return NO;
    }
    NSData * newData = [NSData dataWithBytes:buffer length:16];
    if (![flow verifyResponse:newData]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(serverConnectionAuthenticationFailed:)]) {
                [delegate serverConnectionAuthenticationFailed:self];
            }
        });
        if ([version shouldSendAuthenticationError]) {
            [self sendAuthenticationStatusMessage:YES];
            [self sendErrorMessage:@"Login incorrect."];
        }
        return NO;
    }
    return YES;
}

#pragma mark Setup

- (BOOL)readClientInit:(BOOL *)allowOtherClients {
    char buff;
    if (![handle readData:&buff ofLength:1]) return NO;
    if (allowOtherClients) *allowOtherClients = (BOOL)buff;
    return YES;
}

- (BOOL)sendServerInit {
    VNCServerInitPacket * serverInit = [[VNCServerInitPacket alloc] init];
    [serverInit setDefaultsWithSize:displaySize];
    pixelFormat = serverInit.pixelFormat;
    NSData * data = [serverInit encode];
    if (![handle writeData:[data bytes] ofLength:[data length]]) {
        return NO;
    }
    return YES;
}

#pragma mark Display Loop

- (void)connectionDisplayLoop {
    while (YES) {
        // read a packet
        UInt8 nextType = 0;
        if (![handle readData:&nextType ofLength:1]) {
            [self delegateError];
            return;
        }
        Class c = [VNCClientPacket classForPacketType:nextType];
        if (c == Nil) {
            errno = ENOTSUP;
            [self delegateError];
            return;
        }
        
        VNCClientPacket * packet = [[c alloc] initByReading:handle];
        if ([packet isKindOfClass:[VNCSetEncodings class]]) {
            VNCPixelFormatter * formatter = [VNCPixelFormatter formatterForPixelFormat:pixelFormat];
            VNCSetEncodings * setEncs = (VNCSetEncodings *)packet;
            Class c = [VNCPixelEncoder preferredEncoderFromChoices:setEncs.encodings];
            pixelEncoder = [[c alloc] initWithFormatter:formatter];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([delegate respondsToSelector:@selector(serverConnectionPixelsEncodable:)]) {
                    [delegate serverConnectionPixelsEncodable:self];
                }
            });
        } else if ([packet isKindOfClass:[VNCFBUpdateRequest class]]) {
            VNCFBUpdateRequest * updateReq = (VNCFBUpdateRequest *)packet;
            VNCPixelRegion region;
            region.x = updateReq.xposition;
            region.y = updateReq.yposition;
            region.width = updateReq.width;
            region.height = updateReq.height;
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([delegate respondsToSelector:@selector(serverConnection:regionRequested:)]) {
                    [delegate serverConnection:self regionRequested:region];
                }
            });
        } else if ([packet isKindOfClass:[VNCPointerEvent class]]) {
            dispatch_sync(dispatch_get_current_queue(), ^{
                if ([delegate respondsToSelector:@selector(serverConnection:pointerEvent:)]) {
                    [delegate serverConnection:self pointerEvent:(VNCPointerEvent *)packet];
                }
            });
        }
    }
}

@end
