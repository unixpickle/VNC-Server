//
//  VNCTruePixelFormatter.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCPixelFormatter.h"
#include "VNCPixelFormat.h"

@interface VNCTruePixelFormatter : VNCPixelFormatter {
    VNCPixelFormat pixelFormat;
}

- (id)initWithPixelFormat:(VNCPixelFormat)format;

@end
