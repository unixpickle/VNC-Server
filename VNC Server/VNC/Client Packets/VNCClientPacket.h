//
//  VNCClientPacket.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VNCHandle.h"

@interface VNCClientPacket : NSObject

+ (Class)classForPacketType:(UInt8)type;
- (id)initByReading:(VNCHandle *)handle;

@end
