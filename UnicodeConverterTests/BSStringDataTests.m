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

#pragma mark - encode as Unicode

- (void)testStringDataUsingEncodingUnicodeabc {
    NSString *testString = @"abc";
    // encode string to Unicode
    NSData *actualUnicodeData = [testString dataUsingEncoding:NSUnicodeStringEncoding];

    // Expect prepended byte order marker, little endian, 2 bytes/character
    uint8_t expectedUnicodeBytes[] = {0xff, 0xfe,
        0x61, 0x00,
        0x62, 0x00,
        0x63, 0x00};
    NSData *expectedUnicodeData = [NSData dataWithBytes:expectedUnicodeBytes length:8];

    XCTAssertEqualObjects(expectedUnicodeData, actualUnicodeData);
}

- (void)testStringDataUsingEncodingUnicodeaBetaCentHwairEurof {
    NSString *testString = @"aβ¢𐍈€f";
    // encode string to Unicode
    NSData *actualUnicodeData = [testString dataUsingEncoding:NSUnicodeStringEncoding];

    // Expect prepended byte order marker, little endian, 2 or 3 bytes/character
    uint8_t expectedUnicodeBytes[] = {0xff, 0xfe,
        0x61, 0x00,
        0xb2, 0x03,
        0xa2, 0x00,
        0x00, 0xd8, 0x48,
        0xdf, 0xac, 0x20,
        0x66, 0x00};
    NSData *expectedUnicodeData = [NSData dataWithBytes:expectedUnicodeBytes length:16];

    XCTAssertEqualObjects(expectedUnicodeData, actualUnicodeData);
}

#pragma mark - encode as UTF-8

- (void)testStringDataUsingEncodingUTF8abc {
    NSString *testString = @"abc";
    // encode string to UTF-8
    NSData *actualUTF8Data = [testString dataUsingEncoding:NSUTF8StringEncoding];

    uint8_t expectedUTF8Bytes[] = {0x61, 0x62, 0x63};
    // Expected length is (3 characters * 1 byte/character) = 3 bytes
    NSData *expectedUTF8Data = [NSData dataWithBytes:expectedUTF8Bytes length:3];

    XCTAssertEqualObjects(expectedUTF8Data, actualUTF8Data);
}

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
    // encode string to UTF-8
    NSData *actualUTF8Data = [testString dataUsingEncoding:NSUTF8StringEncoding];

    uint8_t expectedUTF8Bytes[] = {0xc3, 0xb1};
    NSData *expectedUTF8Data = [NSData dataWithBytes:expectedUTF8Bytes length:2];

    XCTAssertEqualObjects(expectedUTF8Data, actualUTF8Data);
}

- (void)testStringDataUsingEncodingUTF8abcHwairEurof {
    NSString *testString = @"abc𐍈€f";
    // encode string to UTF-8
    NSData *actualUTF8Data = [testString dataUsingEncoding:NSUTF8StringEncoding];

    uint8_t expectedUTF8Bytes[] = {0x61, 0x62, 0x63,
        0xf0, 0x90, 0x8d, 0x88,
        0xe2, 0x82, 0xac,
        0x66};
    NSData *expectedUTF8Data = [NSData dataWithBytes:expectedUTF8Bytes length:11];

    XCTAssertEqualObjects(expectedUTF8Data, actualUTF8Data);
}

- (void)testStringDataUsingEncodingUTF8aBetaCentHwairEurof {
    NSString *testString = @"aβ¢𐍈€f";
    // encode string to UTF-8
    NSData *actualUTF8Data = [testString dataUsingEncoding:NSUTF8StringEncoding];

    // Expect no byte order marker, 2 to 4 bytes/character
    uint8_t expectedUTF8Bytes[] = {0x61,
        0xce, 0xb2,
        0xc2, 0xa2,
        0xf0, 0x90, 0x8d, 0x88,
        0xe2, 0x82, 0xac,
        0x66};
    NSData *expectedUTF8Data = [NSData dataWithBytes:expectedUTF8Bytes length:13];

    XCTAssertEqualObjects(expectedUTF8Data, actualUTF8Data);
}

#pragma mark - encode as UTF-32

- (void)testStringDataUsingEncodingUTF32abc {
    NSString *testString = @"abc";
    // encode string to UTF-32, don't specify endianness
    NSData *actualUTF32Data = [testString dataUsingEncoding:NSUTF32StringEncoding];

    // Expect BOM little endian 4 bytes + (3 characters * 4 bytes/character) = 16 bytes
    uint8_t expectedUTF32Bytes[] = {0xff, 0xfe, 0x00, 0x00,
        0x61, 0x00, 0x00, 0x00,
        0x62, 0x00, 0x00, 0x00,
        0x63, 0x00, 0x00, 0x00
    };
    NSData *expectedUTF32Data = [NSData dataWithBytes:expectedUTF32Bytes length:16];

    XCTAssertEqualObjects(expectedUTF32Data, actualUTF32Data);
}

- (void)testStringDataUsingEncodingUTF32BigEndianabc {
    NSString *testString = @"abc";
    NSData *actualUTF32DataBigEndian = [testString dataUsingEncoding:NSUTF32BigEndianStringEncoding];

    // Expect no prepended byte order marker, big endian (3 characters * 4 bytes/character)
    uint8_t expectedUTF32Bytes[] = {
        0x00, 0x00, 0x00, 0x061,
        0x00, 0x00, 0x00, 0x062,
        0x00, 0x00, 0x00, 0x063
    };
    NSData *expectedUTF32Data = [NSData dataWithBytes:expectedUTF32Bytes length:12];

    XCTAssertEqualObjects(expectedUTF32Data, actualUTF32DataBigEndian);
}

- (void)testStringDataUsingEncodingUTF32LittleEndianabc {
    NSString *testString = @"abc";
    NSData *actualUTF32DataLittleEndian = [testString dataUsingEncoding:NSUTF32LittleEndianStringEncoding];

    // Expect no prepended byte order marker, little endian (3 characters * 4 bytes/character)
    uint8_t expectedUTF32Bytes[] = {
        0x61, 0x00, 0x00, 0x00,
        0x62, 0x00, 0x00, 0x00,
        0x63, 0x00, 0x00, 0x00
    };
    NSData *expectedUTF32Data = [NSData dataWithBytes:expectedUTF32Bytes length:12];

    XCTAssertEqualObjects(expectedUTF32Data, actualUTF32DataLittleEndian);
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

        // encode NSString to UTF-8 data
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];

        // decode UTF-8 data back to NSString
        NSString *actual = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        XCTAssertEqualObjects(string, actual);
    }
}

@end
