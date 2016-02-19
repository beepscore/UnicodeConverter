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

/**
 * @return a pointer to an array of 8 bit bytes
 * return 0 if string is empty @""
 */
+ (uint8_t*)bytesFromString:(NSString*)string
                   encoding:(NSStringEncoding)encoding;

/** similar to bytesFromString:encoding: but with alternative implementation.
 *  Warning: This method may be removed in release version of software.
 *  Internal implementation is more cumbersome than bytesFromString.
 */
- (uint8_t*)bytesFromStringTwo:(NSString*)string
                      encoding:(NSStringEncoding)encoding;

+ (NSData*)dataFromString:(NSString*)string
                 encoding:(NSStringEncoding)encoding;

#pragma mark - methods to check number of bytes in code point

/**
 * @return true if most significant bit is 0
 */
+ (BOOL)isValidUTF8EncodedAsSingleByte:(uint8_t)byte;

/**
 * @return true if 3 most significant bits are 110
 */
+ (BOOL)isValidUTF8EncodedAsTwoBytesFirstByte:(uint8_t)byte;

/**
 * @return true if 4 most significant bits are 1110
 */
+ (BOOL)isValidUTF8EncodedAsThreeBytesFirstByte:(uint8_t)byte;

/**
 * @return true if 5 most significant bits are 11110
 */
+ (BOOL)isValidUTF8EncodedAsFourBytesFirstByte:(uint8_t)byte;

/**
 * @return true if 2 most significant bits are 10
 */
+ (BOOL)isValidSecondThirdOrFourthByteInCodePoint:(uint8_t)byte;

+ (NSUInteger)numberOfBytesToGet:(NSData *)data;

#pragma mark -

+ (NSString*)stringFromData:(NSData*)data
                   encoding:(NSStringEncoding)encoding;

/**
 @return UTF-32 encoded data
 @return replacement character "�" (U+FFFD) if decoding a character fails
 errorPtr describes error types
 */
- (NSMutableData*)UTF32DataFromUTF8Data:(NSData*)data
                               errorPtr:(NSError**)errorPtr;

@end
