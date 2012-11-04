//
//  VNCPointerEvent.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCClientPacket.h"

@interface VNCPointerEvent : VNCClientPacket {
    UInt8 buttonMask;
    UInt16 pointerX;
    UInt16 pointerY;
}

@property (readonly) UInt8 buttonMask;
@property (readonly) UInt16 pointerX;
@property (readonly) UInt16 pointerY;

@end
