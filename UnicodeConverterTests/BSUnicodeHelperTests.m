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

@end