//
//  BSUnicodeConverter.m
//  UnicodeConverter
//
//  Created by Steve Baker on 2/20/15.
//  Copyright (c) 2015 Beepscore LLC. All rights reserved.
//
// This class provides wrapper methods, can change implementation.
// e.g. can change from standard encoding faculties to custom.

#import "BSUnicodeConverter.h"
#import "BSUnicodeConverterPrivate.h"

@implementation BSUnicodeConverter

NSInteger const unicodeCodePointNumberOfBytes = 3;
NSInteger const UTF32NumberOfBytes = 4;

uint8_t codeUnit0 = 0;
uint8_t codeUnit1 = 0;
uint8_t codeUnit2 = 0;
uint8_t codeUnit3 = 0;

uint32_t const kReplacementCharacter = 0x0000fffd;

+ (NSData *)kByteOrderMarkerLittleEndianData {
    const uint8_t bytes[] = {0xFF, 0xFE};
    return [NSData dataWithBytes:bytes length:2];
}

+ (NSData *)kReplacementCharacterData {
    const uint8_t bytes[] = {0x00, 0xFF, 0xFD};
    return [NSData dataWithBytes:bytes length:3];
}

+ (uint8_t*)bytesFromData:(NSData *)data {
    uint8_t *bytePtr = (uint8_t*)[data bytes];
    return bytePtr;
}

/**
 * @return uint8_t
 * return 0 and set error if index is out of range of data
 */
+ (uint8_t)byteFromData:(NSData *)data
                atIndex:(NSInteger)index
               errorPtr:(NSError **)errorPtr {
    if ((0 == data.length)
        || (index > (data.length - 1))) {
        *errorPtr = [NSError errorWithDomain:@"BSDataError"
                                        code:BSDataErrorOutOfBounds
                                    userInfo:nil];
        return 0;
    } else {
        uint8_t *bytePtr = [BSUnicodeConverter bytesFromData:data];
        return bytePtr[index];
    }
}

#pragma mark -

+ (NSUInteger)numberOfBytesToGet:(NSData *)data {
    // utf8 uses at most 4 bytes
    NSUInteger kNumberOfUtf8BytesMaximum = 4;
    // use if/else instead of ternary operator ?:, looks more readable
    if (data.length >= kNumberOfUtf8BytesMaximum) {
        return kNumberOfUtf8BytesMaximum;
    } else {
        return data.length;
    }
}

#pragma mark - methods to check number of bytes in code point

+ (BOOL)isValidUTF8EncodedAsSingleByte:(uint8_t)byte {
    return ([BSUnicodeConverter isValidUTF8EncodedOctet:byte]
            && ((byte >> 7) == 0b00000000));
}

+ (BOOL)isValidUTF8EncodedContinuationByte:(uint8_t)byte {
    return ([BSUnicodeConverter isValidUTF8EncodedOctet:byte]
            && ((byte >> 6) == 0b00000010));
}

+ (BOOL)isValidUTF8EncodedAsTwoBytesFirstByte:(uint8_t)byte {
    return ([BSUnicodeConverter isValidUTF8EncodedOctet:byte]
            && ((byte >> 5) == 0b00000110));
}

+ (BOOL)isValidUTF8EncodedAsThreeBytesFirstByte:(uint8_t)byte {
    return ([BSUnicodeConverter isValidUTF8EncodedOctet:byte]
            && ((byte >> 4) == 0b00001110));
}

+ (BOOL)isValidUTF8EncodedAsFourBytesFirstByte:(uint8_t)byte {
    return ([BSUnicodeConverter isValidUTF8EncodedOctet:byte]
            && ((byte >> 3) == 0b00011110));
}

+ (BOOL)isValidFirstByteForMultiByteCodePoint:(uint8_t)byte {
    return ([BSUnicodeConverter isValidUTF8EncodedAsTwoBytesFirstByte:byte]
            || [BSUnicodeConverter isValidUTF8EncodedAsThreeBytesFirstByte:byte]
            || [BSUnicodeConverter isValidUTF8EncodedAsFourBytesFirstByte:byte]);
}

#pragma mark -

/**
 * https://tools.ietf.org/html/rfc3629
 */
