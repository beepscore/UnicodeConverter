//
//  BSUnicodeConverter.h
//  UnicodeConverter
//
//  Created by Steve Baker on 2/20/15.
//  Copyright (c) 2015 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSUnicodeConverter : NSObject

FOUNDATION_EXPORT NSInteger const unicodeCodePointNumberOfBytes;
FOUNDATION_EXPORT NSInteger const UTF32NumberOfBytes;

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
 * @return data containing 2 bytes {0xFF, 0xFE}
 */
+ (NSData *)kByteOrderMarkerLittleEndianData;

/**
 * replacement character is "�" (U+FFFD)
 * @return data containing 3 bytes {0x00, 0xFF, 0xFD}
 * http://stackoverflow.com/questions/6143107/compiler-error-initializer-element-is-not-a-compile-time-constant#6143271
 */
+ (NSData *)kReplacementCharacterData;

#pragma mark - decode UTF-8

/**
 * @param UTF8Data contains UTF-8 encoded data, may be nil or empty
 * @return an NSArray of NSNumber uint32_t unicodeCodePoint
 * return empty array if UTF8Data is nil or empty.
 */
+ (NSArray *)unicodeCodePointsFromUTF8Data:(NSData *)UTF8Data;

#pragma mark - encode UTF-32

/**
 * @param unicodeData may be nil or empty or contain one or more unicode code points
 * each unicode code point is 1-3 bytes long
 * @param errorPtr points to an error with an error.domain and error.code
 * error is nil if no error
 * @return a single UTF-32 encoded value starting at start of data
 * format is big endian without byte order marker
 * This matches format of NSString dataUsingEncoding:NSUTF32BigEndianStringEncoding
 * return substitution character if error
 */
+ (uint32_t)UTF32EncodedCodePointFromUnicodeData:(NSData *)unicodeData
                                        errorPtr:(NSError **)errorPtr;

@end
