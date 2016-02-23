//
//  BSStringDataTests.m
//  UnicodeConverter
//
//  Created by Steve Baker on 2/21/16.
//  Copyright © 2016 Beepscore LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BSUnicodeConstants.h"

/** This class uses Apple Cocoa framework methods.
 * In general, developers don't need to test Apple's code.
 * Use these tests to practice using the API.
 * http://stackoverflow.com/questions/901357/how-do-i-convert-an-nsstring-value-to-nsdata?rq=1
 * http://iosdevelopertips.com/conversion/convert-nsstring-to-nsdata.html
 */
@interface BSStringDataTests : XCTestCase

@end

@implementation BSStringDataTests

#pragma mark - testStringDataUsingEncoding

- (void)testStringDataUsingEncodingEncodingUTF8Bytes {
    // https://en.wikipedia.org/wiki/UTF-8
    NSString* betaString = [NSString stringWithCharacters:&beta length:1];

    NSArray* testArray = @[
                           // one byte
                           // character decimal hex
                           // A         65      0x41
                           @{@"testString":@"A", @"index":@0, @"expected":@65},
                           @{@"testString":@"A", @"index":@0, @"expected":@0x41},
                           // a         97      0x61
                           @{@"testString":@"a", @"index":@0, @"expected":@97},
                           @{@"testString":@"a", @"index":@0, @"expected":@0x61},
                           
                           // two bytes
                           @{@"testString":@"ab", @"index":@0, @"expected":@0x61},
                           @{@"testString":@"ab", @"index":@1, @"expected":@0x62},

                           @{@"testString":@"ñ", @"index":@0, @"expected":@0xc3},
                           @{@"testString":@"ñ", @"index":@1, @"expected":@0xb1},

                           @{@"testString":betaString, @"index":@0, @"expected":@0xce},
                           @{@"testString":betaString, @"index":@1, @"expected":@0xb2},

                           @{@"testString":gammaString, @"index":@0, @"expected":@0xce},
                           @{@"testString":gammaString, @"index":@1, @"expected":@0x93},

                           // three bytes
                           @{@"testString":euroString, @"index":@0, @"expected":@0xe2},
                           @{@"testString":euroString, @"index":@1, @"expected":@0x82},
                           @{@"testString":euroString, @"index":@2, @"expected":@0xac},

                           @{@"testString":@"ña", @"index":@0, @"expected":@0xc3},
                           @{@"testString":@"ña", @"index":@1, @"expected":@0xb1},
                           @{@"testString":@"ña", @"index":@2, @"expected":@0x61},

                           // four bytes
                           @{@"testString":hwairString, @"index":@0, @"expected":@0xF0},
                           @{@"testString":hwairString, @"index":@1, @"expected":@0x90},
                           @{@"testString":hwairString, @"index":@2, @"expected":@0x8D},
                           @{@"testString":hwairString, @"index":@3, @"expected":@0x88},
                           ];

    for (NSDictionary* testDict in testArray) {

        NSString *testString = testDict[@"testString"];
        int index = [testDict[@"index"] intValue];
        int expected = [testDict[@"expected"] intValue];

        NSData *data = [testString dataUsingEncoding:NSUTF8StringEncoding];
        uint8_t *bytePtr = (uint8_t*)[data bytes];
        int actual = bytePtr[index];

        // Used for diagnostic logging during development
//        NSLog(@"testString %@ index %d expected 0x%x actual 0x%x",
//                       testString, index, expected, actual);

        XCTAssertEqual(expected, actual,
                       @"testString %@ index %d expected 0x%x actual 0x%x",
                       testString, index, expected, actual);
    }
}

- (void)testStringDataUsingEncodingUTF8CharactersOneByte {
    NSDictionary* testDict = @{@"": @0,
                               @"a": @1,
                               @"testing": @7
                               };
    
    for (NSString* string in testDict) {
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        int expected = [testDict[string] intValue];
        XCTAssertEqual(expected, [data length], @"%@", string);
    }
}

- (void)testStringDataUsingEncodingUTF8enye {
    NSString *testString = @"ñ";
    uint8_t expectedUTF8Bytes[] = {0xc3, 0xb1};
    NSData *expectedUTF8Data = [NSData dataWithBytes:expectedUTF8Bytes length:2];

    NSData *actualUTF8Data = [testString dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedUTF8Data, actualUTF8Data);
}

- (void)testStringDataUsingEncodingUTF8abcHwairEurof {
    NSString *testString = @"abc𐍈€f";
    uint8_t expectedUTF8Bytes[] = {0x61, 0x62, 0x63,
        0xf0, 0x90, 0x8d, 0x88,
        0xe2, 0x82, 0xac,
        0x66};
    NSData *expectedUTF8Data = [NSData dataWithBytes:expectedUTF8Bytes length:11];

    NSData *actualUTF8Data = [testString dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedUTF8Data, actualUTF8Data);
}

- (void)testStringDataUsingEncodingUTF8aBetaCentHwairEurof {
    NSString *testString = @"aβ¢𐍈€f";
    uint8_t expectedUTF8Bytes[] = {0x61,
        0xce, 0xb2,
        0xc2, 0xa2,
        0xf0, 0x90, 0x8d, 0x88,
        0xe2, 0x82, 0xac,
        0x66};
    // Expected length is 13 bytes, not 6 characters * 3 bytes/character = 18 bytes
    NSData *expectedUTF8Data = [NSData dataWithBytes:expectedUTF8Bytes length:13];
    
    NSData *actualUTF8Data = [testString dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(expectedUTF8Data, actualUTF8Data);
}

#pragma mark - testStringInitWithDataEncoding

/**
 * http://stackoverflow.com/questions/2467844/convert-utf-8-encoded-nsdata-to-nsstring?lq=1
 * http://iosdevelopertips.com/conversion/convert-nsdata-to-nsstring.html
 */
- (void)testStringInitWithDataEncoding {
    NSArray* testStrings = @[@"testing",
                             @"español"];
    
    for (NSString* string in testStrings) {

        // encode NSString to data
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];

        // decode data back to NSString
        NSString *actual = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        XCTAssertEqualObjects(string, actual);
    }
}

@end
