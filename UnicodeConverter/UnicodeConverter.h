//
//  UnicodeConverter.h
//  UnicodeConverter
//
//  Created by Steve Baker on 2/20/15.
//  Copyright (c) 2015 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnicodeConverter : NSObject

+ (uint8_t*)bytesFromData:(NSData*)data;

+ (uint8_t*)bytesFromString:(NSString*)string encoding:(NSStringEncoding)encoding;

+ (uint8_t*)bytesFromStringTwo:(NSString*)string encoding:(NSStringEncoding)encoding;

+ (NSData*)dataFromString:(NSString*)string encoding:(NSStringEncoding)encoding;

+ (NSString*)stringFromData:(NSData*)data encoding:(NSStringEncoding)encoding;

@end
