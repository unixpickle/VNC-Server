//
//  VNCPixelEncoder.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VNCFrameBuffer.h"
#import "VNCPixelFormatter.h"

typedef struct {
    UInt16 x;
    UInt16 y;
    UInt16 width;
    UInt16 height;
} VNCPixelRegion;

@interface VNCPixelEncoder : NSObject {
    VNCPixelFormatter * formatter;
}

@property (readonly) VNCPixelFormatter * formatter;

+ (Class)preferredEncoderFromChoices:(NSArray *)numbers;

- (id)initWithFormatter:(VNCPixelFormatter *)aFormatter;
- (NSData *)encodeRegion:(VNCPixelRegion)region frameBuffer:(VNCFrameBuffer *)fb;
- (SInt32)encodingTypeValue;

@end