+ (BOOL)isValidUTF8EncodedOctet:(uint8_t)byte {
    if ((byte == 0xC0) || (byte == 0xC1) || (byte >= 0xF5)) {
        return NO;
    } else {
        return YES;
    }
}

+ (NSData *)unicodeCodePointFromUTF8Data:(NSData *)UTF8Data
                                 atIndex:(NSInteger)index
                                errorPtr:(NSError **)errorPtr {

    // no bytes
    if ((nil == UTF8Data)
        || (0 == UTF8Data.length)) {
        *errorPtr = [NSError errorWithDomain:@"BSUTF8DecodeError"
                                        code:BSUTF8DecodeErrorDataEmpty
                                    userInfo:nil];
        return [BSUnicodeConverter kReplacementCharacterData];
    }
    
    // one byte
    NSData *firstData = [UTF8Data subdataWithRange:NSMakeRange(index, 1)];
    uint8_t firstByte  = [BSUnicodeConverter byteFromData:UTF8Data
                                                  atIndex:index
                                                 errorPtr:errorPtr];
    if (*errorPtr) {
        return [BSUnicodeConverter kReplacementCharacterData];
    }

    if ([BSUnicodeConverter isValidUTF8EncodedAsSingleByte:firstByte]) {
        return firstData;
    }

    // two byte sequence
    if ([BSUnicodeConverter isValidUTF8EncodedAsTwoBytesFirstByte:firstByte]) {
        return [self unicodeCodePointFromUTF8TwoBytes:UTF8Data
                                              atIndex:index
                                             errorPtr:errorPtr];
    }

    // three byte sequence
    if ([BSUnicodeConverter isValidUTF8EncodedAsThreeBytesFirstByte:firstByte]) {
        return [self unicodeCodePointFromUTF8ThreeBytes:UTF8Data
                                                atIndex:index
                                               errorPtr:errorPtr];
    }

    // four byte sequence
    if ([BSUnicodeConverter isValidUTF8EncodedAsFourBytesFirstByte:firstByte]) {
        return [self unicodeCodePointFromUTF8FourBytes:UTF8Data
                                               atIndex:index
                                              errorPtr:errorPtr];
    }

    // default unknown error
    *errorPtr = [NSError errorWithDomain:@"BSUTF8DecodeError"
                                    code:BSUTF8DecodeErrorDataUnknown
                                userInfo:nil];
    return [BSUnicodeConverter kReplacementCharacterData];
}

+ (NSData *)unicodeCodePointFromUTF8TwoBytes:(NSData *)UTF8Data
                                     atIndex:(NSInteger)index
                                    errorPtr:(NSError **)errorPtr {
    if ((nil == UTF8Data)
        || ((index + 2) > UTF8Data.length)) {
        *errorPtr = [NSError errorWithDomain:@"BSUTF8DecodeError"
                                        code:BSUTF8DecodeErrorInvalidTwoBytes
                                    userInfo:nil];
        return [BSUnicodeConverter kReplacementCharacterData];
    }
    
    // this utf8 sequence has 2 bytes
    uint8_t firstByte  = [BSUnicodeConverter byteFromData:UTF8Data
                                                  atIndex:index
                                                 errorPtr:errorPtr];
    if (*errorPtr) {
        return [BSUnicodeConverter kReplacementCharacterData];
    }

    uint8_t secondByte  = [BSUnicodeConverter byteFromData:UTF8Data
                                                   atIndex:index + 1
                                                  errorPtr:errorPtr];
    if (*errorPtr) {
        return [BSUnicodeConverter kReplacementCharacterData];
    }

    if ([BSUnicodeConverter isValidUTF8EncodedContinuationByte:secondByte]) {
        
        // decode
        // the unicode code point needs 11 bits
        uint8_t firstByteLast5Bits = firstByte & 0b00011111;
        uint8_t firstByteLast5BitsMostSignificant3Bits = firstByteLast5Bits >> 2;
        uint8_t unicodeFirstByte = firstByteLast5BitsMostSignificant3Bits;

        uint8_t firstByteLast2Bits = firstByte & 0b00000011;
        uint8_t secondByteLast6Bits = secondByte & 0b00111111;
        uint8_t unicodeSecondByte = (firstByteLast2Bits << 6) + secondByteLast6Bits;
        const uint8_t bytes[] = {unicodeFirstByte, unicodeSecondByte};
        return [NSData dataWithBytes:bytes length:2];
        
    } else {
        *errorPtr = [NSError errorWithDomain:@"BSUTF8DecodeError"
                                        code:BSUTF8DecodeErrorInvalidTwoBytes
                                    userInfo:nil];
        return [BSUnicodeConverter kReplacementCharacterData];
    }
}

