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

@implementation BSUnicodeConverter

uint8_t codeUnit0 = 0;
uint8_t codeUnit1 = 0;
uint8_t codeUnit2 = 0;
uint8_t codeUnit3 = 0;

// replacement character "�" (U+FFFD)
//const uint32_t kReplacementCharacter = 0x0000fffd;
uint32_t const kReplacementCharacter = 0x0000fffd;


- (instancetype)init {
    self = [super init];
    if (self) {
        //self.buffer = nil;
        self.buffer = malloc(4);
    }
    return self;
}

+ (NSData*)dataFromString:(NSString*)string encoding:(NSStringEncoding)encoding {
    // http://stackoverflow.com/questions/901357/how-do-i-convert-an-nsstring-value-to-nsdata?rq=1
    // http://iosdevelopertips.com/conversion/convert-nsstring-to-nsdata.html
    return [string dataUsingEncoding:encoding];
}

+ (uint8_t*)bytesFromData:(NSData*)data {
    // http://stackoverflow.com/questions/724086/how-to-convert-nsdata-to-byte-array-in-iphone
    // Use uint8_t to get individual bytes.
    // You may choose any other data type, e.g. uint16, int32, char, uchar, ... .
    // Make sure data has at least number of bytes that a single element needs.
    // e.g. for int32, data length must be >= 4 bytes
    // Can we assume bytes are null terminated? Otherwise need to pass length?
    uint8_t *bytePtr = (uint8_t*)[data bytes];
    return bytePtr;
}

/**
 @return uint8_t
 */
+ (uint8_t)firstByteFromData:(NSData*)data {
    uint8_t *bytePtr = [BSUnicodeConverter bytesFromData:data];
    return bytePtr[0];
}

/**
 @return uint8_t
 */
+ (uint8_t)secondByteFromData:(NSData*)data {
    uint8_t *bytePtr = [BSUnicodeConverter bytesFromData:data];
    return bytePtr[1];
}

/**
 @return uint8_t
 */
+ (uint8_t)thirdByteFromData:(NSData*)data {
    uint8_t *bytePtr = [BSUnicodeConverter bytesFromData:data];
    return bytePtr[2];
}

/**
 @return uint8_t
 */
+ (uint8_t)fourthByteFromData:(NSData*)data {
    uint8_t *bytePtr = [BSUnicodeConverter bytesFromData:data];
    return bytePtr[3];
}

#pragma mark -

+ (uint8_t*)bytesFromString:(NSString*)string encoding:(NSStringEncoding)encoding {
    NSData *data = [string dataUsingEncoding:encoding];
    return [BSUnicodeConverter bytesFromData:data];
}

- (uint8_t*)bytesFromStringTwo:(NSString*)string encoding:(NSStringEncoding)encoding {
    // http://stackoverflow.com/questions/8019647/how-to-use-nsstring-getbytesmaxlengthusedlengthencodingoptionsrangeremaini

    // http://stackoverflow.com/questions/8021926/getting-weird-characters-when-going-from-nsstring-to-bytes-and-then-back-to-nsst?rq=1

    // http://stackoverflow.com/questions/15038616/how-to-convert-between-character-and-byte-position-in-objective-c-c-c
    //http://stackoverflow.com/questions/692564/concept-of-void-pointer-in-c-programming?rq=1

    // NSString.h NSUTF16StringEncoding is an alias for NSUnicodeStringEncoding
    NSUInteger numberOfBytes = [string lengthOfBytesUsingEncoding:encoding];

    // ARC doesn't automatically manage malloc memory. In dealloc call free.
    self.buffer = malloc(numberOfBytes);
    if (!self.buffer) {
        // memory allocation failed
        return nil;
    }
    NSUInteger usedLength = 0;
    // NSRangeFromString doesn't work, not sure why.
    // NSRange range = NSRangeFromString(message);
    NSRange range = NSMakeRange(0, [string length]);
    
    BOOL result = [string getBytes:self.buffer
                         maxLength:numberOfBytes
                        usedLength:&usedLength
                          encoding:encoding
                           options:0
                             range:range
                    remainingRange:NULL];
    
    if (!result) {
        return nil;
    } else {
        return self.buffer;
    }
}

