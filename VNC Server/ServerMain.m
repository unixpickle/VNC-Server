//
//  ServerMain.m
//  VNC Server
//
//  Created by Alex Nichol on 11/3/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ServerMain.h"

@implementation ServerMain

- (void)serverMain {
    server = [[VNCServer alloc] initWithPort:5900];
    server.delegate = self;
    [server startServer];
}

- (void)server:(VNCServer *)theServer gotConnection:(VNCServerConnection *)connection {
    connection.delegate = self;
    [connection beginNegotiationWithSize:CGSizeMake(1440, 900) authType:VNCAuthenticationTypeVNCStandard
                                 authKey:@"password"];
}

@end
