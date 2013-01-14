//
//  VNCColorMap.h
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct VNCColorMapEntry {
    UInt16 red;
    UInt16 green;
    UInt16 blue;
} VNCColorMapEntry;

@interface VNCColorMap : NSObject {
    NSUInteger startChanges;
    NSUInteger changesLength;
    VNCColorMapEntry * entries;
    NSUInteger numberOfEntries;
}

@property (readonly) NSUInteger numberOfEntries;

- (id)initWithNumberOfEntries:(NSUInteger)aCount;

- (VNCColorMapEntry)colorMapEntryAtIndex:(NSUInteger)index;
- (void)setColorMapEntry:(VNCColorMapEntry)entry atIndex:(NSUInteger)index;
- (NSUInteger)indexByAddingColor:(VNCColorMapEntry)entry;

- (NSUInteger)startOfChanges;
- (NSUInteger)numberOfChanges;
- (void)markNoChanges;

@end
