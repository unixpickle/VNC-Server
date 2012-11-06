//
//  VNCClientCutText.h
//  VNC Server
//
//  Created by Alex Nichol on 11/6/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCClientPacket.h"

@interface VNCClientCutText : VNCClientPacket {
    NSString * cutText;
}

@property (readonly) NSString * cutText;

@end