+ (NSData *)unicodeCodePointFromUTF8ThreeBytes:(NSData *)UTF8Data
                                       atIndex:(NSInteger)index
                                      errorPtr:(NSError **)errorPtr {
    if ((nil == UTF8Data)
        || ((index + 3) > UTF8Data.length)) {
        *errorPtr = [NSError errorWithDomain:@"BSUTF8DecodeError"
                                        code:BSUTF8DecodeErrorInvalidThreeBytes
                                    userInfo:nil];
        return [BSUnicodeConverter kReplacementCharacterData];
    }

    // this utf8 sequence has 3 bytes
    uint8_t firstByte  = [BSUnicodeConverter byteFromData:UTF8Data
                                                  atIndex:index
                                                 errorPtr:errorPtr];
    if (*errorPtr) {
        return [BSUnicodeConverter kReplacementCharacterData];
    }

    uint8_t secondByte  = [BSUnicodeConverter byteFromData:UTF8Data
                                                   atIndex:index + 1
                                                  errorPtr:errorPtr];
    if (*errorPtr) {
        return [BSUnicodeConverter kReplacementCharacterData];
    }

    uint8_t thirdByte = [BSUnicodeConverter byteFromData:UTF8Data
                                                 atIndex:index + 2
                                                errorPtr:errorPtr];
    if (*errorPtr) {
        return [BSUnicodeConverter kReplacementCharacterData];
    }

    if ([BSUnicodeConverter isValidUTF8EncodedContinuationByte:secondByte]
        && [BSUnicodeConverter isValidUTF8EncodedContinuationByte:thirdByte]) {
        
        // decode
        // the unicode code point needs 16 bits
        uint8_t firstByteLast4Bits = firstByte & 0b00001111;
        uint8_t secondByteMiddle4Bits = secondByte & 0b00111100;
        uint8_t unicodeFirstByte = (firstByteLast4Bits << 4) + (secondByteMiddle4Bits >> 2);

        uint8_t secondByteLast2Bits = secondByte & 0b00000011;
        uint8_t thirdByteLast6Bits = thirdByte & 0b00111111;
        uint8_t unicodeSecondByte = (secondByteLast2Bits << 6) + thirdByteLast6Bits;
        const uint8_t bytes[] = {unicodeFirstByte, unicodeSecondByte};
        return [NSData dataWithBytes:bytes length:2];
        
    } else {
        *errorPtr = [NSError errorWithDomain:@"BSUTF8DecodeError"
                                        code:BSUTF8DecodeErrorInvalidThreeBytes
                                    userInfo:nil];
        return [BSUnicodeConverter kReplacementCharacterData];
    }
}

