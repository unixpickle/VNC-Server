//
//  VNCAuthFlow.h
//  VNC Server
//
//  Created by Alex Nichol on 11/3/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface VNCAuthFlow : NSObject {
    NSString * password;
    NSData * randomData;
}

@property (readonly) NSData * randomData;

- (id)initWithPassword:(NSString *)thePassword;

- (void)generateRandomData;
- (BOOL)verifyResponse:(NSData *)data;

@end
