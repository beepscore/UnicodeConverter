//
//  BSUnicodeConverter.h
//  UnicodeConverter
//
//  Created by Steve Baker on 2/20/15.
//  Copyright (c) 2015 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSUnicodeConverter : NSObject

typedef NS_ENUM(NSUInteger, BSUTF8DecodeError) {
    BSUTF8DecodeErrorDataUnknown = 0,
    BSUTF8DecodeErrorDataEmpty = 1,
    BSUTF8DecodeErrorInvalidTwoBytes = 2,
    BSUTF8DecodeErrorInvalidThreeBytes = 3,
    BSUTF8DecodeErrorInvalidFourBytes = 4,
};

// replacement character "�" (U+FFFD)
FOUNDATION_EXPORT uint32_t const kReplacementCharacter;

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
 * A continuation byte is a non-first byte in a multi-byte encoding
 * http://stackoverflow.com/questions/9356169/utf-8-continuation-bytes
 * @return true if 2 most significant bits are 10
 */
+ (BOOL)isValidUTF8EncodedContinuationByte:(uint8_t)byte;

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
 * @return false if byte equals 0xC0, 0xC1 or is >= 0xF5
 * https://tools.ietf.org/html/rfc3629
 */
+ (BOOL)isValidUTF8EncodedOctet:(uint8_t)byte;

+ (NSUInteger)numberOfBytesToGet:(NSData *)data;

#pragma mark - decode UTF-8

/**
 * @param data may be nil or empty or contain one or more UTF-8 encoded characters
 * @return a single unicodeCodePoint starting at start of data
 * return nil if error, and set error
 */
+ (NSData *)unicodeCodePointFromUTF8Data:(NSData *)data
                                errorPtr:(NSError**)errorPtr;

/**
 * @param data may be nil or empty or start with a UTF-8 encoded two byte character
 * @return a single unicodeCodePoint starting at start of data
 * return nil if error, and set error
 */
+ (NSData *)unicodeCodePointFromUTF8TwoBytes:(NSData *)data
                                    errorPtr:(NSError **)errorPtr;

/**
 * @param data may be nil or empty or start with a UTF-8 encoded three byte character
 * @return a single unicodeCodePoint starting at start of data
 * return nil if error, and set error
 */
+ (NSData *)unicodeCodePointFromUTF8ThreeBytes:(NSData *)data
                                      errorPtr:(NSError **)errorPtr;

/**
 * @param data may be nil or empty or start with a UTF-8 encoded four byte character
 * @return a single unicodeCodePoint starting at start of data
 * return nil if error, and set error
 */
+ (NSData *)unicodeCodePointFromUTF8FourBytes:(NSData *)data
                                      errorPtr:(NSError **)errorPtr;

#pragma mark -

+ (NSString*)stringFromData:(NSData*)data
                   encoding:(NSStringEncoding)encoding;

/**
 @return UTF-32 encoded data
 @return replacement character "�" (U+FFFD) if decoding a character fails
 errorPtr describes error types
 */
//- (NSMutableData*)UTF32DataFromUTF8Data:(NSData*)data
//                               errorPtr:(NSError**)errorPtr;

@end
