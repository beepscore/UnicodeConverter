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

// U+03b2 Greek letter beta β
// http://justskins.com/forums/escape-sequence-for-unicode-114988.html
extern unichar const beta;

// U+0393 Greek letter capital gamma Γ
// http://blog.ablepear.com/2010/07/objective-c-tuesdays-unicode-string.html
extern NSString *gammaString;

// U+00A2 cent ¢
extern NSString *centString;

// U+20AC Euro €
extern NSString *euroString;

// U+10348 hwair 𐍈
// https://en.wikipedia.org/wiki/UTF-8
// https://en.wikipedia.org/wiki/Hwair
extern NSString *hwairString;

@end
