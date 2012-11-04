//
//  VNCColorMapUpdate.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VNCColorMap.h"

@interface VNCColorMapUpdate : NSObject {
    UInt16 firstColor;
    UInt16 numberOfColors;
    VNCColorMap * colorMap;
}

@property (readwrite) UInt16 firstColor;
@property (readwrite) UInt16 numberOfColors;
@property (nonatomic, retain) VNCColorMap * colorMap;

- (NSData *)encodePacket;

@end
