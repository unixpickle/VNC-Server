//
//  VNCZRLEPixelEncoder.m
//  VNC Server
//
//  Created by Alex Nichol on 11/4/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "VNCZRLEPixelEncoder.h"
#import "VNCRawPixelEncoder.h"

@interface VNCZRLEPixelEncoder (Private)

- (NSData *)compressChunk:(NSData *)data;
- (NSData *)encodeTileRegion:(VNCPixelRegion)region frameBuffer:(VNCFrameBuffer *)fb;

@end

@implementation VNCZRLEPixelEncoder

- (VNCZRLEEncodingSubtype)encodeSubtype {
    return encodeSubtype;
}

- (void)setEncodeSubtype:(VNCZRLEEncodingSubtype)value {
    encodeSubtype = value;
    if (encodeSubtype == VNCZRLEEncodingSubtypeRaw) {
        subEncoder = [[VNCRawPixelEncoder alloc] initWithFormatter:formatter];
    }
}

- (id)initWithFormatter:(VNCPixelFormatter *)aFormatter {
    VNCZRLEPixelFormatter * x = [[VNCZRLEPixelFormatter alloc] initByWrappingFormatter:aFormatter];
    if ((self = [super initWithFormatter:x])) {
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.opaque = Z_NULL;
        deflateInit(&stream, Z_BEST_COMPRESSION);
        self.encodeSubtype = VNCZRLEEncodingSubtypeRaw;
    }
    return self;
}

- (SInt32)encodingTypeValue {
    return 16;
}

- (NSData *)encodeRegion:(VNCPixelRegion)region frameBuffer:(VNCFrameBuffer *)fb {
    NSMutableData * toCompress = [NSMutableData data];
    NSUInteger tilesX = region.width / 64 + (region.width % 64 == 0 ? 0 : 1);
    NSUInteger tilesY = region.height / 64 + (region.height % 64 == 0 ? 0 : 1);
    for (NSUInteger y = 0; y < tilesY; y++) {
        for (NSUInteger x = 0; x < tilesX; x++) {
            VNCPixelRegion subRegion;
            subRegion.x = x * 64;
            subRegion.y = y * 64;
            if (subRegion.x + 64 >= region.width) {
                subRegion.width = region.width - subRegion.x;
            } else subRegion.width = 64;
            if (subRegion.y + 64 >= region.height) {
                subRegion.height = region.height - subRegion.y;
            } else subRegion.height = 64;
            [toCompress appendData:[self encodeTileRegion:subRegion frameBuffer:fb]];
        }
    }
    NSData * deflated = [self compressChunk:toCompress];
    NSMutableData * realData = [NSMutableData dataWithCapacity:4 + [deflated length]];
    UInt32 lenBig = CFSwapInt32HostToBig((uint32_t)[deflated length]);
    [realData appendBytes:&lenBig length:4];
    [realData appendData:deflated];
    return [realData copy];
}

#pragma mark Private

- (NSData *)compressChunk:(NSData *)data {
    NSMutableData * outputData = [NSMutableData data];
    const char outBuffer[512];
    stream.avail_in = (uInt)[data length];
    stream.next_in = (Bytef *)[data bytes];
    stream.avail_out = 512;
    stream.next_out = (Bytef *)outBuffer;
    
    // do the body of the deflation
    while (stream.avail_in != 0) {
        int res = deflate(&stream, Z_NO_FLUSH);
        NSAssert(res == Z_OK, @"Compression failed");
        if (stream.avail_out == 0) {
            [outputData appendBytes:outBuffer length:512];
            stream.next_out = (Bytef *)outBuffer;
            stream.avail_out = 512;
        }
    }
    
    [outputData appendBytes:outBuffer length:(512 - stream.avail_out)];
    
    stream.next_out = (Bytef *)outBuffer;
    stream.avail_out = 512;
    
    // perform the sync for the stream
    do {
        int res = deflate(&stream, Z_SYNC_FLUSH);
        NSAssert(res == Z_OK, @"Compression failed");
        if (stream.avail_out == 0) {
            [outputData appendBytes:outBuffer length:512];
            stream.next_out = (Bytef *)outBuffer;
            stream.avail_out = 512;
            continue;
        }
        break;
    } while (1);
    
    [outputData appendBytes:outBuffer length:(512 - stream.avail_out)];
    
    return [outputData copy];
}

- (NSData *)encodeTileRegion:(VNCPixelRegion)region frameBuffer:(VNCFrameBuffer *)fb {
    UInt8 subencodingValue = 0;
    
    if (encodeSubtype == VNCZRLEEncodingSubtypeRaw) {
        subencodingValue = 0;
    }
    
    NSMutableData * data = [NSMutableData data];
    [data appendBytes:&subencodingValue length:1];
    
    if (encodeSubtype == VNCZRLEEncodingSubtypeRaw) {
        [data appendData:[subEncoder encodeRegion:region frameBuffer:fb]];
    }
    
    return data;
}

@end
