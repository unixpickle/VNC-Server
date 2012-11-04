//
//  VNCFrameBuffer.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    UInt16 red;
    UInt16 green;
    UInt16 blue;
} VNCFrameBufferPixel;

@interface VNCFrameBuffer : NSObject {
    NSUInteger width;
    NSUInteger height;
    VNCFrameBufferPixel * pixels;
}

@property (readonly) NSUInteger width;
@property (readonly) NSUInteger height;

- (id)initWithWidth:(NSUInteger)theWidth height:(NSUInteger)theHeight;
- (VNCFrameBufferPixel *)pixelAtX:(NSUInteger)x y:(NSUInteger)y;

@end
