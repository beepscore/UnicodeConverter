//
//  BSUnicodeConverterTests.m
//  UnicodeConverterTests
//
//  Created by Steve Baker on 2/19/15.
//  Copyright (c) 2015 Beepscore LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BSUnicodeConverter.h"

@interface BSUnicodeConverterTests : XCTestCase

@end

@implementation BSUnicodeConverterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - testBytesFromString

- (void)testBytesFromStringEmpty {
    NSString *string = @"";
    uint8_t* buffer = [BSUnicodeConverter bytesFromString:string encoding:NSUTF8StringEncoding];
    XCTAssertEqual(0x00, buffer[0]);
}

- (void)testBytesFromStringa {
    NSString *string = @"a";
    uint8_t* buffer = [BSUnicodeConverter bytesFromString:string encoding:NSUTF8StringEncoding];
    // as decimal
    XCTAssertEqual(97, buffer[0]);
    // as hex
    XCTAssertEqual(0x61, buffer[0]);
}

- (void)testBytesFromStringab {
    NSString *string = @"ab";
    uint8_t* buffer = [BSUnicodeConverter bytesFromString:string encoding:NSUTF8StringEncoding];
    XCTAssertEqual(0x61, buffer[0]);
    XCTAssertEqual(0x62, buffer[1]);
}

- (void)testBytesFromUTF8StringEuro {
    NSString *string = @"€";
    uint8_t* buffer = [BSUnicodeConverter bytesFromString:string encoding:NSUTF8StringEncoding];
    // expected values from Wikipedia example
    // https://en.wikipedia.org/wiki/UTF-8
    XCTAssertEqual(0xe2, buffer[0]);
    XCTAssertEqual(0x82, buffer[1]);
    XCTAssertEqual(0xac, buffer[2]);
}

- (void)testBytesFromUTF8StringHwair {
    NSString *string = @"𐍈";
    uint8_t* buffer = [BSUnicodeConverter bytesFromString:string encoding:NSUTF8StringEncoding];
    // expected values from Wikipedia example
    // https://en.wikipedia.org/wiki/UTF-8
    // https://en.wikipedia.org/wiki/Hwair
    XCTAssertEqual(0xF0, buffer[0]);
    XCTAssertEqual(0x90, buffer[1]);
    XCTAssertEqual(0x8D, buffer[2]);
    XCTAssertEqual(0x88, buffer[3]);
}

- (void)testBytesFromUTF8StringEuroHwair {
    NSString *string = @"€𐍈";
    uint8_t* buffer = [BSUnicodeConverter bytesFromString:string encoding:NSUTF8StringEncoding];
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
    BSUnicodeConverter *converter = [[BSUnicodeConverter alloc] init];
    uint8_t* buffer = [converter bytesFromStringTwo:string encoding:NSUTF8StringEncoding];
    XCTAssertEqual(97, buffer[0]);
    XCTAssertEqual(0x61, buffer[0]);
}

#pragma mark - testIsValidFirstByteForSingleByteCodePoint

- (void)testIsValidFirstByteForSingleByteCodePointMostSignificantBitZero {
    XCTAssertTrue([BSUnicodeConverter isValidFirstByteForSingleByteCodePoint:0b00000000]);
    XCTAssertTrue([BSUnicodeConverter isValidFirstByteForSingleByteCodePoint:0b01111111]);
}

- (void)testIsValidFirstByteForSingleByteCodePointMostSignificantBitOne {
    XCTAssertFalse([BSUnicodeConverter isValidFirstByteForSingleByteCodePoint:0b10000000]);
    XCTAssertFalse([BSUnicodeConverter isValidFirstByteForSingleByteCodePoint:0b11111111]);
}

#pragma mark - testIsValidFirstByteForTwoByteCodePoint

