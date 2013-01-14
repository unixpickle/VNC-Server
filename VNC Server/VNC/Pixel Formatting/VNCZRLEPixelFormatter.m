//
//  VNCZRLEPixelFormatter.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCZRLEPixelFormatter.h"
#import "VNCTruePixelFormatter.h"

@implementation VNCZRLEPixelFormatter

- (id)initByWrappingFormatter:(VNCPixelFormatter *)aFormatter {
    if ((self = [super init])) {
        subFormatter = aFormatter;
        if ([subFormatter isKindOfClass:[VNCTruePixelFormatter class]]) {
            VNCTruePixelFormatter * trueForm = (VNCTruePixelFormatter *)subFormatter;
            if (trueForm.pixelFormat.depth == 24 && trueForm.pixelFormat.bitsPerPixel == 32) {
                shouldCutByte = YES;
                isBigEndian = trueForm.pixelFormat.bigEndianFlag;
            }
        }
    }
    return self;
}

- (NSUInteger)bytesPerPixel {
    if (!shouldCutByte) return [subFormatter bytesPerPixel];
    return 3;
}

- (void)getPixel:(UInt8 *)output forRed:(UInt16)red green:(UInt16)green blue:(UInt16)blue {
    if (!shouldCutByte) {
        [subFormatter getPixel:output forRed:red green:green blue:blue];
    } else {
        UInt8 buff[4];
        [subFormatter getPixel:buff forRed:red green:green blue:blue];
        memcpy(output, buff, 3);
        /*if (isBigEndian) {
            memcpy(output, &buff[1], 3);
        } else {
            memcpy(output, buff, 3);
        }*/
    }
}

- (BOOL)hasColorMap {
    return [subFormatter hasColorMap];
}

- (VNCColorMap *)colorMap {
    return [subFormatter colorMap];
}

@end
