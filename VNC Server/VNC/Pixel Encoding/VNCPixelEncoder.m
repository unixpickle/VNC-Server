//
//  VNCPixelEncoder.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCPixelEncoder.h"
#import "VNCRawPixelEncoder.h"
#import "VNCZRLEPixelEncoder.h"

@implementation VNCPixelEncoder

+ (Class)preferredEncoderFromChoices:(NSArray *)numbers {
    NSDictionary * dictionary = @{@0: [VNCRawPixelEncoder class],
                                  @16: [VNCZRLEPixelEncoder class]};
    for (NSNumber * n in numbers) {
        if ([dictionary objectForKey:n]) {
            return [dictionary objectForKey:n];
        }
    }
    return [VNCRawPixelEncoder class];
}

- (id)initWithFormatter:(VNCPixelFormatter *)aFormatter {
    if ((self = [super init])) {
        formatter = aFormatter;
    }
    return self;
}

- (NSData *)encodeRegion:(VNCPixelRegion)region frameBuffer:(VNCFrameBuffer *)fb {
    [self doesNotRecognizeSelector:@selector(encodeRegion:frameBuffer:)];
    return nil;
}

- (SInt32)encodingTypeValue {
    [self doesNotRecognizeSelector:@selector(encodingTypeValue)];
    return 0;
}

@end
