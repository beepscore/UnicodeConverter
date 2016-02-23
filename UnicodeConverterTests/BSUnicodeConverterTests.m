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

- (void)testunicodeCodePointFromUTF8TwoBytesErrorPtrCent {
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
                                                                      errorPtr:&error]);
    XCTAssertNil(error);
}

#pragma mark - testunicodeCodePointFromUTF8ThreeBytesErrorPtr

- (void)testUnicodeCodePointFromUTF8ThreeBytesErrorPtrEuro {
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
                                                                        errorPtr:&error]);
    XCTAssertNil(error);
}

#pragma mark - testunicodeCodePointFromUTF8FourBytesErrorPtr

- (void)testUnicodeCodePointFromUTF8FourBytesErrorPtrHwair {
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
                                                                       errorPtr:&error]);
    XCTAssertNil(error);
}

#pragma mark - testUnicodeCodePointFromUTF8DataErrorPtr

- (void)testUnicodeCodePointFromUTF8DataErrorPtrDataNil {
    NSError *error;
    XCTAssertEqualObjects([BSUnicodeConverter kReplacementCharacterData],
                          [BSUnicodeConverter unicodeCodePointFromUTF8Data:nil
                                                         errorPtr:&error]);
    XCTAssertEqual(BSUTF8DecodeErrorDataEmpty, error.code);
}

- (void)testUnicodeCodePointFromUTF8DataErrorPtrDataEmpty {
    NSError *error;
    NSData *emptyData = [NSData data];
    XCTAssertEqualObjects([BSUnicodeConverter kReplacementCharacterData],
                          [BSUnicodeConverter unicodeCodePointFromUTF8Data:emptyData
                                                                  errorPtr:&error]);
    XCTAssertEqual(BSUTF8DecodeErrorDataEmpty, error.code);
}

- (void)testUnicodeCodePointFromUTF8DataErrorPtrOneByteab {
    NSError *error;
    NSString *string = @"ab";
    uint8_t* bytes = [BSUnicodeHelper bytesFromString:string
                                                 encoding:NSUTF8StringEncoding];
    NSData *UTF8Data = [NSData dataWithBytes:bytes length:2];
    NSData *expected = [NSData dataWithBytes:bytes length:1];
    XCTAssertEqualObjects(expected,
                          [BSUnicodeConverter unicodeCodePointFromUTF8Data:UTF8Data
                                                                  errorPtr:&error]);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointFromUTF8DataErrorPtrTwoBytes {
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
                                                                  errorPtr:&error]);
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
    uint32_t expected = 0x000061;
    uint8_t byte0 = 0x00;
    uint8_t byte1 = 0x00;
    uint8_t byte2 = 0x00;
    uint8_t byte3 = 0x61;
    uint8_t bytes[] = {byte0, byte1, byte2, byte3};
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

    uint8_t byte0 = 0x00;
    uint8_t byte1 = 0x01;
    uint8_t byte2 = 0x03;
    uint8_t byte3 = 0x48;
    uint8_t bytes[] = {byte0, byte1, byte2, byte3};
    NSData *unicodeData = [NSData dataWithBytes:bytes length:4];
    uint32_t actual = [BSUnicodeConverter UTF32EncodedCodePointFromUnicodeData:unicodeData
                                                                      errorPtr:&error];
    XCTAssertEqual(expected, actual);
    XCTAssertNil(error);
}

@end
