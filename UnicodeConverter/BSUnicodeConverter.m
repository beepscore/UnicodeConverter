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

+ (NSData*)dataFromString:(NSString*)string encoding:(NSStringEncoding)encoding {
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

+ (uint8_t*)bytesFromStringTwo:(NSString*)string encoding:(NSStringEncoding)encoding {
    // http://stackoverflow.com/questions/8019647/how-to-use-nsstring-getbytesmaxlengthusedlengthencodingoptionsrangeremaini

    // http://stackoverflow.com/questions/8021926/getting-weird-characters-when-going-from-nsstring-to-bytes-and-then-back-to-nsst?rq=1

    // http://stackoverflow.com/questions/15038616/how-to-convert-between-character-and-byte-position-in-objective-c-c-c
    //http://stackoverflow.com/questions/692564/concept-of-void-pointer-in-c-programming?rq=1

    // NSString.h NSUTF16StringEncoding is an alias for NSUnicodeStringEncoding
    NSUInteger numberOfBytes = [string lengthOfBytesUsingEncoding:encoding];
    
    // void* is a pointer to any type
    void *buffer = malloc(numberOfBytes);
    
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

+ (NSString*)stringFromData:(NSData*)data encoding:(NSStringEncoding)encoding {
    // http://iosdevelopertips.com/conversion/convert-nsdata-to-nsstring.html
    return [[NSString alloc] initWithData:data encoding:encoding];
}

@end
