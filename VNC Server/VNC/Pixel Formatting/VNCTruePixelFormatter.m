//
//  VNCTruePixelFormatter.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCTruePixelFormatter.h"

@implementation VNCTruePixelFormatter

@synthesize pixelFormat;

- (id)initWithPixelFormat:(VNCPixelFormat)format {
    if ((self = [super init])) {
        pixelFormat = format;
    }
    return self;
}

- (NSUInteger)bytesPerPixel {
    return pixelFormat.bitsPerPixel / 8;
}

- (void)getPixel:(UInt8 *)output forRed:(UInt16)red green:(UInt16)green blue:(UInt16)blue {
    if (pixelFormat.depth == 15) {
        // I have no idea whatsoever if I am doing this correctly or not.
        UInt16 theColor = 0;
        UInt8 redColor = (UInt8)round((float)red / (65535.0 / 31.0));
        UInt8 greenColor = (UInt8)round((float)green / (65535.0 / 31.0));
        UInt8 blueColor = (UInt8)round((float)blue / (65535.0 / 31.0));
        theColor |= (redColor << 10);
        theColor |= (greenColor << 5);
        theColor |= blueColor;
        UInt16 properOrder = 0;
        if (pixelFormat.bigEndianFlag) properOrder = CFSwapInt16HostToBig(theColor);
        else properOrder = CFSwapInt16HostToLittle(theColor);
        *((UInt16 *)output) = properOrder;
    } else if (pixelFormat.depth == 24) {
        UInt8 redColor = red / 257;
        UInt8 greenColor = green / 257;
        UInt8 blueColor = blue / 257;
        if (pixelFormat.bigEndianFlag) {
            output[0] = redColor;
            output[1] = greenColor;
            output[2] = blueColor;
            if (pixelFormat.bitsPerPixel == 32) output[3] = 0;
        } else {
            output[0] = blueColor;
            output[1] = greenColor;
            output[2] = redColor;
            if (pixelFormat.bitsPerPixel == 32) output[3] = 0;
        }
    } else if (pixelFormat.depth == 8) {
        // use two bits each for this bad-boy
        UInt8 redColor = (UInt8)round((float)red / (65535 / 2));
        UInt8 greenColor = (UInt8)round((float)green / (65535 / 2));
        UInt8 blueColor = (UInt8)round((float)blue / (65535 / 2));
        *output = redColor << 2;
        *output |= greenColor << 4;
        *output |= blueColor << 6;
    }
}

@end
