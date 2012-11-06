//
//  VNCCutTextPacket.h
//  VNC Server
//
//  Created by Alex Nichol on 11/6/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VNCHandle.h"

@interface VNCCutTextPacket : NSObject {
    NSString * cutText;
}

@property (nonatomic, strong) NSString * cutText;

- (NSData *)encodeServerCutText;

@end
