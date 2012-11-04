//
//  VNCPointerEvent.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCPointerEvent.h"

@implementation VNCPointerEvent

@synthesize buttonMask;
@synthesize pointerX;
@synthesize pointerY;

- (id)initByReading:(VNCHandle *)handle {
    if ((self = [super init])) {
        if (![handle readData:&buttonMask ofLength:1]) return nil;
        if (![handle readData:&pointerX ofLength:2]) return nil;
        if (![handle readData:&pointerY ofLength:2]) return nil;
        pointerX = CFSwapInt16BigToHost(pointerX);
        pointerY = CFSwapInt16BigToHost(pointerY);
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@, Mask: %d, (%d,%d)>", NSStringFromClass([self class]),
            (int)buttonMask, (int)pointerX, (int)pointerY];
}

@end
