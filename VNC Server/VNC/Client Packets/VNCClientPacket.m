//
//  VNCClientPacket.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCClientPacket.h"

#import "VNCClientCutText.h"
#import "VNCSetPixelFormat.h"
#import "VNCSetEncodings.h"
#import "VNCFBUpdateRequest.h"
#import "VNCKeyboardEvent.h"
#import "VNCPointerEvent.h"

@implementation VNCClientPacket

+ (Class)classForPacketType:(UInt8)type {
    NSDictionary * dict = @{@0: [VNCSetPixelFormat class],
                            @2: [VNCSetEncodings class],
                            @3: [VNCFBUpdateRequest class],
                            @4: [VNCKeyboardEvent class],
                            @5: [VNCPointerEvent class],
                            @6: [VNCClientCutText class]};
    return [dict objectForKey:[NSNumber numberWithUnsignedChar:type]];
}

- (id)initByReading:(VNCHandle *)handle {
    if ((self = [super init])) {
    }
    return self;
}

@end
