//
//  VNCFBUpdateRequest.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCFBUpdateRequest.h"

@implementation VNCFBUpdateRequest

@synthesize xposition;
@synthesize yposition;
@synthesize width;
@synthesize height;

- (id)initByReading:(VNCHandle *)handle {
    if ((self = [super init])) {
        UInt8 padding;
        if (![handle readData:&padding ofLength:1]) return nil;
        if (![handle readData:&xposition ofLength:2]) return nil;
        if (![handle readData:&yposition ofLength:2]) return nil;
        if (![handle readData:&width ofLength:2]) return nil;
        if (![handle readData:&height ofLength:2]) return nil;
        xposition = CFSwapInt16BigToHost(xposition);
        yposition = CFSwapInt16BigToHost(yposition);
        width = CFSwapInt16BigToHost(width);
        height = CFSwapInt16BigToHost(height);
    }
    return self;
}

@end
