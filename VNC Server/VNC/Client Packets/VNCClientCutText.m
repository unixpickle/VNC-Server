//
//  VNCClientCutText.m
//  VNC Server
//
//  Created by Alex Nichol on 11/6/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCClientCutText.h"

@implementation VNCClientCutText

@synthesize cutText;

- (id)initByReading:(VNCHandle *)handle {
    if ((self = [super init])) {
        UInt32 padding;
        UInt32 lenBig;
        if (![handle readData:&padding ofLength:3]) return nil;
        if (![handle readData:&lenBig ofLength:4]) return nil;
        UInt32 realLen = CFSwapInt32BigToHost(lenBig);
        char * buffer = (char *)malloc(realLen + 1);
        if (![handle readData:buffer ofLength:realLen]) {
            free(buffer);
            return nil;
        }
        cutText = [[NSString alloc] initWithBytes:buffer length:realLen encoding:NSISOLatin1StringEncoding];
        free(buffer);
    }
    return self;
}

@end
