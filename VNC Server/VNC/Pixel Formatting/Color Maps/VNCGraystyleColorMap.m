//
//  VNCGraystyleColorMap.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCGraystyleColorMap.h"

@implementation VNCGraystyleColorMap

- (id)initStandardMap {
    if ((self = [super initWithNumberOfEntries:256])) {
        for (int i = 0; i < 256; i++) {
            VNCColorMapEntry entry;
            entry.red = i * 257;
            entry.green = i * 257;
            entry.blue = i * 257;
            entries[i] = entry;
        }
        startChanges = 0;
        changesLength = 256;
    }
    return self;
}

- (NSUInteger)indexByAddingColor:(VNCColorMapEntry)entry {
    return (NSUInteger)round((float)(entry.red + entry.green + entry.blue) / (257 * 3.0));
}

@end
