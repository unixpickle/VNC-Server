//
//  VNCMapPixelFormatter.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCMapPixelFormatter.h"

@implementation VNCMapPixelFormatter

- (id)initWithFormat:(VNCPixelFormat)format map:(VNCColorMap *)aMap {
    if ((self = [super init])) {
        pixelFormat = format;
        colorMap = aMap;
    }
    return self;
}

- (NSUInteger)bytesPerPixel {
    return pixelFormat.bitsPerPixel / 8;
}

- (void)getPixel:(UInt8 *)output forRed:(UInt16)red green:(UInt16)green blue:(UInt16)blue {
    VNCColorMapEntry entry;
    entry.red = red;
    entry.green = green;
    entry.blue = blue;
    NSUInteger index = [colorMap indexByAddingColor:entry];
    if (pixelFormat.bitsPerPixel == 8) {
        *output = (UInt8)index;
    } else if (pixelFormat.bitsPerPixel == 16) {
        UInt16 indexNum = (UInt16)index;
        if (pixelFormat.bigEndianFlag) indexNum = CFSwapInt16HostToBig(indexNum);
        else indexNum = CFSwapInt16HostToLittle(indexNum);
        memcpy(output, &indexNum, 2);
    } else if (pixelFormat.bitsPerPixel == 32) {
        UInt32 indexNum = (UInt32)index;
        if (pixelFormat.bigEndianFlag) indexNum = CFSwapInt32HostToBig(indexNum);
        else indexNum = CFSwapInt32HostToLittle(indexNum);
        memcpy(output, &indexNum, 4);
    }
}

@end
