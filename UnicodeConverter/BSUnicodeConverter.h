//
//  BSUnicodeConverter.h
//  UnicodeConverter
//
//  Created by Steve Baker on 2/20/15.
//  Copyright (c) 2015 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSUnicodeConverter : NSObject

+ (uint8_t*)bytesFromData:(NSData*)data;

+ (uint8_t*)bytesFromString:(NSString*)string
                   encoding:(NSStringEncoding)encoding;

+ (NSData*)dataFromString:(NSString*)string
                 encoding:(NSStringEncoding)encoding;

+ (NSUInteger)numberOfBytesToGet:(NSData *)data;

+ (NSString*)stringFromData:(NSData*)data
                   encoding:(NSStringEncoding)encoding;

/**
 @return first Unicode code point, ignores remaining data
 @return replacement character "�" (U+FFFD) if decoding fails
 errorPtr describes error types
 */
+ (uint32_t)codePointFromUTF8Data:(NSData*)data errorPtr:(NSError**)errorPtr;

/** Warning: This method may be removed in release version of software.
 Internal implementation is more cumbersome than bytesFromString.
  */
- (uint8_t*)bytesFromStringTwo:(NSString*)string
                      encoding:(NSStringEncoding)encoding;

@end
