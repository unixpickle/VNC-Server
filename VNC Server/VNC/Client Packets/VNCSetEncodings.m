//
//  VNCSetEncodings.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCSetEncodings.h"

@implementation VNCSetEncodings

@synthesize encodings;

- (id)initByReading:(VNCHandle *)handle {
    if ((self = [super init])) {
        char padding;
        if (![handle readData:&padding ofLength:1]) return nil;
        UInt16 bigNumber;
        if (![handle readData:&bigNumber ofLength:2]) return nil;
        UInt16 actualCount = CFSwapInt16BigToHost(bigNumber);
        NSMutableArray * mEncodings = [NSMutableArray arrayWithCapacity:actualCount];
        for (int i = 0; i < actualCount; i++) {
            SInt32 bigType;
            if (![handle readData:&bigType ofLength:4]) return nil;
            NSNumber * num = [NSNumber numberWithInt:(SInt32)CFSwapInt32BigToHost((UInt32)bigType)];
            [mEncodings addObject:num];
        }
        encodings = [mEncodings copy];
    }
    return self;
}

- (BOOL)includesEncoding:(SInt32)encoding {
    for (NSNumber * n in encodings) {
        if ([n intValue] == encoding) return YES;
    }
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %@>", NSStringFromClass([self class]), encodings];
}

@end
