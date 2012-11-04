//
//  VNCHandle.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCHandle.h"

@implementation VNCHandle

- (BOOL)readData:(void *)ptr ofLength:(NSUInteger)length {
    [self doesNotRecognizeSelector:@selector(readData:ofLength:)];
    return NO;
}

- (BOOL)writeData:(const void *)ptr ofLength:(NSUInteger)length {
    [self doesNotRecognizeSelector:@selector(writeData:ofLength:)];
    return NO;
}

- (void)close {
    [self doesNotRecognizeSelector:@selector(close)];
}

- (BOOL)isOpen {
    [self doesNotRecognizeSelector:@selector(isOpen)];
    return NO;
}

- (const char *)getLine:(char *)ptr maxLength:(NSUInteger)length {
    if (length == 0) return NULL;
    char c = 0;
    for (int i = 0; i < length - 1; i++) {
        if (![self readData:&c ofLength:1]) {
            if (i == 0) return NULL;
            else break;
        }
        ptr[i] = c;
        ptr[i + 1] = 0;
        if (c == '\n') break;
    }
    return ptr;
}

@end
