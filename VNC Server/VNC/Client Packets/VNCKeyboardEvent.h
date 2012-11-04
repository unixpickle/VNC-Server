//
//  VNCKeyboardEvent.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCClientPacket.h"

@interface VNCKeyboardEvent : VNCClientPacket {
    UInt8 downFlag;
    UInt32 key;
}

@property (readonly) UInt8 downFlag;
@property (readonly) UInt32 key;

@end
