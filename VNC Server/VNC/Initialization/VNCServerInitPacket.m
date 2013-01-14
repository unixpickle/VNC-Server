//
//  VNCServerInitPacket.m
//  VNC Server
//
//  Created by Alex Nichol on 11/3/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCServerInitPacket.h"

@implementation VNCServerInitPacket

@synthesize framebufferWidth;
@synthesize framebufferHeight;
@synthesize pixelFormat;
@synthesize serverName;

- (NSData *)encode {
    char header[24];
    UInt16 widthBig = CFSwapInt16HostToBig(framebufferWidth);
    UInt16 heightBig = CFSwapInt16HostToBig(framebufferHeight);
    VNCPixelFormat formatBig = VNCPixelFormatHostToBig(pixelFormat);
    UInt32 nameLength = CFSwapInt32HostToBig((UInt32)[serverName length]);
    memcpy(header, &widthBig, 2);
    memcpy(&header[2], &heightBig, 2);
    memcpy(&header[4], &formatBig, sizeof(VNCPixelFormat));
    memcpy(&header[20], &nameLength, 4);
    NSMutableData * data = [[NSMutableData alloc] init];
    [data appendBytes:header length:24];
    [data appendData:[serverName dataUsingEncoding:NSASCIIStringEncoding]];
    return [data copy];
}

- (void)setDefaultsWithSize:(CGSize)size {
    bzero(&pixelFormat, sizeof(VNCPixelFormat));
    framebufferWidth = round(size.width);
    framebufferHeight = round(size.height);
    pixelFormat.trueColorFlag = 1;
    pixelFormat.bigEndianFlag = 0;
    pixelFormat.bitsPerPixel = 32;
    pixelFormat.blueMax = 255;
    pixelFormat.blueShift = 0;
    pixelFormat.depth = 24;
    pixelFormat.greenMax = 255;
    pixelFormat.greenShift = 0;
    pixelFormat.redMax = 255;
    pixelFormat.redShift = 0;
}

@end
