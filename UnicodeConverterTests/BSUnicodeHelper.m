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

+ (uint8_t*)bytesFromString:(NSString *)string encoding:(NSStringEncoding)encoding {
    NSData *data = [string dataUsingEncoding:encoding];
    return [BSUnicodeConverter bytesFromData:data];
}

@end
