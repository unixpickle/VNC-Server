//
//  main.m
//  VNC Server
//
//  Created by Alex Nichol on 11/3/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerMain.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        signal(SIGPIPE, SIG_IGN);
        ServerMain * main = [[ServerMain alloc] init];
        [main serverMain];
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}

