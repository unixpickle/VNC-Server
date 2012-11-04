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
    NSData * data = [NSData dataWithContentsOfFile:@"feces.jpg"]; // fecessquare for debugging
    NSBitmapImageRep * image = [[NSBitmapImageRep alloc] initWithData:data];
    frameBuffer = [[VNCFrameBuffer alloc] initWithWidth:image.pixelsWide height:image.pixelsHigh];
    for (NSUInteger y = 0; y < image.pixelsHigh; y++) {
        for (NSUInteger x = 0; x < image.pixelsWide; x++) {
            NSUInteger pixel[4];
            [image getPixel:pixel atX:x y:y];
            VNCFrameBufferPixel * p = [frameBuffer pixelAtX:x y:y];
            p->red = pixel[0] * 257;
            p->green = pixel[1] * 257;
            p->blue = pixel[2] * 257;
        }
    }
    
    server = [[VNCServer alloc] initWithPort:5900];
    server.delegate = self;
    [server startServer];
}

- (void)server:(VNCServer *)theServer gotConnection:(VNCServerConnection *)connection {
    connection.delegate = self;
    [connection beginNegotiationWithSize:CGSizeMake(frameBuffer.width, frameBuffer.height)
                                authType:VNCAuthenticationTypeVNCStandard
                                 authKey:@"password"];
}

- (void)serverConnectionAuthenticationFailed:(VNCServerConnection *)connection {
    NSLog(@"Client failed to authenticate");
}

- (void)serverConnectionAuthenticationSuccessful:(VNCServerConnection *)connection {
    NSLog(@"Client authenticated successfully");
}

- (void)serverConnection:(VNCServerConnection *)connection regionRequested:(VNCPixelRegion)region {
    [connection prepareToSendRegions:1];
    [connection sendRegion:region ofFrameBuffer:frameBuffer];
}

- (void)serverConnection:(VNCServerConnection *)connection failedWithError:(NSError *)error {
    NSLog(@"error: %@", error);
}

- (void)serverConnection:(VNCServerConnection *)connection keyboardEvent:(VNCKeyboardEvent *)event {
    NSLog(@"keyboard event: %@", event);
}

@end
