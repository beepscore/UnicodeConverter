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

// void* is a pointer to any type
void *buffer;

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

+ (uint8_t*)bytesFromString:(NSString*)string encoding:(NSStringEncoding)encoding {
    NSData *data = [string dataUsingEncoding:encoding];
    return [BSUnicodeConverter bytesFromData:data];
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

+ (uint32_t)codePointFromUTF8Data:(NSData*)data errorPtr:(NSError**)errorPtr {
    // https://en.wikipedia.org/wiki/UTF-8
    // http://www.ios-developer.net/iphone-ipad-programmer/development/nsdata/nsdata-general

    if (0 == data.length) {
        *errorPtr = [NSError errorWithDomain:@"UTF8DecodeError"
                                        code:BSUnicodeConverterError0
                                    userInfo:nil];
        return 0;
    }

    NSUInteger kNumberOfBytesToGet = [BSUnicodeConverter numberOfBytesToGet:data];
    NSData *codeUnitData = [data subdataWithRange:NSMakeRange(0, kNumberOfBytesToGet)];
    const int *codeUnitBytes = [codeUnitData bytes];
    
    if (1 == codeUnitData.length) {
        if (codeUnitBytes[0] < 0x80) {
            return codeUnitBytes[0];
        }
    }
    // return euro sign
    return 0xe282ac;

    // TODO: finish implementation for additional bytes and errors
}

// reference implementation from Wikipedia UTF-8
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

- (uint8_t*)bytesFromStringTwo:(NSString*)string encoding:(NSStringEncoding)encoding {
    // http://stackoverflow.com/questions/8019647/how-to-use-nsstring-getbytesmaxlengthusedlengthencodingoptionsrangeremaini

    // http://stackoverflow.com/questions/8021926/getting-weird-characters-when-going-from-nsstring-to-bytes-and-then-back-to-nsst?rq=1

    // http://stackoverflow.com/questions/15038616/how-to-convert-between-character-and-byte-position-in-objective-c-c-c
    //http://stackoverflow.com/questions/692564/concept-of-void-pointer-in-c-programming?rq=1

    // NSString.h NSUTF16StringEncoding is an alias for NSUnicodeStringEncoding
    NSUInteger numberOfBytes = [string lengthOfBytesUsingEncoding:encoding];

    // ARC doesn't automatically manage malloc memory. In dealloc call free.
    buffer = malloc(numberOfBytes);
    if (!buffer) {
        // memory allocation failed
        return nil;
    }
    NSUInteger usedLength = 0;
    // NSRangeFromString doesn't work, not sure why.
    // NSRange range = NSRangeFromString(message);
    NSRange range = NSMakeRange(0, [string length]);
    
    BOOL result = [string getBytes:buffer
                         maxLength:numberOfBytes
                        usedLength:&usedLength
                          encoding:encoding
                           options:0
                             range:range
                    remainingRange:NULL];
    
    if (!result) {
        return nil;
    } else {
        return buffer;
    }
}

- (void)dealloc {
    // free any malloc'ed memory
    free(buffer);
}
    
@end