- (void)testIsValidFirstByteForTwoByteCodePointMostSignificantBits110 {
    XCTAssertTrue([BSUnicodeConverter isValidFirstByteForTwoByteCodePoint:0b11000000]);
    XCTAssertTrue([BSUnicodeConverter isValidFirstByteForTwoByteCodePoint:0b11011111]);
}

- (void)testIsValidFirstByteForTwoByteCodePointFalse {
    XCTAssertFalse([BSUnicodeConverter isValidFirstByteForTwoByteCodePoint:0b00000000]);
    XCTAssertFalse([BSUnicodeConverter isValidFirstByteForTwoByteCodePoint:0b10000000]);
    XCTAssertFalse([BSUnicodeConverter isValidFirstByteForTwoByteCodePoint:0b11100000]);
}

#pragma mark - testIsValidFirstByteForThreeByteCodePoint

- (void)testIsValidFirstByteForThreeByteCodePointMostSignificantBits1110 {
    XCTAssertTrue([BSUnicodeConverter isValidFirstByteForThreeByteCodePoint:0b11100000]);
    XCTAssertTrue([BSUnicodeConverter isValidFirstByteForThreeByteCodePoint:0b11101111]);
}

- (void)testIsValidFirstByteForThreeByteCodePointFalse {
    XCTAssertFalse([BSUnicodeConverter isValidFirstByteForThreeByteCodePoint:0b00000000]);
    XCTAssertFalse([BSUnicodeConverter isValidFirstByteForThreeByteCodePoint:0b10000000]);
    XCTAssertFalse([BSUnicodeConverter isValidFirstByteForThreeByteCodePoint:0b11000000]);
    XCTAssertFalse([BSUnicodeConverter isValidFirstByteForThreeByteCodePoint:0b11110000]);
}

#pragma mark - testDataFromString

- (void)testDataFromStringBytes {
    // https://en.wikipedia.org/wiki/UTF-8

    // http://justskins.com/forums/escape-sequence-for-unicode-114988.html
    unichar beta=0x03b2;
    NSString* betaString = [NSString stringWithCharacters:&beta length:1];

    // unicode escape, starts with \u or \U
    // http://blog.ablepear.com/2010/07/objective-c-tuesdays-unicode-string.html
    // Greek letter capital gamma Γ
    NSString *gammaString = @"\u0393";

    NSArray* testArray = @[
                           // one byte
                           // character decimal hex
                           // A         65      41
                           // a         97      61
                           @{@"testString":@"A", @"byteIndex":@0, @"byteValue":@65},
                           @{@"testString":@"A", @"byteIndex":@0, @"byteValue":@0x41},
                           @{@"testString":@"a", @"byteIndex":@0, @"byteValue":@97},
                           @{@"testString":@"a", @"byteIndex":@0, @"byteValue":@0x61},
                           
                           // two bytes
                           @{@"testString":@"ñ", @"byteIndex":@0, @"byteValue":@0xc3},
                           @{@"testString":@"ñ", @"byteIndex":@1, @"byteValue":@0xb1},
                           @{@"testString":betaString, @"byteIndex":@0, @"byteValue":@0xce},
                           @{@"testString":betaString, @"byteIndex":@1, @"byteValue":@0xb2},
                           @{@"testString":gammaString, @"byteIndex":@0, @"byteValue":@0xce},
                           @{@"testString":gammaString, @"byteIndex":@1, @"byteValue":@0x93},
                           @{@"testString":@"ab", @"byteIndex":@0, @"byteValue":@0x61},
                           @{@"testString":@"ab", @"byteIndex":@1, @"byteValue":@0x62},
                           
                           // three bytes
                           @{@"testString":@"€", @"byteIndex":@0, @"byteValue":@0xe2},
                           @{@"testString":@"€", @"byteIndex":@1, @"byteValue":@0x82},
                           @{@"testString":@"€", @"byteIndex":@2, @"byteValue":@0xac},
                           @{@"testString":@"ña", @"byteIndex":@2, @"byteValue":@0x61},
                           
                           // four bytes
                           ];
    
    for (NSDictionary* testDict in testArray) {
        NSString *testString = testDict[@"testString"];
        NSData *data = [BSUnicodeConverter dataFromString:testString
                                               encoding:NSUTF8StringEncoding];

        uint8_t *bytePtr = (uint8_t*)[data bytes];
        
        //        NSInteger numberOfElements = [data length] / sizeof(uint8_t);
        //        for (int i = 0 ; i < numberOfElements; i ++) {
        //            NSLog(@"testString %@ byteIndex %d value %x",
        //                  testString, i, bytePtr[i]);
        //        }

        int expected = [testDict[@"byteValue"] intValue];
        int byteIndex = [testDict[@"byteIndex"] intValue];
        int actual = bytePtr[byteIndex];
        XCTAssertEqual(expected, actual, @"testString %@ byteIndex %d expected 0x%x actual 0x%x",
                       testString, byteIndex, expected, actual);
    }
}

