//
//  VNCHandle.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VNCHandle : NSObject

- (BOOL)readData:(void *)ptr ofLength:(NSUInteger)length;
- (BOOL)writeData:(const void *)ptr ofLength:(NSUInteger)length;
- (void)close;
- (BOOL)isOpen;
- (const char *)getLine:(char *)ptr maxLength:(NSUInteger)length;

@end
