//
//  VNCCutTextPacket.m
//  VNC Server
//
//  Created by Alex Nichol on 11/6/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCCutTextPacket.h"

@implementation VNCCutTextPacket

@synthesize cutText;

- (NSData *)encodeServerCutText {
    NSData * textData = [cutText dataUsingEncoding:NSISOLatin1StringEncoding];
    NSMutableData * data = [[NSMutableData alloc] init];
    UInt8 type = 3;
    UInt32 padding = 0;
    UInt32 lenBig = CFSwapInt32HostToBig((UInt32)[textData length]);
    [data appendBytes:&type length:1];
    [data appendBytes:&padding length:3];
    [data appendBytes:&lenBig length:4];
    if (textData) [data appendData:textData];
    return [data copy];
}

@end
