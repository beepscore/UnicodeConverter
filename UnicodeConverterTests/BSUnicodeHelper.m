//
//  BSUnicodeHelper.m
//  UnicodeConverter
//
//  Created by Steve Baker on 2/21/16.
//  Copyright © 2016 Beepscore LLC. All rights reserved.
//

#import "BSUnicodeHelper.h"
#import "BSUnicodeConverterPrivate.h"

@implementation BSUnicodeHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        //self.buffer = nil;
        self.buffer = malloc(4);
    }
    return self;
}

- (void)dealloc {
    if (self.buffer) {
        // free any malloc'ed memory
        //free(self.buffer);
        self.buffer = nil;
    }
}

+ (uint8_t*)bytesFromString:(NSString *)string encoding:(NSStringEncoding)encoding {
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

@end
