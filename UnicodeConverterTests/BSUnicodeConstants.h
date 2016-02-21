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

// http://justskins.com/forums/escape-sequence-for-unicode-114988.html
extern unichar const beta;

// unicode escape, starts with \u or \U
// http://blog.ablepear.com/2010/07/objective-c-tuesdays-unicode-string.html
// Greek letter capital gamma Γ
extern NSString *gammaString;
extern NSString *centString;
extern NSString *euroString;

// https://en.wikipedia.org/wiki/UTF-8
// https://en.wikipedia.org/wiki/Hwair
extern NSString *hwairString;

@end
