//
//  BSUnicodeConverterPrivate.h
//  UnicodeConverter
//
//  Created by Steve Baker on 2/23/16.
//  Copyright © 2016 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Expose properties for use by unit tests
 *  Declare "private" methods for use by unit tests.
 *  Use extension () instead of category (Tests) and import into .m file
 *  This way, compiler checks for incomplete implementation
 *  Reference
 *  http://stackoverflow.com/questions/1098550/unit-testing-of-private-methods-in-xcode
 *  http://lisles.net/accessing-private-methods-and-properties-in-objc-unit-tests/
 */
@interface BSUnicodeConverter()

/**
 * http://stackoverflow.com/questions/724086/how-to-convert-nsdata-to-byte-array-in-iphone
 * @return pointer to uint8_t to get individual bytes.
 * Use uint8_t to get individual bytes.
 * You may choose any other data type, e.g. uint16, int32, char, uchar, ... .
 * @param data should have at least the number of bytes that a single element needs.
 * e.g. for uint32_t, data.length must be >= 4 bytes
 */
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
 * NSData provides object oriented wrapper for a byte buffer.
 * NSData has helpful property data.length to help avoid accessing beyond range.
 * @param UTF8Data may be nil or empty or contain one or more UTF-8 encoded characters
 * @param numberOfBytesReadPtr points to the number of bytes read to get the returned code point
 * @param errorPtr points to an error with an error.domain and error.code
 * error is nil if no error
 * @return a single unicodeCodePoint starting at start of data
 * return replacement character "�" (U+FFFD) if error, and set error
 */
+ (NSData *)unicodeCodePointFromUTF8Data:(NSData *)UTF8Data
                                 atIndex:(NSInteger)index
                    numberOfBytesReadPtr:(NSNumber **)numberOfBytesReadPtr
                                errorPtr:(NSError **)errorPtr;

/**
 * @param UTF8Data may be nil or empty or start with a UTF-8 encoded two byte character
 * @param errorPtr points to an error with an error.domain and error.code
 * error is nil if no error
 * @return a single unicodeCodePoint starting at start of data
 * return substitution character if error, and set error
 */
+ (NSData *)unicodeCodePointFromUTF8TwoBytes:(NSData *)UTF8Data
                                     atIndex:(NSInteger)index
                                    errorPtr:(NSError **)errorPtr;

/**
 * @param UTF8Data may be nil or empty or start with a UTF-8 encoded three byte character
 * @param errorPtr points to an error with an error.domain and error.code
 * error is nil if no error
 * @return a single unicodeCodePoint starting at start of data
 * return substitution character if error, and set error
 */
+ (NSData *)unicodeCodePointFromUTF8ThreeBytes:(NSData *)UTF8Data
                                       atIndex:(NSInteger)index
                                      errorPtr:(NSError **)errorPtr;

/**
 * @param UTF8Data may be nil or empty or start with a UTF-8 encoded four byte character
 * @param errorPtr points to an error with an error.domain and error.code
 * error is nil if no error
 * @return a single unicodeCodePoint starting at start of data
 * return substitution character if error, and set error
 */
+ (NSData *)unicodeCodePointFromUTF8FourBytes:(NSData *)UTF8Data
                                      atIndex:(NSInteger)index
                                     errorPtr:(NSError **)errorPtr;

/**
 * Assumes unicodeCodePoint is valid
 * @param unicodeCodePoint
 * @return an NSData of UTF-32 encoded bytes in big endian order
 */
+ (NSData *)UTF32BigEndianFromUnicodeCodePoint:(uint32_t)unicodeCodePoint;

@end
