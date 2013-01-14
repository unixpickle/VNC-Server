//
//  VNCPixelFormatter.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCPixelFormatter.h"
#import "VNCTruePixelFormatter.h"
#import "VNCMapPixelFormatter.h"
#import "VNCGraystyleColorMap.h"

@implementation VNCPixelFormatter

+ (VNCPixelFormatter *)formatterForPixelFormat:(VNCPixelFormat)format {
    if (format.trueColorFlag) {
        return [[VNCTruePixelFormatter alloc] initWithPixelFormat:format];
    } else {
        VNCGraystyleColorMap * map = [[VNCGraystyleColorMap alloc] initStandardMap];
        return [[VNCMapPixelFormatter alloc] initWithFormat:format map:map];
    }
}

- (NSUInteger)bytesPerPixel {
    [self doesNotRecognizeSelector:@selector(bytesPerPixel)];
    return 0;
}

- (void)getPixel:(UInt8 *)output forRed:(UInt16)red green:(UInt16)green blue:(UInt16)blue {
    [self doesNotRecognizeSelector:@selector(getPixel:forRed:green:blue:)];
}

- (BOOL)hasColorMap {
    return (colorMap != nil);
}

- (VNCColorMap *)colorMap {
    return colorMap;
}

@end
