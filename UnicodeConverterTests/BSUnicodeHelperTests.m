//
//  BSUnicodeHelperTests.m
//  UnicodeConverter
//
//  Created by Steve Baker on 2/21/16.
//  Copyright © 2016 Beepscore LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BSUnicodeHelper.h"
#import "BSUnicodeConstants.h"

@interface BSUnicodeHelperTests : XCTestCase

@end

@implementation BSUnicodeHelperTests

#pragma mark - testBytesFromString

- (void)testBytesFromStringEmpty {
    NSString *string = @"";
    uint8_t* buffer = [BSUnicodeHelper bytesFromString:string encoding:NSUTF8StringEncoding];
    XCTAssertEqual(0x00, buffer[0]);
}

- (void)testBytesFromStringa {
    NSString *string = @"a";
    uint8_t* buffer = [BSUnicodeHelper bytesFromString:string encoding:NSUTF8StringEncoding];
    // as decimal
    XCTAssertEqual(97, buffer[0]);
    // as hex
    XCTAssertEqual(0x61, buffer[0]);
}

- (void)testBytesFromStringab {
    NSString *string = @"ab";
    uint8_t* buffer = [BSUnicodeHelper bytesFromString:string encoding:NSUTF8StringEncoding];
    XCTAssertEqual(0x61, buffer[0]);
    XCTAssertEqual(0x62, buffer[1]);
}

- (void)testBytesFromUTF8StringEuro {
    uint8_t* buffer = [BSUnicodeHelper bytesFromString:euroString encoding:NSUTF8StringEncoding];
    // expected values from Wikipedia example
    // https://en.wikipedia.org/wiki/UTF-8
    XCTAssertEqual(0xe2, buffer[0]);
    XCTAssertEqual(0x82, buffer[1]);
    XCTAssertEqual(0xac, buffer[2]);
}

- (void)testBytesFromUTF8StringHwair {
    uint8_t* buffer = [BSUnicodeHelper bytesFromString:hwairString encoding:NSUTF8StringEncoding];
    // expected values from Wikipedia example
    XCTAssertEqual(0xF0, buffer[0]);
    XCTAssertEqual(0x90, buffer[1]);
    XCTAssertEqual(0x8D, buffer[2]);
    XCTAssertEqual(0x88, buffer[3]);
}

- (void)testBytesFromUTF8StringEuroHwair {
    NSString *string = @"€𐍈";
    uint8_t* buffer = [BSUnicodeHelper bytesFromString:string encoding:NSUTF8StringEncoding];
    // expected values from Wikipedia example
    // https://en.wikipedia.org/wiki/UTF-8
    // https://en.wikipedia.org/wiki/Hwair
    XCTAssertEqual(0xe2, buffer[0]);
    XCTAssertEqual(0x82, buffer[1]);
    XCTAssertEqual(0xac, buffer[2]);
    XCTAssertEqual(0xF0, buffer[3]);
    XCTAssertEqual(0x90, buffer[4]);
    XCTAssertEqual(0x8D, buffer[5]);
    XCTAssertEqual(0x88, buffer[6]);
}

#pragma mark -

- (void)testBytesFromStringTwo {
    NSString *string = @"a";
    BSUnicodeHelper *converter = [[BSUnicodeHelper alloc] init];
    uint8_t* buffer = [converter bytesFromStringTwo:string encoding:NSUTF8StringEncoding];
    XCTAssertEqual(97, buffer[0]);
    XCTAssertEqual(0x61, buffer[0]);
}

#pragma mark - testDataFromStringEncodingUTF8Bytes

- (void)testDataFromStringEncodingUTF8Bytes {
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

        NSData *data = [BSUnicodeHelper dataFromString:testString
                                                  encoding:NSUTF8StringEncoding];
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

#pragma mark -

- (void)testDataFromStringEncodingUTF8CharactersOneByte {
    NSDictionary* testDict = @{@"": @0,
                               @"a": @1,
                               @"testing": @7
                               };
    
    for (NSString* string in testDict) {
        NSData *data = [BSUnicodeHelper dataFromString:string
                                                  encoding:NSUTF8StringEncoding];
        int expected = [testDict[string] intValue];
        XCTAssertEqual(expected, [data length], @"%@", string);
    }
}

- (void)testDataFromStringEncodingUTF8CharactersTwoByte {
    NSDictionary* testDict = @{@"ñ": @2,
                               };

    for (NSString* string in testDict) {
        NSData *data = [BSUnicodeHelper dataFromString:string
                                                 encoding:NSUTF8StringEncoding];
        int expected = [testDict[string] intValue];
        XCTAssertEqual(expected, [data length], @"%@", string);
    }
}

- (void)testDataFromStringEncodingUTF8abcHwairEurof {
    NSString *testString = @"abc𐍈€f";
    NSData *actualUTF8Data = [BSUnicodeHelper dataFromString:testString
                                                    encoding:NSUTF8StringEncoding];
    uint8_t expectedUTF8Bytes[] = {0x61, 0x62, 0x63,
        0xf0, 0x90, 0x8d, 0x88,
        0xe2, 0x82, 0xac,
        0x66};
    NSData *expectedUTF8Data = [NSData dataWithBytes:expectedUTF8Bytes length:11];
    XCTAssertEqualObjects(expectedUTF8Data, actualUTF8Data);
}

@end