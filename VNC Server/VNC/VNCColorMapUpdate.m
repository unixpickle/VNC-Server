//
//  VNCColorMapUpdate.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCColorMapUpdate.h"

@implementation VNCColorMapUpdate

@synthesize firstColor;
@synthesize numberOfColors;
@synthesize colorMap;

- (NSData *)encodePacket {
    NSMutableData * packet = [NSMutableData data];
    UInt8 type = 1;
    UInt8 padding = 0;
    [packet appendBytes:&type length:1];
    [packet appendBytes:&padding length:1];
    UInt16 firstBig = CFSwapInt16HostToBig(firstColor);
    UInt16 numberBig = CFSwapInt16HostToBig(numberOfColors);
    [packet appendBytes:&firstBig length:2];
    [packet appendBytes:&numberBig length:2];
    for (int i = 0; i < numberOfColors; i++) {
        VNCColorMapEntry entry = [colorMap colorMapEntryAtIndex:i];
        UInt16 redBig = CFSwapInt16HostToBig(entry.red);
        UInt16 greenBig = CFSwapInt16HostToBig(entry.green);
        UInt16 blueBig = CFSwapInt16HostToBig(entry.blue);
        [packet appendBytes:&redBig length:2];
        [packet appendBytes:&greenBig length:2];
        [packet appendBytes:&blueBig length:2];
    }
    return [packet copy];
}

@end
