//
//  VNCServer.m
//  VNC Server
//
//  Created by Alex Nichol on 11/3/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCServer.h"

@interface VNCServer (Private)

- (void)serverLoop;

@end

@implementation VNCServer

@synthesize delegate;

- (id)initWithPort:(UInt16)aPort {
    if ((self = [super init])) {
        port = aPort;
    }
    return self;
}

- (BOOL)startServer {
    if (listenThread) return NO;
    struct sockaddr_in addr;
    bzero(&addr, sizeof(struct sockaddr_in));
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = INADDR_ANY;
    fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) return NO;

    int optval = 1;
    setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof(optval));
    
    if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        close(fd);
        return NO;
    }
    if (listen(fd, 5) < 0) {
        close(fd);
        return NO;
    }
    
    listenThread = [[NSThread alloc] initWithTarget:self selector:@selector(serverLoop) object:nil];
    [listenThread start];
    
    return YES;
}

- (void)cancelServer {
    close(fd);
    [listenThread cancel];
    listenThread = nil;
}

#pragma mark - Private -

- (void)serverLoop {
    @autoreleasepool {
        while (true) {
            int client = accept(fd, NULL, NULL);
            if (client < 0) {
                if ([[NSThread currentThread] isCancelled]) return;
                close(fd);
                NSDictionary * dict = @{NSLocalizedDescriptionKey: [NSString stringWithUTF8String:strerror(errno)]};
                NSError * error = [NSError errorWithDomain:NSPOSIXErrorDomain
                                                      code:errno
                                                  userInfo:dict];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if ([delegate respondsToSelector:@selector(server:failedWithError:)]) {
                        [delegate server:self failedWithError:error];
                    }
                });
            }
            if ([[NSThread currentThread] isCancelled]) return;
            VNCFileHandle * handle = [[VNCFileHandle alloc] initWithFileDescriptor:client];
            VNCServerConnection * connection = [[VNCServerConnection alloc] initWithHandle:handle];
            // TODO: do some negotiation here before even telling the delegate
            dispatch_sync(dispatch_get_main_queue(), ^{
                if ([delegate respondsToSelector:@selector(server:gotConnection:)]) {
                    [delegate server:self gotConnection:connection];
                }
            });
        }
    }
}

@end
