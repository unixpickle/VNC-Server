//
//  ServerMain.h
//  VNC Server
//
//  Created by Alex Nichol on 11/3/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VNCServer.h"

@interface ServerMain : NSObject <VNCServerDelegate, VNCServerConnectionDelegate> {
    VNCServer * server;
}

- (void)serverMain;

@end
