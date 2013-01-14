//
//  VNCServerInitPacket.h
//  VNC Server
//
//  Created by Alex Nichol on 11/3/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VNCPixelFormat.h"

@interface VNCServerInitPacket : NSObject {
    UInt16 framebufferWidth;
    UInt16 framebufferHeight;
    VNCPixelFormat pixelFormat;
    NSString * serverName;
}

@property (readwrite) UInt16 framebufferWidth;
@property (readwrite) UInt16 framebufferHeight;
@property (readwrite) VNCPixelFormat pixelFormat;
@property (nonatomic, retain) NSString * serverName;

- (NSData *)encode;
- (void)setDefaultsWithSize:(CGSize)size;

@end
