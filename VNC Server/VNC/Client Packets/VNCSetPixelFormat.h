//
//  VNCSetPixelFormat.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCClientPacket.h"
#include "VNCPixelFormat.h"

@interface VNCSetPixelFormat : VNCClientPacket {
    VNCPixelFormat pixelFormat;
}

@property (readonly) VNCPixelFormat pixelFormat;

@end