+ (NSString*)stringFromData:(NSData*)data encoding:(NSStringEncoding)encoding {
    // http://stackoverflow.com/questions/2467844/convert-utf-8-encoded-nsdata-to-nsstring?lq=1
    // http://iosdevelopertips.com/conversion/convert-nsdata-to-nsstring.html
    return [[NSString alloc] initWithData:data encoding:encoding];
}

+ (NSUInteger)numberOfBytesToGet:(NSData *)data {
    // utf8 uses at most 4 bytes
    NSUInteger kNumberOfUtf8BytesMaximum = 4;
    // use if/else instead of trinary expression, looks more readable
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

+ (NSData *)unicodeCodePointFromUTF8Data:(NSData *)data
                                errorPtr:(NSError**)errorPtr {

    // no bytes
    if ((nil == data)
        || (0 == data.length)) {
        *errorPtr = [NSError errorWithDomain:@"BSUTF8DecodeError"
                                        code:BSUTF8DecodeErrorDataEmpty
                                    userInfo:nil];
        return nil;
    }

    // one byte
    NSData *firstData = [data subdataWithRange:NSMakeRange(0, 1)];
    uint8_t firstByte = [BSUnicodeConverter firstByteFromData:firstData];
    if ([BSUnicodeConverter isValidUTF8EncodedAsSingleByte:firstByte]) {
        return firstData;
    }

    // two byte sequence
    if ([BSUnicodeConverter isValidUTF8EncodedAsTwoBytesFirstByte:firstByte]) {
        return [self unicodeCodePointFromUTF8TwoBytes:data errorPtr:errorPtr];
    }

    // three byte sequence
    if ([BSUnicodeConverter isValidUTF8EncodedAsThreeBytesFirstByte:firstByte]) {
        return [self unicodeCodePointFromUTF8ThreeBytes:data errorPtr:errorPtr];
    }

    // four byte sequence
    if ([BSUnicodeConverter isValidUTF8EncodedAsFourBytesFirstByte:firstByte]) {
        return [self unicodeCodePointFromUTF8FourBytes:data errorPtr:errorPtr];
    }

    // default unknown error
    *errorPtr = [NSError errorWithDomain:@"BSUTF8DecodeError"
                                    code:BSUTF8DecodeErrorDataUnknown
                                userInfo:nil];
    return nil;
}

+ (NSData *)unicodeCodePointFromUTF8TwoBytes:(NSData *)data
                                    errorPtr:(NSError **)errorPtr {
    
    if ((nil == data)
        || (data.length < 2)) {
        *errorPtr = [NSError errorWithDomain:@"BSUTF8DecodeError"
                                        code:BSUTF8DecodeErrorInvalidTwoBytes
                                    userInfo:nil];
        return nil;
    }

    // this utf8 sequence has 2 bytes
    uint8_t firstByte = [BSUnicodeConverter firstByteFromData:data];
    uint8_t secondByte = [BSUnicodeConverter secondByteFromData:data];
    
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
        return nil;
    }
}

+ (NSData *)unicodeCodePointFromUTF8ThreeBytes:(NSData *)data
                                      errorPtr:(NSError **)errorPtr {
    if ((nil == data)
        || (data.length < 3)) {
        *errorPtr = [NSError errorWithDomain:@"BSUTF8DecodeError"
                                        code:BSUTF8DecodeErrorInvalidThreeBytes
                                    userInfo:nil];
        return nil;
    }

    // this utf8 sequence has 3 bytes
    uint8_t firstByte = [BSUnicodeConverter firstByteFromData:data];
    uint8_t secondByte = [BSUnicodeConverter secondByteFromData:data];
    uint8_t thirdByte = [BSUnicodeConverter thirdByteFromData:data];
    
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
        return nil;
    }
}

