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

typedef enum BSUnicodeConverterError : NSUInteger {
    BSUnicodeConverterError0 = 0,
    BSUnicodeConverterError1 = 1,
    BSUnicodeConverterError2 = 2,
} BSUnicodeConverterError;

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
    return ((byte >> 7) == 0b00000000);
}

+ (BOOL)isValidFirstByteForTwoByteCodePoint:(uint8_t)byte {
    return ((byte >> 5) == 0b00000110);
}

+ (BOOL)isValidFirstByteForThreeByteCodePoint:(uint8_t)byte {
    return ((byte >> 4) == 0b00001110);
}

+ (BOOL)isValidFirstByteForFourByteCodePoint:(uint8_t)byte {
    return ((byte >> 3) == 0b00011110);
}

+ (BOOL)isValidFirstByteForMultiByteCodePoint:(uint8_t)byte {
    return ([BSUnicodeConverter isValidFirstByteForTwoByteCodePoint:byte]
            || [BSUnicodeConverter isValidFirstByteForThreeByteCodePoint:byte]
            || [BSUnicodeConverter isValidFirstByteForFourByteCodePoint:byte]);
}

+ (BOOL)isValidSecondThirdOrFourthByteInCodePoint:(uint8_t)byte {
    return ((byte >> 6) == 0b00000010);
}

#pragma mark -

// TODO: implement and use this
+ (BOOL)isWellFormedUTF8ByteSequence:(UInt8*)bytes {
    return NO;
}

// TODO: shorten this method by extracting methods
- (NSMutableData*)UTF32DataFromUTF8Data:(NSData*)data
                               errorPtr:(NSError**)errorPtr {
    // https://en.wikipedia.org/wiki/UTF-8
    // http://www.ios-developer.net/iphone-ipad-programmer/development/nsdata/nsdata-general

    NSMutableData *utf32Data = [[NSMutableData alloc] init];

    if (0 == data.length) {
        *errorPtr = [NSError errorWithDomain:@"UTF8DecodeError"
                                        code:BSUnicodeConverterError0
                                    userInfo:nil];
        return nil;
    }

    // const int *dataBytes = [data bytes];

    for (NSUInteger index = 0; index < data.length; index++) {

        NSData *firstData = [data subdataWithRange:NSMakeRange(index, 1)];
        UInt8 firstByte = [BSUnicodeConverter firstByteFromData:firstData];

        if ([BSUnicodeConverter
             isValidUTF8EncodedAsSingleByte:firstByte]) {
             [utf32Data appendData:firstData];

        } else if (![BSUnicodeConverter
                     isValidFirstByteForMultiByteCodePoint:firstByte]) {
            //if (self.buffer) {
                //free(self.buffer);
                //self.buffer = nil;
            //}
            //self.buffer = malloc(1);
            //if (!self.buffer) {
                // memory allocation failed
            //    NSLog(@"memory allocation failed");
            //    return utf32Data;
            //} else {
                self.buffer = (void *)&kReplacementCharacter;
                NSData *replacementCharacterData = [NSData dataWithBytes:self.buffer
                                                                  length:4];
                [utf32Data appendData:replacementCharacterData];
            //}

        } else {

            if (data.length >= 2) {
                NSData *secondData = [data subdataWithRange:NSMakeRange(index+1, 1)];
                UInt8 secondByte = [BSUnicodeConverter firstByteFromData:secondData];
                if (![BSUnicodeConverter isValidSecondThirdOrFourthByteInCodePoint:secondByte]) {
                    // TODO:
                    // if well formed append bytes
                    // if not, append replacement character and increment index by 1 byte
                }
                
            }
        }
        
    }
    // append euro sign
    int euroSign = 0x000020ac;
    self.buffer = &euroSign;
    NSData *euroSignData = [NSData dataWithBytes:self.buffer length:4];
    [utf32Data appendData:euroSignData];
    return utf32Data;
    
    // TODO: finish implementation for additional bytes and errors
}

// reference implementation from Wikipedia UTF-8
// probably this is correct, but who knows?
// plan to reimplement and then check against this
//
//    unsigned read_code_point_from_utf8()
//    {
//        int code_unit1, code_unit2, code_unit3, code_unit4;
//
//        code_unit1 = getchar();
//        if (code_unit1 < 0x80) {
//            return code_unit1;
//        } else if (code_unit1 < 0xC2) {
//            /* continuation or overlong 2-byte sequence */
//            goto ERROR1;
//        } else if (code_unit1 < 0xE0) {
//            /* 2-byte sequence */
//            code_unit2 = getchar();
//            if ((code_unit2 & 0xC0) != 0x80) goto ERROR2;
//            return (code_unit1 << 6) + code_unit2 - 0x3080;
//        } else if (code_unit1 < 0xF0) {
//            /* 3-byte sequence */
//            code_unit2 = getchar();
//            if ((code_unit2 & 0xC0) != 0x80) goto ERROR2;
//            if (code_unit1 == 0xE0 && code_unit2 < 0xA0) goto ERROR2; /* overlong */
//            code_unit3 = getchar();
//            if ((code_unit3 & 0xC0) != 0x80) goto ERROR3;
//            return (code_unit1 << 12) + (code_unit2 << 6) + code_unit3 - 0xE2080;
//        } else if (code_unit1 < 0xF5) {
//            /* 4-byte sequence */
//            code_unit2 = getchar();
//            if ((code_unit2 & 0xC0) != 0x80) goto ERROR2;
//            if (code_unit1 == 0xF0 && code_unit2 < 0x90) goto ERROR2; /* overlong */
//            if (code_unit1 == 0xF4 && code_unit2 >= 0x90) goto ERROR2; /* > U+10FFFF */
//            code_unit3 = getchar();
//            if ((code_unit3 & 0xC0) != 0x80) goto ERROR3;
//            code_unit4 = getchar();
//            if ((code_unit4 & 0xC0) != 0x80) goto ERROR4;
//            return (code_unit1 << 18) + (code_unit2 << 12) + (code_unit3 << 6) + code_unit4 - 0x3C82080;
//        } else {
//            /* > U+10FFFF */
//            goto ERROR1;
//        }
//        
//    ERROR4:
//        ungetc(code_unit4, stdin);
//    ERROR3:
//        ungetc(code_unit3, stdin);
//    ERROR2:
//        ungetc(code_unit2, stdin);
//    ERROR1:
//        return code_unit1 + 0xDC00;
//    }

- (NSError*)utf8DecodeError1 {
    return [NSError errorWithDomain:@"BSUnicodeConverterError"
                               code:BSUnicodeConverterError1
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
