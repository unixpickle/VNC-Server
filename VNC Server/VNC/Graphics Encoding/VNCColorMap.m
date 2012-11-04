//
//  VNCColorMap.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCColorMap.h"

@implementation VNCColorMap

@synthesize numberOfEntries;

- (id)initWithNumberOfEntries:(NSUInteger)aCount {
    if ((self = [super init])) {
        numberOfEntries = aCount;
        entries = (VNCColorMapEntry *)malloc(sizeof(VNCColorMapEntry) * aCount);
        bzero(entries, sizeof(VNCColorMapEntry) * aCount);
    }
    return self;
}

- (VNCColorMapEntry)colorMapEntryAtIndex:(NSUInteger)index {
    return entries[index];
}

- (void)setColorMapEntry:(VNCColorMapEntry)entry atIndex:(NSUInteger)index {
    entries[index] = entry;
    if (changesLength == 0) {
        startChanges = index;
        changesLength = 1;
    } else if (index >= startChanges + changesLength) {
        changesLength = index - startChanges + 1;
    } else if (index < startChanges) {
        changesLength += startChanges - index;
        startChanges = index;
    }
}

#pragma mark Changes

- (NSUInteger)startOfChanges {
    return startChanges;
}

- (NSUInteger)numberOfChanges {
    return changesLength;
}

- (void)markNoChanges {
    startChanges = 0;
    changesLength = 0;
}

#pragma mark Memory

- (void)dealloc {
    free(entries);
}

@end
