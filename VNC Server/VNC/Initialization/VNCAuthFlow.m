//
//  VNCAuthFlow.m
//  VNC Server
//
//  Created by Alex Nichol on 11/3/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCAuthFlow.h"

static UInt8 flipBits(UInt8);

@implementation VNCAuthFlow

@synthesize randomData;

- (id)initWithPassword:(NSString *)thePassword {
    if ((self = [super init])) {
        password = thePassword;
    }
    return self;
}

- (void)generateRandomData {
    char buff[16];
    for (int i = 0; i < 16; i++) {
        buff[i] = 0;//(char)arc4random();
    }
    randomData = [NSData dataWithBytes:buff length:16];
}

- (BOOL)verifyResponse:(NSData *)data {
    unsigned char output[16];
    char keyData[kCCKeySizeDES];
    bzero(keyData, kCCKeySizeDES);
    bzero(keyData, 8);
    memcpy(keyData, [password UTF8String], MIN(8, [password length]));
    for (int i = 0; i < 8; i++) {
        keyData[i] = (UInt8)flipBits((UInt8)keyData[i]);
    }
    CCCrypt(kCCEncrypt,
            kCCAlgorithmDES,
            kCCOptionECBMode,
            keyData,
            kCCKeySizeDES,
            NULL,
            (const unsigned char *)[randomData bytes],
            [randomData length],
            output,
            16,
            NULL);
    const char * bytes = (const char *)[data bytes];
    int res = memcmp(output, bytes, 16);
    return res == 0;
}

@end

static UInt8 flipBits(UInt8 i) {
    UInt8 newInt = 0;
    newInt = (i >> 7) & 1;
    newInt |= ((i >> 6) & 1) << 1;
    newInt |= ((i >> 5) & 1) << 2;
    newInt |= ((i >> 4) & 1) << 3;
    newInt |= ((i >> 3) & 1) << 4;
    newInt |= ((i >> 2) & 1) << 5;
    newInt |= ((i >> 1) & 1) << 6;
    newInt |= (i & 1) << 7;
    return newInt;
}
