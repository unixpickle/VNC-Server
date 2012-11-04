//
//  VNCFileHandle.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCHandle.h"

@interface VNCFileHandle : VNCHandle {
    NSFileHandle * fileHandle;
    int fd;
    NSLock * lock;
}

- (id)initWithFileDescriptor:(int)fd;

@end
