//
//  VNCPixelFormatter.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCPixelFormatter.h"

@implementation VNCPixelFormatter

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
