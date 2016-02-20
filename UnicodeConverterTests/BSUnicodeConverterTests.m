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

#pragma mark - constants
    // http://justskins.com/forums/escape-sequence-for-unicode-114988.html
    unichar const beta = 0x03b2;

    // unicode escape, starts with \u or \U
    // http://blog.ablepear.com/2010/07/objective-c-tuesdays-unicode-string.html
    // Greek letter capital gamma Γ
    NSString *gammaString = @"\u0393";
    NSString *centString = @"¢";
    NSString *euroString = @"€";

    // https://en.wikipedia.org/wiki/UTF-8
    // https://en.wikipedia.org/wiki/Hwair
    NSString *hwairString = @"𐍈";

#pragma mark -

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
    uint8_t* buffer = [BSUnicodeConverter bytesFromString:euroString encoding:NSUTF8StringEncoding];
    // expected values from Wikipedia example
    // https://en.wikipedia.org/wiki/UTF-8
    XCTAssertEqual(0xe2, buffer[0]);
    XCTAssertEqual(0x82, buffer[1]);
    XCTAssertEqual(0xac, buffer[2]);
}

- (void)testBytesFromUTF8StringHwair {
    uint8_t* buffer = [BSUnicodeConverter bytesFromString:hwairString encoding:NSUTF8StringEncoding];
    // expected values from Wikipedia example
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

#pragma mark - testIsValidUTF8EncodedAsSingleByte

- (void)testIsValidUTF8EncodedAsSingleByteMostSignificantBitZero {
    XCTAssertTrue([BSUnicodeConverter isValidUTF8EncodedAsSingleByte:0b00000000]);
    XCTAssertTrue([BSUnicodeConverter isValidUTF8EncodedAsSingleByte:0b01111111]);
}

- (void)testIsValidUTF8EncodedAsSingleByteMostSignificantBitOne {
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsSingleByte:0b10000000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsSingleByte:0b11111111]);
}

#pragma mark - testIsValidUTF8EncodedContinuationByte

- (void)testIsValidUTF8EncodedContinuationByteMostSignificantBits10 {
    XCTAssertTrue([BSUnicodeConverter isValidUTF8EncodedContinuationByte:0b10000000]);
    XCTAssertTrue([BSUnicodeConverter isValidUTF8EncodedContinuationByte:0b10111111]);
}

- (void)testIsValidUTF8EncodedContinuationByteFalse {
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedContinuationByte:0b00000000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedContinuationByte:0b01000000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedContinuationByte:0b11000000]);
}

#pragma mark - testIsValidUTF8EncodedAsTwoBytesFirstByte

- (void)testIsValidUTF8EncodedAsTwoBytesFirstByteMostSignificantBits110 {
    XCTAssertTrue([BSUnicodeConverter isValidUTF8EncodedAsTwoBytesFirstByte:0b11000000]);
    XCTAssertTrue([BSUnicodeConverter isValidUTF8EncodedAsTwoBytesFirstByte:0b11011111]);
}

- (void)testIsValidUTF8EncodedAsTwoBytesFirstByteFalse {
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsTwoBytesFirstByte:0b00000000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsTwoBytesFirstByte:0b10000000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsTwoBytesFirstByte:0b11100000]);
}

#pragma mark - testIsValidUTF8EncodedAsThreeBytesFirstByte

- (void)testIsValidUTF8EncodedAsThreeBytesFirstByteMostSignificantBits1110 {
    XCTAssertTrue([BSUnicodeConverter isValidUTF8EncodedAsThreeBytesFirstByte:0b11100000]);
    XCTAssertTrue([BSUnicodeConverter isValidUTF8EncodedAsThreeBytesFirstByte:0b11101111]);
}

- (void)testIsValidUTF8EncodedAsThreeBytesFirstByteFalse {
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsThreeBytesFirstByte:0b00000000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsThreeBytesFirstByte:0b10000000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsThreeBytesFirstByte:0b11000000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsThreeBytesFirstByte:0b11110000]);
}

#pragma mark - testIsValidUTF8EncodedAsFourBytesFirstByte

- (void)testIsValidUTF8EncodedAsFourBytesFirstByteMostSignificantBits11110 {
    XCTAssertTrue([BSUnicodeConverter isValidUTF8EncodedAsFourBytesFirstByte:0b11110000]);
    XCTAssertTrue([BSUnicodeConverter isValidUTF8EncodedAsFourBytesFirstByte:0b11110111]);
}

- (void)testIsValidUTF8EncodedAsFourBytesFirstByteFalse {
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsFourBytesFirstByte:0b00000000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsFourBytesFirstByte:0b10000000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsFourBytesFirstByte:0b11000000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsFourBytesFirstByte:0b11100000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsFourBytesFirstByte:0b11111000]);
}

