//
//  VNCPixelFormatter.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VNCColorMap.h"

@interface VNCPixelFormatter : NSObject {
    VNCColorMap * colorMap;
}

- (NSUInteger)bytesPerPixel;
- (void)getPixel:(UInt8 *)output forRed:(UInt16)red green:(UInt16)green blue:(UInt16)blue;

- (BOOL)hasColorMap;
- (VNCColorMap *)colorMap;

@end
