//
//  BSUnicodeConstants.h
//  UnicodeConverter
//
//  Created by Steve Baker on 2/21/16.
//  Copyright © 2016 Beepscore LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Constants for use by unit tests
 */
@interface BSUnicodeConstants : NSObject

// unicode escape starts with \u or \U
// Greek letter beta β \u03b2
// http://justskins.com/forums/escape-sequence-for-unicode-114988.html
extern unichar const beta;

// Greek letter capital gamma Γ \u0393
// http://blog.ablepear.com/2010/07/objective-c-tuesdays-unicode-string.html
extern NSString *gammaString;

// ¢ u\00A2
extern NSString *centString;

// € u\20AC
extern NSString *euroString;

// 𐍈 u\10348
// https://en.wikipedia.org/wiki/UTF-8
// https://en.wikipedia.org/wiki/Hwair
extern NSString *hwairString;

@end
