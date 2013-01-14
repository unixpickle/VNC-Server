//
//  VNCMapPixelFormatter.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCPixelFormatter.h"

@interface VNCMapPixelFormatter : VNCPixelFormatter {
    VNCPixelFormat pixelFormat;
}

- (id)initWithFormat:(VNCPixelFormat)format map:(VNCColorMap *)aMap;

@end
