//
//  VNCFrameBuffer.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCFrameBuffer.h"

@implementation VNCFrameBuffer

@synthesize width;
@synthesize height;

- (id)initWithWidth:(NSUInteger)theWidth height:(NSUInteger)theHeight {
    if ((self = [super init])) {
        width = theWidth;
        height = theHeight;
        pixels = (VNCFrameBufferPixel *)malloc(sizeof(VNCFrameBufferPixel) * width * height);
        bzero(pixels, sizeof(VNCFrameBufferPixel) * width * height);
    }
    return self;
}

- (VNCFrameBufferPixel *)pixelAtX:(NSUInteger)x y:(NSUInteger)y {
    return &pixels[x + (y * width)];
}

- (void)dealloc {
    free(pixels);
}

@end