#pragma mark -testDataFromStringEncodingUTF8Bytes

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

        NSData *data = [BSUnicodeConverter dataFromString:testString
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

#pragma mark - testunicodeCodePointFromUTF8TwoBytesErrorPtr

- (void)testunicodeCodePointFromUTF8TwoBytesErrorPtrCent {
    NSError *error;
    // use cent sign as shown in wikipedia utf8
    NSString *string = centString;
    uint8_t* bytes = [BSUnicodeConverter bytesFromString:string
                                                encoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:bytes length:2];
    
    // expected is the Unicode code point converted to NSData*
    uint8_t expectedBytes[] = {0x00, 0xA2};
    NSData *expected = [NSData dataWithBytes:expectedBytes length:2];
    XCTAssertEqualObjects(expected,
                          [BSUnicodeConverter unicodeCodePointFromUTF8TwoBytes:data
                                                                      errorPtr:&error]);
    XCTAssertNil(error);
}

#pragma mark - testunicodeCodePointFromUTF8ThreeBytesErrorPtr

- (void)testUnicodeCodePointFromUTF8ThreeBytesErrorPtrEuro {
    NSError *error;
    // use euro sign as shown in wikipedia utf8
    uint8_t* bytes = [BSUnicodeConverter bytesFromString:euroString
                                                encoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:bytes length:3];
    
    // expected is the Unicode code point converted to NSData*
    uint8_t expectedBytes[] = {0x20, 0xAC};
    NSData *expected = [NSData dataWithBytes:expectedBytes length:2];
    XCTAssertEqualObjects(expected,
                          [BSUnicodeConverter unicodeCodePointFromUTF8ThreeBytes:data
                                                                        errorPtr:&error]);
    XCTAssertNil(error);
}

#pragma mark - testunicodeCodePointFromUTF8FourBytesErrorPtr

- (void)testUnicodeCodePointFromUTF8FourBytesErrorPtrHwair {
    NSError *error;
    // use hwair as shown in wikipedia utf8
    uint8_t* bytes = [BSUnicodeConverter bytesFromString:hwairString
                                                encoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:bytes length:4];
    
    // expected is the Unicode code point converted to NSData*
    uint8_t expectedBytes[] = {0x01, 0x03, 0x48};
    NSData *expected = [NSData dataWithBytes:expectedBytes length:3];
    XCTAssertEqualObjects(expected,
                          [BSUnicodeConverter unicodeCodePointFromUTF8FourBytes:data
                                                                        errorPtr:&error]);
    XCTAssertNil(error);
}

#pragma mark - testUnicodeCodePointFromUTF8DataErrorPtr

- (void)testUnicodeCodePointFromUTF8DataErrorPtrDataNil {
    NSError *error;
    XCTAssertNil([BSUnicodeConverter unicodeCodePointFromUTF8Data:nil
                                                         errorPtr:&error]);
    XCTAssertEqual(BSUTF8DecodeErrorDataEmpty, error.code);
}

- (void)testUnicodeCodePointFromUTF8DataErrorPtrDataEmpty {
    NSError *error;
    NSData *emptyData = [NSData data];
    XCTAssertNil([BSUnicodeConverter unicodeCodePointFromUTF8Data:emptyData
                                                         errorPtr:&error]);
    XCTAssertEqual(BSUTF8DecodeErrorDataEmpty, error.code);
}

- (void)testUnicodeCodePointFromUTF8DataErrorPtrOneByteab {
    NSError *error;
    NSString *string = @"ab";
    uint8_t* bytes = [BSUnicodeConverter bytesFromString:string encoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:bytes length:2];
    NSData *expected = [NSData dataWithBytes:bytes length:1];
    XCTAssertEqualObjects(expected,
                          [BSUnicodeConverter unicodeCodePointFromUTF8Data:data
                                                                  errorPtr:&error]);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointFromUTF8DataErrorPtrTwoBytes {
    NSError *error;
    // use cent sign as shown in wikipedia utf8
    NSString *string = @"¢";
    uint8_t* bytes = [BSUnicodeConverter bytesFromString:string
                                                encoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:bytes length:2];
    
    // expected is the Unicode code point converted to NSData*
    uint8_t expectedBytes[] = {0x00, 0xA2};
    NSData *expected = [NSData dataWithBytes:expectedBytes length:2];
    XCTAssertEqualObjects(expected,
                          [BSUnicodeConverter unicodeCodePointFromUTF8Data:data
                                                                  errorPtr:&error]);
    XCTAssertNil(error);
}

#pragma mark -

- (void)testDataFromStringEncodingUTF8CharactersOneByte {
    NSDictionary* testDict = @{@"": @0,
                               @"a": @1,
                               @"testing": @7
                               };
    
    for (NSString* string in testDict) {
        NSData *data = [BSUnicodeConverter dataFromString:string
                                                 encoding:NSUTF8StringEncoding];
        int expected = [testDict[string] intValue];
        XCTAssertEqual(expected, [data length], @"%@", string);
    }
}

- (void)testDataFromStringEncodingUTF8CharactersTwoByte {
    NSDictionary* testDict = @{@"ñ": @2,
                               };

    for (NSString* string in testDict) {
        NSData *data = [BSUnicodeConverter dataFromString:string
                                                 encoding:NSUTF8StringEncoding];
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
