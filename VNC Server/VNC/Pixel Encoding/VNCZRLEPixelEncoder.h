//
//  VNCZRLEPixelEncoder.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCPixelEncoder.h"
#import "VNCRawPixelEncoder.h"
#import "VNCZRLEPixelFormatter.h"

#include <zlib.h>

typedef enum {
    VNCZRLEEncodingSubtypeRaw,
    VNCZRLEEncodingSubtypeRLE
} VNCZRLEEncodingSubtype;

@interface VNCZRLEPixelEncoder : VNCPixelEncoder {
    z_stream stream;
    VNCZRLEEncodingSubtype encodeSubtype;
    VNCPixelEncoder * subEncoder;
}

@property (nonatomic, readwrite) VNCZRLEEncodingSubtype encodeSubtype;

@end
