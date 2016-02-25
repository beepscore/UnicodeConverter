//
//  BSUnicodeConverterTests.m
//  UnicodeConverterTests
//
//  Created by Steve Baker on 2/19/15.
//  Copyright (c) 2015 Beepscore LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BSUnicodeConstants.h"
#import "BSUnicodeHelper.h"
#import "BSUnicodeConverter.h"
#import "BSUnicodeConverterPrivate.h"

@interface BSUnicodeConverterTests : XCTestCase

@end

@implementation BSUnicodeConverterTests

#pragma mark -

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
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
    XCTAssertTrue([BSUnicodeConverter isValidUTF8EncodedAsTwoBytesFirstByte:0b11000010]);
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
}

- (void)testIsValidUTF8EncodedAsFourBytesFirstByteFalse {
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsFourBytesFirstByte:0b00000000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsFourBytesFirstByte:0b10000000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsFourBytesFirstByte:0b11000000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsFourBytesFirstByte:0b11100000]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedAsFourBytesFirstByte:0b11111000]);
}

- (void)testIsValidUTF8EncodedOctetFalse {
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedOctet:0xC0]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedOctet:0xC1]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedOctet:0xF5]);
    XCTAssertFalse([BSUnicodeConverter isValidUTF8EncodedOctet:0xFF]);
}

- (void)testIsValidUTF8EncodedOctetTrue {
    XCTAssertTrue([BSUnicodeConverter isValidUTF8EncodedOctet:0x00]);
    XCTAssertTrue([BSUnicodeConverter isValidUTF8EncodedOctet:0xBF]);
    XCTAssertTrue([BSUnicodeConverter isValidUTF8EncodedOctet:0xC2]);
    XCTAssertTrue([BSUnicodeConverter isValidUTF8EncodedOctet:0xF4]);
}

#pragma mark - testunicodeCodePointFromUTF8TwoBytesErrorPtr

- (void)testunicodeCodePointFromUTF8TwoBytesAtIndexErrorPtrCent {
    NSError *error;
    // use cent sign as shown in wikipedia utf8
    NSString *string = centString;
    uint8_t* bytes = [BSUnicodeHelper bytesFromString:string
                                                 encoding:NSUTF8StringEncoding];
    NSData *UTF8Data = [NSData dataWithBytes:bytes length:2];
    
    // expected is the Unicode code point converted to NSData*
    uint8_t expectedBytes[] = {0x00, 0xA2};
    NSData *expected = [NSData dataWithBytes:expectedBytes length:2];
    XCTAssertEqualObjects(expected,
                          [BSUnicodeConverter unicodeCodePointFromUTF8TwoBytes:UTF8Data
                                                                       atIndex:0
                                                                      errorPtr:&error]);
    XCTAssertNil(error);
}

#pragma mark - testunicodeCodePointFromUTF8ThreeBytesErrorPtr

- (void)testUnicodeCodePointFromUTF8ThreeBytesAtIndexErrorPtrEuro {
    NSError *error;
    // use euro sign as shown in wikipedia utf8
    uint8_t* bytes = [BSUnicodeHelper bytesFromString:euroString
                                                 encoding:NSUTF8StringEncoding];
    NSData *UTF8Data = [NSData dataWithBytes:bytes length:3];
    
    // expected is the Unicode code point converted to NSData*
    uint8_t expectedBytes[] = {0x20, 0xAC};
    NSData *expected = [NSData dataWithBytes:expectedBytes length:2];
    XCTAssertEqualObjects(expected,
                          [BSUnicodeConverter unicodeCodePointFromUTF8ThreeBytes:UTF8Data
                                                                         atIndex:0
                                                                        errorPtr:&error]);
    XCTAssertNil(error);
}

#pragma mark - testunicodeCodePointFromUTF8FourBytesErrorPtr

- (void)testUnicodeCodePointFromUTF8FourBytesAtIndexErrorPtrHwair {
    NSError *error;
    // use hwair as shown in wikipedia utf8
    uint8_t* bytes = [BSUnicodeHelper bytesFromString:hwairString
                                             encoding:NSUTF8StringEncoding];
    NSData *UTF8Data = [NSData dataWithBytes:bytes length:4];
    
    // expected is the Unicode code point converted to NSData*
    uint8_t expectedBytes[] = {0x01, 0x03, 0x48};
    NSData *expected = [NSData dataWithBytes:expectedBytes length:3];
    XCTAssertEqualObjects(expected,
                          [BSUnicodeConverter unicodeCodePointFromUTF8FourBytes:UTF8Data
                                                                        atIndex:0
                                                                       errorPtr:&error]);
    XCTAssertNil(error);
}

#pragma mark - testUnicodeCodePointFromUTF8DataErrorPtr

