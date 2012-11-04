//
//  VNCRawPixelEncoder.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCRawPixelEncoder.h"

@implementation VNCRawPixelEncoder

- (NSData *)encodeRegion:(VNCPixelRegion)region frameBuffer:(VNCFrameBuffer *)fb {
    NSUInteger pixelSize = [formatter bytesPerPixel];
    UInt8 * buffer = (UInt8 *)malloc(pixelSize * region.width * region.height);
    NSUInteger offset = 0;
    for (NSUInteger y = region.y; y < region.y + region.height; y++) {
        for (NSUInteger x = region.x; x < region.x + region.width; x++) {
            VNCFrameBufferPixel * pixel = [fb pixelAtX:x y:y];
            [formatter getPixel:&buffer[offset] forRed:pixel->red green:pixel->green blue:pixel->blue];
            offset += pixelSize;
        }
    }
    return [[NSData alloc] initWithBytesNoCopy:buffer
                                        length:(pixelSize * region.width * region.height)
                                  freeWhenDone:YES];
}

- (SInt32)encodingTypeValue {
    return 0;
}

@end