+ (NSData *)unicodeCodePointFromUTF8FourBytes:(NSData *)data
                                      errorPtr:(NSError **)errorPtr {
    if ((nil == data)
        || (data.length < 4)) {
        *errorPtr = [NSError errorWithDomain:@"BSUTF8DecodeError"
                                        code:BSUTF8DecodeErrorInvalidFourBytes
                                    userInfo:nil];
        return nil;
    }

    // this utf8 sequence has 4 bytes
    uint8_t firstByte = [BSUnicodeConverter firstByteFromData:data];
    uint8_t secondByte = [BSUnicodeConverter secondByteFromData:data];
    uint8_t thirdByte = [BSUnicodeConverter thirdByteFromData:data];
    uint8_t fourthByte = [BSUnicodeConverter fourthByteFromData:data];
    
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
            return nil;
        }

        const uint8_t bytes[] = {unicodeFirstByte, unicodeSecondByte, unicodeThirdByte};
        return [NSData dataWithBytes:bytes length:3];
        
    } else {
        *errorPtr = [NSError errorWithDomain:@"BSUTF8DecodeError"
                                        code:BSUTF8DecodeErrorInvalidFourBytes
                                    userInfo:nil];
        return nil;
    }
}

// TODO: shorten this method by extracting methods
//- (NSMutableData*)UTF32DataFromUTF8Data:(NSData*)data
//                               errorPtr:(NSError**)errorPtr {
//    // http://www.ios-developer.net/iphone-ipad-programmer/development/nsdata/nsdata-general
//
//    NSMutableData *utf32Data = [[NSMutableData alloc] init];
//
//    if (0 == data.length) {
//        *errorPtr = [NSError errorWithDomain:@"UTF8DecodeError"
//                                        code:BSUnicodeConverterErrorDataEmpty
//                                    userInfo:nil];
//        return nil;
//    }
//
//    // const int *dataBytes = [data bytes];
//
//    for (NSUInteger index = 0; index < data.length; index++) {
//
//        NSData *firstData = [data subdataWithRange:NSMakeRange(index, 1)];
//        UInt8 firstByte = [BSUnicodeConverter firstByteFromData:firstData];
//
//        if ([BSUnicodeConverter
//             isValidUTF8EncodedAsSingleByte:firstByte]) {
//             [utf32Data appendData:firstData];
//
//        } else if (![BSUnicodeConverter
//                     isValidFirstByteForMultiByteCodePoint:firstByte]) {
//            //if (self.buffer) {
//                //free(self.buffer);
//                //self.buffer = nil;
//            //}
//            //self.buffer = malloc(1);
//            //if (!self.buffer) {
//                // memory allocation failed
//            //    NSLog(@"memory allocation failed");
//            //    return utf32Data;
//            //} else {
//                self.buffer = (void *)&kReplacementCharacter;
//                NSData *replacementCharacterData = [NSData dataWithBytes:self.buffer
//                                                                  length:4];
//                [utf32Data appendData:replacementCharacterData];
//            //}
//
//        } else {
//
//            if (data.length >= 2) {
//                NSData *secondData = [data subdataWithRange:NSMakeRange(index+1, 1)];
//                UInt8 secondByte = [BSUnicodeConverter firstByteFromData:secondData];
//                if (![BSUnicodeConverter isValidSecondThirdOrFourthByteInCodePoint:secondByte]) {
//                    // TODO:
//                    // if well formed append bytes
//                    // if not, append replacement character and increment index by 1 byte
//                }
//                
//            }
//        }
//        
//    }
//    // append euro sign
//    int euroSign = 0x000020ac;
//    self.buffer = &euroSign;
//    NSData *euroSignData = [NSData dataWithBytes:self.buffer length:4];
//    [utf32Data appendData:euroSignData];
//    return utf32Data;
//    
//    // TODO: finish implementation for additional bytes and errors
//}

- (NSError*)UTF8DecodeErrorDataEmpty {
    return [NSError errorWithDomain:@"BSUTF8DecodeError"
                               code:BSUTF8DecodeErrorDataEmpty
                           userInfo:nil];
}

- (void)dealloc {
    if (self.buffer) {
        // free any malloc'ed memory
        //free(self.buffer);
        self.buffer = nil;
    }
}
    
@end
