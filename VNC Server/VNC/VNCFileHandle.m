//
//  VNCFileHandle.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCFileHandle.h"

@implementation VNCFileHandle

- (id)initWithFileDescriptor:(int)anFd {
    if ((self = [super init])) {
        fd = anFd;
        lock = [[NSLock alloc] init];
        fileHandle = [[NSFileHandle alloc] initWithFileDescriptor:fd closeOnDealloc:NO];
    }
    return self;
}

- (BOOL)readData:(void *)ptr ofLength:(NSUInteger)length {
    if (![self isOpen]) return NO;
    
    NSMutableData * accum = [NSMutableData data];
    while ([accum length] < length) {
        NSData * d = [fileHandle readDataOfLength:length - [accum length]];
        if ([d length] == 0 || !d) {
            [self close];
            return NO;
        }
        [accum appendData:d];
    }
    
    memcpy(ptr, [accum bytes], [accum length]);
    return YES;
}

- (BOOL)writeData:(const void *)ptr ofLength:(NSUInteger)length {
    if (![self isOpen]) return NO;
    NSData * data = [NSData dataWithBytes:ptr length:length];
    BOOL failed = NO;
    @try {
        [fileHandle writeData:data];
    } @catch (NSException * e) {
        failed = YES;
    }
    if (failed) [self close];
    return !failed;
}

- (void)close {
    [lock lock];
    if (fd >= 0) {
        close(fd);
        fd = -1;
    }
    [lock unlock];
}

- (BOOL)isOpen {
    [lock lock];
    BOOL flag = fd >= 0;
    [lock unlock];
    return flag;
}

@end
