//
//  VNCServer.h
//  VNC Server
//
//  Created by Alex Nichol on 11/3/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VNCServerConnection.h"
#import "VNCFileHandle.h"
#include <sys/socket.h>
#include <netinet/in.h>

@class VNCServer;

@protocol VNCServerDelegate <NSObject>

@optional
- (void)server:(VNCServer *)theServer gotConnection:(VNCServerConnection *)connection;
- (void)server:(VNCServer *)theServer failedWithError:(NSError *)error;

@end

@interface VNCServer : NSObject {
    UInt16 port;
    NSThread * listenThread;
    int fd;
    
    __weak id<VNCServerDelegate> delegate;
}

@property (nonatomic, weak) id<VNCServerDelegate> delegate;

- (id)initWithPort:(UInt16)aPort;
- (BOOL)startServer;
- (void)cancelServer;

@end
