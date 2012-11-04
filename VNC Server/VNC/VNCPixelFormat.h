//
//  VNCPixelFormat.h
//  VNC Server
//
//  Created by Alex Nichol on 11/3/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#ifndef VNC_Server_VNCPixelFormat_h
#define VNC_Server_VNCPixelFormat_h

#import <CoreFoundation/CoreFoundation.h>

typedef struct {
    UInt8 bitsPerPixel;
    UInt8 depth;
    UInt8 bigEndianFlag;
    UInt8 trueColorFlag;
    UInt16 redMax;
    UInt16 greenMax;
    UInt16 blueMax;
    UInt8 redShift;
    UInt8 greenShift;
    UInt8 blueShift;
    UInt8 reserved1;
    UInt16 reserved2;
} VNCPixelFormat;

VNCPixelFormat VNCPixelFormatHostToBig(VNCPixelFormat format);
VNCPixelFormat VNCPixelFormatBigToHost(VNCPixelFormat format);

#endif
