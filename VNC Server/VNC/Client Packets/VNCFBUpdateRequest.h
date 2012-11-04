//
//  VNCFBUpdateRequest.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCClientPacket.h"

@interface VNCFBUpdateRequest : VNCClientPacket {
    UInt16 xposition;
    UInt16 yposition;
    UInt16 width;
    UInt16 height;
}

@property (readonly) UInt16 xposition;
@property (readonly) UInt16 yposition;
@property (readonly) UInt16 width;
@property (readonly) UInt16 height;

@end
