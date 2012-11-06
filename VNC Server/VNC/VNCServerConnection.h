//
//  VNCServerConnection.h
//  VNC Server
//
//  Created by Alex Nichol on 11/3/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VNCAuthFlow.h"
#import "VNCClientCutText.h"
#import "VNCClientPacket.h"
#import "VNCColorMapUpdate.h"
#import "VNCCutTextPacket.h"
#import "VNCFBUpdateRequest.h"
#import "VNCFileHandle.h"
#import "VNCFrameBuffer.h"
#import "VNCKeyboardEvent.h"
#import "VNCPixelEncoder.h"
#import "VNCPointerEvent.h"
#import "VNCServerInitPacket.h"
#import "VNCSetEncodings.h"
#import "VNCSetPixelFormat.h"
#import "VNCVersion.h"

typedef enum {
    VNCAuthenticationTypeNone,
    VNCAuthenticationTypeVNCStandard
} VNCAuthenticationType;

@class VNCServerConnection;

@protocol VNCServerConnectionDelegate <NSObject>

@optional
- (void)serverConnection:(VNCServerConnection *)connection failedWithError:(NSError *)error;
- (void)serverConnectionAuthenticationSuccessful:(VNCServerConnection *)connection;
- (void)serverConnectionAuthenticationFailed:(VNCServerConnection *)connection;

- (void)serverConnectionPixelsEncodable:(VNCServerConnection *)connection;
- (void)serverConnection:(VNCServerConnection *)connection regionRequested:(VNCPixelRegion)region;
- (void)serverConnection:(VNCServerConnection *)connection pointerEvent:(VNCPointerEvent *)event;
- (void)serverConnection:(VNCServerConnection *)connection keyboardEvent:(VNCKeyboardEvent *)event;
- (void)serverConnection:(VNCServerConnection *)connection clientCutText:(VNCClientCutText *)text;

@end

@interface VNCServerConnection : NSObject {
    VNCHandle * handle;
    VNCAuthenticationType authType;
    NSString * authKey;
    CGSize displaySize;
    
    __weak id<VNCServerConnectionDelegate> delegate;
    
    NSThread * backgroundThread;
    
    VNCPixelFormat pixelFormat;
    VNCPixelEncoder * pixelEncoder;
}

@property (nonatomic, weak) id<VNCServerConnectionDelegate> delegate;

- (id)initWithHandle:(VNCFileHandle *)aHandle;
- (void)closeConnection;
- (void)beginNegotiationWithSize:(CGSize)size authType:(VNCAuthenticationType)type authKey:(NSString *)keyOrNil;

- (BOOL)prepareToSendRegions:(NSUInteger)numRegions;
- (BOOL)sendRegion:(VNCPixelRegion)region ofFrameBuffer:(VNCFrameBuffer *)fb;
- (BOOL)sendServerCutText:(NSString *)text;

@end
