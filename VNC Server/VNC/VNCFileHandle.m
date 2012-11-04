//
//  VNCFileHandle.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCFileHandle.h"

@implementation VNCFileHandle

- (id)initWithFilePointer:(FILE *)anFP {
    if ((self = [super init])) {
        fp = anFP;
        fd = fileno(anFP);
        lock = [[NSLock alloc] init];
    }
    return self;
}

- (id)initWithFileDescriptor:(int)anFd {
    self = [self initWithFilePointer:fdopen(anFd, "r+")];
    return self;
}

- (BOOL)readData:(void *)ptr ofLength:(NSUInteger)length {
    if (![self isOpen]) return NO;
    BOOL res = fread(ptr, 1, length, fp) == length;
    if (!res) [self close];
    return res;
}

- (BOOL)writeData:(const void *)ptr ofLength:(NSUInteger)length {
    if (![self isOpen]) return NO;
    BOOL res = fwrite(ptr, 1, length, fp) == length;
    if (!res) [self close];
    else fflush(fp);
    return res;
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

- (void)dealloc {
    fclose(fp);
}

@end
