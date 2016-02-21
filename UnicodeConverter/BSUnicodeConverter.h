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
    BSUTF8DecodeErrorInvalidFourBytes = 4
};

typedef NS_ENUM(NSUInteger, BSDataError) {
    BSDataErrorUnknown = 0,
    BSDataErrorOutOfBounds = 1
};

// replacement character "�" (U+FFFD)
FOUNDATION_EXPORT uint32_t const kReplacementCharacter;

/**
 * replacement character is "�" (U+FFFD)
 * @return data containing 2 bytes {0xFF, 0xFD}
 * http://stackoverflow.com/questions/6143107/compiler-error-initializer-element-is-not-a-compile-time-constant#6143271
 */
+ (NSData *)kReplacementCharacterData;

+ (uint8_t*)bytesFromData:(NSData *)data;

/**
 * @return uint8_t
 * return 0 and set error if index is out of range of data
 */
+ (uint8_t)byteFromData:(NSData *)data
                atIndex:(NSInteger)index
               errorPtr:(NSError **)errorPtr;

#pragma mark - methods to check number of bytes in code point

/**
 * @return true if isValidUTF8EncodedOctet and most significant bit is 0
 */
+ (BOOL)isValidUTF8EncodedAsSingleByte:(uint8_t)byte;

/**
 * A continuation byte is a non-first byte in a multi-byte encoding
 * http://stackoverflow.com/questions/9356169/utf-8-continuation-bytes
 * @return true if isValidUTF8EncodedOctet and 2 most significant bits are 10
 */
+ (BOOL)isValidUTF8EncodedContinuationByte:(uint8_t)byte;

/**
 * @return true if isValidUTF8EncodedOctet and 3 most significant bits are 110
 */
+ (BOOL)isValidUTF8EncodedAsTwoBytesFirstByte:(uint8_t)byte;

/**
 * @return true if isValidUTF8EncodedOctet and 4 most significant bits are 1110
 */
+ (BOOL)isValidUTF8EncodedAsThreeBytesFirstByte:(uint8_t)byte;

/**
 * @return true if isValidUTF8EncodedOctet and 5 most significant bits are 11110
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
 * @param UTF8Data may be nil or empty or contain one or more UTF-8 encoded characters
 * @return a single unicodeCodePoint starting at start of data
 * return substitution character if error, and set error
 */
+ (NSData *)unicodeCodePointFromUTF8Data:(NSData *)UTF8Data
                                errorPtr:(NSError **)errorPtr;

/**
 * @param UTF8Data may be nil or empty or start with a UTF-8 encoded two byte character
 * @return a single unicodeCodePoint starting at start of data
 * return substitution character if error, and set error
 */
+ (NSData *)unicodeCodePointFromUTF8TwoBytes:(NSData *)UTF8Data
                                    errorPtr:(NSError **)errorPtr;

/**
 * @param UTF8Data may be nil or empty or start with a UTF-8 encoded three byte character
 * @return a single unicodeCodePoint starting at start of data
 * return substitution character if error, and set error
 */
+ (NSData *)unicodeCodePointFromUTF8ThreeBytes:(NSData *)UTF8Data
                                      errorPtr:(NSError **)errorPtr;

/**
 * @param UTF8Data may be nil or empty or start with a UTF-8 encoded four byte character
 * @return a single unicodeCodePoint starting at start of data
 * return substitution character if error, and set error
 */
+ (NSData *)unicodeCodePointFromUTF8FourBytes:(NSData *)UTF8Data
                                      errorPtr:(NSError **)errorPtr;

/**
 * @param UTF8Data contains UTF-8 encoded data, may be nil or empty
 * @return an array of unicodeCodePoint
 * return empty array if data is nil or empty.
 */
+ (NSArray *)unicodeCodePointsFromUTF8Data:(NSData *)UTF8Data;

#pragma mark -

+ (NSString*)stringFromData:(NSData *)data
                   encoding:(NSStringEncoding)encoding;

/**
 @return replacement character "�" (U+FFFD) if decoding a character fails
 errorPtr describes error types
 */

#pragma mark - encode UTF-32

/**
 * @param unicodeData may be nil or empty or contain one or more unicode code points
 * @return a single UTF-32 encoded value starting at start of data
 * return substitution character if error
 */
+ (uint32_t)UTF32EncodedCodePointFromUnicodeData:(NSData *)unicodeData
                                        errorPtr:(NSError **)errorPtr;

//- (NSMutableData*)UTF32DataFromUTF8Data:(NSData*)data
//                               errorPtr:(NSError**)errorPtr;

@end
