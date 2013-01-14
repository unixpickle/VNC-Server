//
//  VNCZRLEPixelFormatter.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCPixelFormatter.h"

@interface VNCZRLEPixelFormatter : VNCPixelFormatter {
    VNCPixelFormatter * subFormatter;
    BOOL shouldCutByte;
    BOOL isBigEndian;
}

- (id)initByWrappingFormatter:(VNCPixelFormatter *)aFormatter;

@end
