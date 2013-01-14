//
//  VNCVersion.h
//  VNC Server
//
//  Created by Alex Nichol on 11/3/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    VNCProtocolVersionNumber003003,
    VNCProtocolVersionNumber003007,
    VNCProtocolVersionNumber003008
} VNCProtocolVersionNumber;

@interface VNCVersion : NSObject {
    VNCProtocolVersionNumber version;
}

@property (readonly) VNCProtocolVersionNumber version;

- (id)initWithClientVersion:(VNCProtocolVersionNumber)aVersion;
- (id)initWithClientVersionString:(NSString *)string;

- (BOOL)shouldListSecurityTypes;
- (BOOL)shouldSendAuthenticationError;
- (BOOL)shouldSendSecurityResultOnNoAuth;

@end
