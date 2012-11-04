//
//  VNCTruePixelFormatter.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCTruePixelFormatter.h"

@implementation VNCTruePixelFormatter

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
    if (pixelFormat.bitsPerPixel == 16) {
        // I have no idea whatsoever if I am doing this correctly or not.
        UInt16 theColor = 0;
        UInt8 redColor = (UInt8)round((float)red / (65535.0 / 31.0));
        UInt8 greenColor = (UInt8)round((float)green / (65535.0 / 31.0));
        UInt8 blueColor = (UInt8)round((float)blue / (65535.0 / 31.0));
        theColor |= (redColor << 10);
        theColor |= (greenColor << 5);
        theColor |= blueColor;
    }
}

@end
