//
//  VNCVersion.m
//  VNC Server
//
//  Created by Alex Nichol on 11/3/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCVersion.h"

@implementation VNCVersion

@synthesize version;

- (id)initWithClientVersion:(VNCProtocolVersionNumber)aVersion {
    if ((self = [super init])) {
        version = aVersion;
    }
    return self;
}

- (id)initWithClientVersionString:(NSString *)string {
    if ((self = [super init])) {
        NSArray * spaced = [string componentsSeparatedByString:@" "];
        if ([spaced count] != 2) return nil;
        NSArray * versionParts = [[spaced lastObject] componentsSeparatedByString:@"."];
        if ([versionParts count] != 2) return nil;
        int versionGreater = [[versionParts objectAtIndex:0] intValue];
        int versionLesser = [[versionParts objectAtIndex:1] intValue];
        if (versionGreater != 3) return nil;
        if (versionLesser == 3) version = VNCProtocolVersionNumber003003;
        else if (versionLesser == 7) version = VNCProtocolVersionNumber003007;
        else if (versionLesser == 8) version = VNCProtocolVersionNumber003008;
        else return nil;
    }
    return self;
}

- (BOOL)shouldListSecurityTypes {
    return version >= VNCProtocolVersionNumber003007;
}

- (BOOL)shouldSendAuthenticationError {
    return version >= VNCProtocolVersionNumber003008;
}

- (BOOL)shouldSendSecurityResultOnNoAuth {
    return version >= VNCProtocolVersionNumber003008;
}

@end
