//
//  VNCFileHandle.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCHandle.h"

@interface VNCFileHandle : VNCHandle {
    FILE * fp;
    int fd;
    NSLock * lock;
}

- (id)initWithFilePointer:(FILE *)anFP;
- (id)initWithFileDescriptor:(int)fd;

@end
