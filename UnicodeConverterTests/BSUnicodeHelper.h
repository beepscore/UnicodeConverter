//
//  BSUnicodeHelper.h
//  UnicodeConverter
//
//  Created by Steve Baker on 2/21/16.
//  Copyright © 2016 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSUnicodeConverter.h"

/**
 * Helper for unit tests.
 * For ease of constructing tests, may use some Unicode related methods such as
 * NSString dataUsingEncoding:
 * Also used during development to practice using Unicode methods.
 */
@interface BSUnicodeHelper : NSObject

// void* is a pointer to any type
@property (assign) void* buffer;

/**
 * @return a pointer to an array of 8 bit bytes
 * return 0 if string is empty @""
 */
+ (uint8_t*)bytesFromString:(NSString *)string
                   encoding:(NSStringEncoding)encoding;

/** similar to bytesFromString:encoding: but with alternative implementation.
 *  Warning: This method may be removed in release version of software.
 *  Internal implementation is more cumbersome than bytesFromString.
 */
- (uint8_t*)bytesFromStringTwo:(NSString *)string
                      encoding:(NSStringEncoding)encoding;

@end
