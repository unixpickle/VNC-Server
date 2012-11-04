//
//  VNCPixelFormat.c
//  VNC Server
//
//  Created by Alex Nichol on 11/3/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#include "VNCPixelFormat.h"

VNCPixelFormat VNCPixelFormatHostToBig(VNCPixelFormat format) {
    VNCPixelFormat newFormat = format;
    newFormat.redMax = CFSwapInt16HostToBig(format.redMax);
    newFormat.greenMax = CFSwapInt16HostToBig(format.greenMax);
    newFormat.blueMax = CFSwapInt16HostToBig(format.blueMax);
    return newFormat;
}

VNCPixelFormat VNCPixelFormatBigToHost(VNCPixelFormat format) {
    VNCPixelFormat newFormat = format;
    newFormat.redMax = CFSwapInt16BigToHost(format.redMax);
    newFormat.greenMax = CFSwapInt16BigToHost(format.greenMax);
    newFormat.blueMax = CFSwapInt16BigToHost(format.blueMax);
    return newFormat;
}