- (void)testUnicodeCodePointFromUTF8DataAtIndexErrorPtrDataNil {
    NSError *error;
    XCTAssertEqualObjects([BSUnicodeConverter kReplacementCharacterData],
                          [BSUnicodeConverter unicodeCodePointFromUTF8Data:nil
                                                                   atIndex:0
                                                                  errorPtr:&error]);
    XCTAssertEqual(BSUTF8DecodeErrorDataEmpty, error.code);
}

- (void)testUnicodeCodePointFromUTF8DataAtIndexErrorPtrDataEmpty {
    NSError *error;
    NSData *emptyData = [NSData data];
    XCTAssertEqualObjects([BSUnicodeConverter kReplacementCharacterData],
                          [BSUnicodeConverter unicodeCodePointFromUTF8Data:emptyData
                                                                   atIndex:0
                                                                  errorPtr:&error]);
    XCTAssertEqual(BSUTF8DecodeErrorDataEmpty, error.code);
}

- (void)testUnicodeCodePointFromUTF8DataAtIndexErrorPtrOneByteab {
    NSError *error;
    NSString *string = @"ab";
    uint8_t* bytes = [BSUnicodeHelper bytesFromString:string
                                             encoding:NSUTF8StringEncoding];
    NSData *UTF8Data = [NSData dataWithBytes:bytes length:2];
    NSData *expected = [NSData dataWithBytes:bytes length:1];
    XCTAssertEqualObjects(expected,
                          [BSUnicodeConverter unicodeCodePointFromUTF8Data:UTF8Data
                                                                   atIndex:0
                                                                  errorPtr:&error]);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointFromUTF8DataAtIndexErrorPtrTwoBytes {
    NSError *error;
    // use cent sign as shown in wikipedia utf8
    NSString *string = @"¢";
    uint8_t* bytes = [BSUnicodeHelper bytesFromString:string
                                             encoding:NSUTF8StringEncoding];
    NSData *UTF8Data = [NSData dataWithBytes:bytes length:2];
    
    // expected is the Unicode code point converted to NSData*
    uint8_t expectedBytes[] = {0x00, 0xA2};
    NSData *expected = [NSData dataWithBytes:expectedBytes length:2];
    XCTAssertEqualObjects(expected,
                          [BSUnicodeConverter unicodeCodePointFromUTF8Data:UTF8Data
                                                                   atIndex:0
                                                                  errorPtr:&error]);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointFromUTF8DataAtIndexErrorPtrThreeBytes {
    NSError *error;
    // U+20AC Euro € UTF-8 0xe282ac
    NSString *string = @"€";
    uint8_t* bytes = [BSUnicodeHelper bytesFromString:string
                                             encoding:NSUTF8StringEncoding];
    // <e282ac>
    NSData *UTF8Data = [NSData dataWithBytes:bytes length:3];

    // <20ac>
    NSData *actual = [BSUnicodeConverter unicodeCodePointFromUTF8Data:UTF8Data
                                                              atIndex:0
                                                             errorPtr:&error];

    // expected is the Unicode code point converted to NSData*
    uint8_t expectedBytes[] = {0x20, 0xAC};
    NSData *expected = [NSData dataWithBytes:expectedBytes length:2];

    XCTAssertEqualObjects(expected, actual);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointFromUTF8DataAtIndex {
    NSError *error;
    NSString *string = @"aβ¢𐍈€f";

    // <61ceb2c2 a2f0908d 88e282ac 66>
    NSData *UTF8Data = [string dataUsingEncoding:NSUTF8StringEncoding];

    // first character after byte order marker
    NSData *dataAtIndex0 = [BSUnicodeConverter unicodeCodePointFromUTF8Data:UTF8Data
                                                                    atIndex:0
                                                                   errorPtr:&error];

    uint8_t expectedUnicodeBytes[] = {0x61};
    NSData *expectedDataAtIndex0 = [NSData dataWithBytes:expectedUnicodeBytes
                                                  length:1];

    XCTAssertEqualObjects(expectedDataAtIndex0, dataAtIndex0);
    XCTAssertNil(error);
}

#pragma mark - testUnicodeCodePointsFromUTF8Data

- (void)testUnicodeCodePointsFromUTF8DataNil {
    NSData *actual = [BSUnicodeConverter unicodeCodePointsFromUTF8Data:nil];
    XCTAssertEqualObjects([NSData data], actual);
}

- (void)testUnicodeCodePointsFromUTF8DataEmpty {
    NSData *actual = [BSUnicodeConverter unicodeCodePointsFromUTF8Data:[NSData data]];
    XCTAssertEqualObjects([NSData data], actual);
}

- (void)testUnicodeCodePointsFromUTF8Dataabc {
    NSError *error;
    NSString *string = @"abc";
    // For purposes of testing, use framework method to get UTF8Data.
    // <616263>
    NSData *UTF8Data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *actual = [BSUnicodeConverter unicodeCodePointsFromUTF8Data:UTF8Data];

    uint8_t expectedUnicodeBytes[] = {0x61, 0x62, 0x63};
    NSData *expected = [NSData dataWithBytes:expectedUnicodeBytes length:3];

    XCTAssertEqualObjects(expected, actual);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointsFromUTF8DataaBeta {
    NSError *error;
    NSString *string = @"aβ";

    // For purposes of testing, use framework method to get UTF8Data.
    // po UTF8Data <61ceb2>
    NSData *UTF8Data = [string dataUsingEncoding:NSUTF8StringEncoding];

    // po actual <6103b2>
    NSData *actual = [BSUnicodeConverter unicodeCodePointsFromUTF8Data:UTF8Data];

    uint8_t expectedUnicodeBytes[] = {0x61, 0x03, 0xb2};
    NSData *expected = [NSData dataWithBytes:expectedUnicodeBytes length:3];

    XCTAssertEqualObjects(expected, actual);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointsFromUTF8Data {
    NSError *error;
    NSString *string = @"aβ¢𐍈€f";
    // For purposes of testing, use framework method to get UTF8Data.
    // po UTF8Data <61ceb2c2 a2f0908d 88e282ac 66>
    NSData *UTF8Data = [string dataUsingEncoding:NSUTF8StringEncoding];

    // TODO: FIXME
    // Actual behavior appears to have a bug, can't decode this UTF-8.
    // It appears to returns 2 instances of replacement character 0xfffd
    // This may be due to combining characters, not sure.
    // po actual <6103b200 a2010348 00fffd20 ac00fffd 66>
    NSData *actual = [BSUnicodeConverter unicodeCodePointsFromUTF8Data:UTF8Data];

    // According to some references, NSString dataUsingEncoding:NSUnicodeStringEncoding
    // returns something more like UTF-16 than Unicode
    // So don't use this
    // po expectedUnicodeData
    // <fffe6100 b203a200 00d848df ac206600>
    // NSData *expectedUnicodeData = [string dataUsingEncoding:NSUnicodeStringEncoding];

    // Change expected to match actual.
    uint8_t expectedUnicodeBytes[] = {0x61,
        0x03, 0xb2,
        0x00, 0xa2,
        0x01, 0x03, 0x48,
        0x00, 0xff, 0xfd,
        0x20, 0xac,
        0x00, 0xff, 0xfd,
        0x66
    };
    NSData *expectedUnicodeData = [NSData dataWithBytes:expectedUnicodeBytes length:17];

    XCTAssertEqualObjects(expectedUnicodeData, actual);
    XCTAssertNil(error);
}

#pragma mark - testUTF32EncodedCodePointFromUnicodeDataErrorPtr

- (void)testUTF32EncodedCodePointFromUnicodeDataErrorPtrNil {
    NSError *error;
    uint32_t actual = [BSUnicodeConverter UTF32EncodedCodePointFromUnicodeData:nil
                                                                      errorPtr:&error];
    XCTAssertEqual(0, actual);
    XCTAssertNotNil(error);
    XCTAssertEqual(@"BSDataError", error.domain);
    XCTAssertEqual(BSDataErrorOutOfBounds, error.code);
}

- (void)testUTF32EncodedCodePointFromUnicodeDataErrorPtrEmpty {
    NSError *error;
    uint32_t actual = [BSUnicodeConverter UTF32EncodedCodePointFromUnicodeData:[NSData data]
                                                                      errorPtr:&error];
    XCTAssertEqual(0, actual);
    XCTAssertNotNil(error);
    XCTAssertEqual(@"BSDataError", error.domain);
    XCTAssertEqual(BSDataErrorOutOfBounds, error.code);
}

- (void)testUTF32EncodedCodePointFromUnicodeDataErrorPtra {
    NSError *error;
    // character "a"
    uint32_t expected = 0x00000061;
    uint8_t byte1 = 0x00;
    uint8_t byte2 = 0x00;
    uint8_t byte3 = 0x61;
    uint8_t bytes[] = {byte1, byte2, byte3};
    NSData *unicodeData = [NSData dataWithBytes:bytes length:4];
    uint32_t actual = [BSUnicodeConverter UTF32EncodedCodePointFromUnicodeData:unicodeData
                                                                      errorPtr:&error];
    XCTAssertEqual(expected, actual);
    XCTAssertNil(error);
}

- (void)testUTF32EncodedCodePointFromUnicodeDataErrorPtrHwair {
    NSError *error;
    // expected values from Wikipedia example
    uint32_t expected = 0x10348;

    uint8_t byte1 = 0x01;
    uint8_t byte2 = 0x03;
    uint8_t byte3 = 0x48;
    uint8_t bytes[] = {byte1, byte2, byte3};
    NSData *unicodeData = [NSData dataWithBytes:bytes length:4];
    uint32_t actual = [BSUnicodeConverter UTF32EncodedCodePointFromUnicodeData:unicodeData
                                                                      errorPtr:&error];
    XCTAssertEqual(expected, actual);
    XCTAssertNil(error);
}

@end
