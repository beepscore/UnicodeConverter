//
//  BSUnicodeConverter.h
//  UnicodeConverter
//
//  Created by Steve Baker on 2/20/15.
//  Copyright (c) 2015 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSUnicodeConverter : NSObject

// void* is a pointer to any type
@property (assign) void* buffer;

+ (uint8_t*)bytesFromData:(NSData*)data;

+ (uint8_t*)bytesFromString:(NSString*)string
                   encoding:(NSStringEncoding)encoding;

+ (NSData*)dataFromString:(NSString*)string
                 encoding:(NSStringEncoding)encoding;

+ (BOOL)isValidFirstByteForSingleByteCodePoint:(UInt8)byte;
+ (BOOL)isValidFirstByteForTwoByteCodePoint:(UInt8)byte;
+ (BOOL)isValidFirstByteForThreeByteCodePoint:(UInt8)byte;
+ (BOOL)isValidFirstByteForFourByteCodePoint:(UInt8)byte;
+ (BOOL)isValidSecondThirdOrFourthByteInCodePoint:(UInt8)byte;

+ (NSUInteger)numberOfBytesToGet:(NSData *)data;

+ (NSString*)stringFromData:(NSData*)data
                   encoding:(NSStringEncoding)encoding;

/**
 @return UTF-32 encoded data
 @return replacement character "�" (U+FFFD) if decoding a character fails
 errorPtr describes error types
 */
- (NSMutableData*)UTF32DataFromUTF8Data:(NSData*)data
                               errorPtr:(NSError**)errorPtr;

/** Warning: This method may be removed in release version of software.
 Internal implementation is more cumbersome than bytesFromString.
  */
- (uint8_t*)bytesFromStringTwo:(NSString*)string
                      encoding:(NSStringEncoding)encoding;

@end