- (void)testDataFromStringUTF8CharactersOneByte {
    NSDictionary* testDict = @{@"": @0,
                               @"a": @1,
                               @"testing": @7
                               };
    
    for (NSString* string in testDict) {
        NSData *data = [BSUnicodeConverter dataFromString:string encoding:NSUTF8StringEncoding];
        int expected = [testDict[string] intValue];
        XCTAssertEqual(expected, [data length], @"%@", string);
    }
}

- (void)testDataFromStringUTF8CharactersTwoByte {
    NSDictionary* testDict = @{@"ñ": @2,
                               };

    for (NSString* string in testDict) {
        NSData *data = [BSUnicodeConverter dataFromString:string encoding:NSUTF8StringEncoding];
        int expected = [testDict[string] intValue];
        XCTAssertEqual(expected, [data length], @"%@", string);
    }
}

#pragma mark -

- (void)testStringFromDataFromString {
    NSArray* testStrings = @[@"testing", @"español"];
    
    for (NSString* string in testStrings) {
        NSData *data = [BSUnicodeConverter dataFromString:string encoding:NSUTF8StringEncoding];
        NSString *actual = [BSUnicodeConverter stringFromData:data encoding:NSUTF8StringEncoding];
        XCTAssertEqualObjects(string, actual);
    }
}

//- (void)testUTF32DataFromUTF8DataA {
//    // set up
//    BSUnicodeConverter *converter = [[BSUnicodeConverter alloc] init];
//    NSString* testString = @"A";
//    NSData *utf8data = [BSUnicodeConverter dataFromString:testString
//                                             encoding:NSUTF8StringEncoding];
//    uint32_t expectedUTF32 = 0x00000041;
//    uint32_t *buffer = &expectedUTF32;
//    NSData *expected = [NSData dataWithBytes:buffer length:4];
//    NSError *error = nil;
//
//    // call method under test
//    NSMutableData* actual = [converter UTF32DataFromUTF8Data:utf8data
//                                                    errorPtr:&error];
//    XCTAssertNil(error);
//    XCTAssertEqualObjects(expected, actual, @"expected %@", expected);
//}

//- (void)testCodePointFromUTF8DataEuro {
//    BSUnicodeConverter *converter = [[BSUnicodeConverter alloc] init];
//    // euro sign U+20AC
//    NSString* testString = @"€";
//    NSData *utf8data = [BSUnicodeConverter dataFromString:testString
//                                             encoding:NSUTF8StringEncoding];
//
//    uint32_t expectedUTF32 = 0x000020ac;
//    uint32_t *buffer = &expectedUTF32;
//    NSData *expected = [NSData dataWithBytes:buffer length:4];
//
//    NSError *error = nil;
//
//    // call method under test
//    NSMutableData* actual = [converter UTF32DataFromUTF8Data:utf8data
//                                                    errorPtr:&error];
//    XCTAssertNil(error);
//    XCTAssertEqualObjects(expected, actual, @"expected %@", expected);
//}

@end