+ (NSData *)unicodeCodePointFromUTF8FourBytes:(NSData *)UTF8Data
                                      atIndex:(NSInteger)index
                                      errorPtr:(NSError **)errorPtr {
    if ((nil == UTF8Data)
        || ((index + 4) > UTF8Data.length)) {
        *errorPtr = [NSError errorWithDomain:@"BSUTF8DecodeError"
                                        code:BSUTF8DecodeErrorInvalidFourBytes
                                    userInfo:nil];
        return [BSUnicodeConverter kReplacementCharacterData];
    }

    // this utf8 sequence has 4 bytes
    uint8_t firstByte  = [BSUnicodeConverter byteFromData:UTF8Data
                                                  atIndex:index
                                                 errorPtr:errorPtr];
    if (*errorPtr) {
        return [BSUnicodeConverter kReplacementCharacterData];
    }

    uint8_t secondByte  = [BSUnicodeConverter byteFromData:UTF8Data
                                                   atIndex:index + 1
                                                  errorPtr:errorPtr];
    if (*errorPtr) {
        return [BSUnicodeConverter kReplacementCharacterData];
    }

    uint8_t thirdByte = [BSUnicodeConverter byteFromData:UTF8Data
                                                 atIndex:index + 2
                                                errorPtr:errorPtr];
    if (*errorPtr) {
        return [BSUnicodeConverter kReplacementCharacterData];
    }

    uint8_t fourthByte = [BSUnicodeConverter byteFromData:UTF8Data
                                                  atIndex:index + 3
                                                 errorPtr:errorPtr];
    if (*errorPtr) {
        return [BSUnicodeConverter kReplacementCharacterData];
    }
    
    if ([BSUnicodeConverter isValidUTF8EncodedContinuationByte:secondByte]
        && [BSUnicodeConverter isValidUTF8EncodedContinuationByte:thirdByte]
        && [BSUnicodeConverter isValidUTF8EncodedContinuationByte:fourthByte]) {
        
        // decode
        // the unicode code point needs 21 bits
        uint8_t firstByteLast3Bits = firstByte & 0b00000111;
        uint8_t secondByteLast6Bits = secondByte & 0b00111111;
        uint8_t secondByteLast6Bits2MostSignificantBits = secondByteLast6Bits >> 4;
        uint8_t unicodeFirstByte = (firstByteLast3Bits << 5) + secondByteLast6Bits2MostSignificantBits;

        uint8_t secondByteLast4Bits = secondByte & 0b00001111;
        uint8_t thirdByteLast6Bits = thirdByte & 0b00111111;
        uint8_t thirdByteLast6Bits4MostSignificantBits = thirdByteLast6Bits >> 2;
        uint8_t unicodeSecondByte = (secondByteLast4Bits << 4) + thirdByteLast6Bits4MostSignificantBits;

        uint8_t thirdByteLast2Bits = thirdByte & 0b00000011;
        uint8_t fourthByteLast6Bits = fourthByte & 0b00111111;
        uint8_t unicodeThirdByte = (thirdByteLast2Bits << 6) + fourthByteLast6Bits;

        const uint32_t unicodeMaxValue = 0x01FFFF;
        uint32_t combinedBytes = ((uint32_t)unicodeFirstByte << 16)
        + ((uint32_t)unicodeSecondByte << 8) + unicodeThirdByte;
        if (combinedBytes > unicodeMaxValue) {
            *errorPtr = [NSError errorWithDomain:@"BSUTF8DecodeError"
                                            code:BSUTF8DecodeErrorInvalidFourBytes
                                        userInfo:nil];
            return [BSUnicodeConverter kReplacementCharacterData];
        }

        const uint8_t bytes[] = {unicodeFirstByte, unicodeSecondByte, unicodeThirdByte};
        return [NSData dataWithBytes:bytes length:3];
        
    } else {
        *errorPtr = [NSError errorWithDomain:@"BSUTF8DecodeError"
                                        code:BSUTF8DecodeErrorInvalidFourBytes
                                    userInfo:nil];
        return [BSUnicodeConverter kReplacementCharacterData];
    }
}

+ (NSData *)unicodeCodePointsFromUTF8Data:(NSData *)UTF8Data {
    return [NSData data];
}

#pragma mark - encode UTF-32

+ (uint32_t)UTF32EncodedCodePointFromUnicodeData:(NSData *)unicodeData
                                        errorPtr:(NSError **)errorPtr {
    // for big endian, first byte will always be 0
    uint32_t utf32 = 0;
    // set following 3 bytes
    for (NSInteger index = 0; index < unicodeCodePointNumberOfBytes; index++) {
        uint8_t byte = [BSUnicodeConverter byteFromData:unicodeData atIndex:index errorPtr:errorPtr];
        NSInteger powerOfTwo = 8 * ((unicodeCodePointNumberOfBytes - 1) - index);
        utf32 = utf32 + (((uint32_t)byte) << powerOfTwo);
    }
    return utf32;
}

- (NSError*)UTF8DecodeErrorDataEmpty {
    return [NSError errorWithDomain:@"BSUTF8DecodeError"
                               code:BSUTF8DecodeErrorDataEmpty
                           userInfo:nil];
}

@end
