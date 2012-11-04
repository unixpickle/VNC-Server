//
//  VNCSetEncodings.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCClientPacket.h"

@interface VNCSetEncodings : VNCClientPacket {
    NSArray * encodings;
}

@property (readonly) NSArray * encodings;

- (BOOL)includesEncoding:(SInt32)encoding;

@end
