//
//  VNCKeyboardEvent.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCKeyboardEvent.h"

@implementation VNCKeyboardEvent

@synthesize downFlag;
@synthesize key;

- (id)initByReading:(VNCHandle *)handle {
    if ((self = [super init])) {
        char bogus[2];
        if (![handle readData:&downFlag ofLength:1]) return NO;
        if (![handle readData:bogus ofLength:2]) return NO;
        if (![handle readData:&key ofLength:4]) return NO;
        key = CFSwapInt32BigToHost(key);
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: (down: %@) %u>", NSStringFromClass([self class]),
            downFlag == 0 ? @"NO" : @"YES", (unsigned int)key];
}

@end
