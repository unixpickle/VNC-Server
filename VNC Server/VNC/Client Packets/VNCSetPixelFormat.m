//
//  VNCSetPixelFormat.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCSetPixelFormat.h"

@implementation VNCSetPixelFormat

@synthesize pixelFormat;

- (id)initByReading:(VNCHandle *)handle {
    if ((self = [super init])) {
        char padding[3];
        if (![handle readData:padding ofLength:3]) return nil;
        if (![handle readData:&pixelFormat ofLength:sizeof(pixelFormat)]) return nil;
        pixelFormat = VNCPixelFormatBigToHost(pixelFormat);
    }
    return self;
}

@end
