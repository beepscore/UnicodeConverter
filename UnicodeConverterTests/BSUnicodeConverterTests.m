//
//  BSUnicodeConverterTests.m
//  UnicodeConverterTests
//
//  Created by Steve Baker on 2/17/16.
//  Copyright (c) 2016 Beepscore LLC. All rights reserved.
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

/**
 * This method can be used to test BSUnicodeConverter method UTF32BigEndianFromUTF8Data
 * For testing purposes it uses Cocoa framework methods to 
 * convert a string to UTF-8 data and to convert UTF-32 data back to string.
 * @param string is string to be converted
 * @return transformed string that should be equivalent to the original string
 */
+ (NSString *)stringFromUTF32BigEndianFromUTF8DataFromString:(NSString *)string {

    if ((nil == string)
        || ([string isEqualToString:@""])) {
        return string;
    }
    
    // For testing purposes, use framework method to get UTF8Data.
    // Convert NSString to UTF-8 data
    NSData *UTF8Data = [string dataUsingEncoding:NSUTF8StringEncoding];

    NSData *UTF32Data = [BSUnicodeConverter UTF32BigEndianFromUTF8Data:UTF8Data];

    // For testing purposes, use framework method to get NSString.
    NSString *transformedString = [[NSString alloc] initWithData:UTF32Data
                                                        encoding:NSUTF32BigEndianStringEncoding];
    return transformedString;
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

#pragma mark - testunicodeCodePointFromUTF8TwoBytesAtIndexErrorPtr

- (void)testunicodeCodePointFromUTF8TwoBytesAtIndexErrorPtrCent {
    NSError *error;
    // U+00A2 cent ¢ UTF-8 0xc2a2
    NSString *string = centString;
    uint8_t* bytes = [BSUnicodeHelper bytesFromString:string
                                             encoding:NSUTF8StringEncoding];
    // <c2a2>
    NSData *UTF8Data = [NSData dataWithBytes:bytes length:2];

    // <00a2>
    uint32_t actual = [BSUnicodeConverter unicodeCodePointFromUTF8TwoBytes:UTF8Data
                                                                   atIndex:0
                                                                  errorPtr:&error];
    uint32_t expected = 0x00a2;

    XCTAssertEqual(expected, actual);
    XCTAssertNil(error);
}

#pragma mark - testunicodeCodePointFromUTF8ThreeBytesAtIndexErrorPtr

- (void)testUnicodeCodePointFromUTF8ThreeBytesAtIndexErrorPtrEuro {
    NSError *error;
    // U+20AC Euro € UTF-8 0xe282ac
    uint8_t* bytes = [BSUnicodeHelper bytesFromString:euroString
                                             encoding:NSUTF8StringEncoding];
    // <e282ac>
    NSData *UTF8Data = [NSData dataWithBytes:bytes length:3];

    // <20ac>
    uint32_t actual = [BSUnicodeConverter unicodeCodePointFromUTF8ThreeBytes:UTF8Data
                                                                     atIndex:0
                                                                    errorPtr:&error];
    uint32_t expected = 0x20ac;

    XCTAssertEqual(expected, actual);
    XCTAssertNil(error);
}

#pragma mark - testunicodeCodePointFromUTF8FourBytesAtIndexErrorPtr

- (void)testUnicodeCodePointFromUTF8FourBytesAtIndexErrorPtrHwair {
    NSError *error;
    // U+10348 hwair 𐍈 UTF-8 0xf0908d88
    uint8_t* bytes = [BSUnicodeHelper bytesFromString:hwairString
                                             encoding:NSUTF8StringEncoding];
    // <f0908d88>
    NSData *UTF8Data = [NSData dataWithBytes:bytes length:4];

    // <010348>
    uint32_t actual = [BSUnicodeConverter unicodeCodePointFromUTF8FourBytes:UTF8Data
                                                                   atIndex:0
                                                                  errorPtr:&error];
    uint32_t expected = 0x010348;

    XCTAssertEqual(expected, actual);
    XCTAssertNil(error);
}

#pragma mark - testUnicodeCodePointFromUTF8DataAtIndexErrorPtr

- (void)testUnicodeCodePointFromUTF8DataAtIndexErrorPtrDataNil {
    NSNumber *numberOfBytesRead;
    NSError *error;
    uint32_t actual = [BSUnicodeConverter unicodeCodePointFromUTF8Data:nil
                                                               atIndex:0
                                                  numberOfBytesReadPtr:&numberOfBytesRead
                                                              errorPtr:&error];
    uint32_t expected = kReplacementCharacter;
    XCTAssertEqual(expected, actual);
    XCTAssertEqual(BSUTF8DecodeErrorDataEmpty, error.code);
}

- (void)testUnicodeCodePointFromUTF8DataAtIndexErrorPtrDataEmpty {
    NSNumber *numberOfBytesRead;
    NSError *error;
    NSData *emptyData = [NSData data];

    uint32_t actual = [BSUnicodeConverter unicodeCodePointFromUTF8Data:emptyData
                                                               atIndex:0
                                                  numberOfBytesReadPtr:&numberOfBytesRead
                                                              errorPtr:&error];
    uint32_t expected = kReplacementCharacter;

    XCTAssertEqual(expected, actual);
    XCTAssertEqual(BSUTF8DecodeErrorDataEmpty, error.code);
}

- (void)testUnicodeCodePointFromUTF8DataAtIndexErrorPtrab {
    NSNumber *numberOfBytesRead;
    NSError *error;
    NSString *string = @"ab";
    uint8_t* bytes = [BSUnicodeHelper bytesFromString:string
                                             encoding:NSUTF8StringEncoding];
    NSData *UTF8Data = [NSData dataWithBytes:bytes length:2];

    uint32_t actual = [BSUnicodeConverter unicodeCodePointFromUTF8Data:UTF8Data
                                                               atIndex:0
                                                  numberOfBytesReadPtr:&numberOfBytesRead
                                                              errorPtr:&error];
    uint32_t expected = 0x61;

    XCTAssertEqual(expected, actual);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointFromUTF8DataAtIndexErrorPtrCent {
    NSNumber *numberOfBytesRead;
    NSError *error;
    // U+00A2 cent ¢ UTF-8 0xc2a2
    NSString *string = centString;
    uint8_t* bytes = [BSUnicodeHelper bytesFromString:string
                                             encoding:NSUTF8StringEncoding];
    NSData *UTF8Data = [NSData dataWithBytes:bytes length:2];
    uint32_t actual = [BSUnicodeConverter unicodeCodePointFromUTF8Data:UTF8Data
                                                               atIndex:0
                                                  numberOfBytesReadPtr:&numberOfBytesRead
                                                              errorPtr:&error];
    uint32_t expected = 0x00A2;
    XCTAssertEqual(expected, actual);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointFromUTF8DataAtIndexErrorPtrEuro {
    NSNumber *numberOfBytesRead;
    NSError *error;
    // U+20AC Euro € UTF-8 0xe282ac
    NSString *string = euroString;
    uint8_t* bytes = [BSUnicodeHelper bytesFromString:string
                                             encoding:NSUTF8StringEncoding];
    // <e282ac>
    NSData *UTF8Data = [NSData dataWithBytes:bytes length:3];

    // <20ac>
    uint32_t actual = [BSUnicodeConverter unicodeCodePointFromUTF8Data:UTF8Data
                                                               atIndex:0
                                                  numberOfBytesReadPtr:&numberOfBytesRead
                                                              errorPtr:&error];
    uint32_t expected = 0x20AC;

    XCTAssertEqual(expected, actual);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointFromUTF8DataAtIndexErrorPtrHwair {
    NSNumber *numberOfBytesRead;
    NSError *error;
    // U+10348 hwair 𐍈 UTF-8 0xf0908d88
    NSString *string = hwairString;
    uint8_t* bytes = [BSUnicodeHelper bytesFromString:string
                                             encoding:NSUTF8StringEncoding];
    // <f0908d88>
    NSData *UTF8Data = [NSData dataWithBytes:bytes length:4];

    // <010348>
    uint32_t actual = [BSUnicodeConverter unicodeCodePointFromUTF8Data:UTF8Data
                                                               atIndex:0
                                                  numberOfBytesReadPtr:&numberOfBytesRead
                                                              errorPtr:&error];
    uint32_t expected = 0x010348;

    XCTAssertEqual(expected, actual);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointFromUTF8DataAtIndex {
    NSNumber *numberOfBytesRead;
    NSError *error;
    NSString *string = @"aβ¢𐍈€f";

    // <61ceb2c2 a2f0908d 88e282ac 66>
    NSData *UTF8Data = [string dataUsingEncoding:NSUTF8StringEncoding];

    // first character after byte order marker
    uint32_t actual = [BSUnicodeConverter unicodeCodePointFromUTF8Data:UTF8Data
                                                               atIndex:0
                                                  numberOfBytesReadPtr:&numberOfBytesRead
                                                              errorPtr:&error];
    uint32_t expected = 0x61;

    XCTAssertEqual(expected, actual);
    XCTAssertNil(error);
}

#pragma mark - testUnicodeCodePointsFromUTF8Data

- (void)testUnicodeCodePointsFromUTF8DataNil {
    NSArray *actual = [BSUnicodeConverter unicodeCodePointsFromUTF8Data:nil];
    XCTAssertEqualObjects([NSArray array], actual);
}

- (void)testUnicodeCodePointsFromUTF8DataEmpty {
    NSArray *actual = [BSUnicodeConverter unicodeCodePointsFromUTF8Data:[NSData data]];
    XCTAssertEqualObjects([NSArray array], actual);
}

- (void)testUnicodeCodePointsFromUTF8Dataabc {
    NSError *error;
    NSString *string = @"abc";
    // For purposes of testing, use framework method to get UTF8Data.
    // <616263>
    NSData *UTF8Data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *actual = [BSUnicodeConverter unicodeCodePointsFromUTF8Data:UTF8Data];

    NSArray *expected = @[@0x61, @0x62, @0x63];

    XCTAssertEqualObjects(expected, actual);
    XCTAssertNil(error);
}
- (void)testUnicodeCodePointsFromUTF8DataBeta {
    NSError *error;
    // U+03b2 Greek letter beta β UTF-8 0xceb2
    NSString *string = @"β";
    // For purposes of testing, use framework method to get UTF8Data.
    // po UTF8Data <ceb2>
    NSData *UTF8Data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *actual = [BSUnicodeConverter unicodeCodePointsFromUTF8Data:UTF8Data];

    NSArray *expected = @[@0x03b2];

    XCTAssertEqualObjects(expected, actual);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointsFromUTF8DataCent {
    NSError *error;
    // U+00A2 cent ¢ UTF-8 0xc2a2
    NSString *string = centString;
    // For purposes of testing, use framework method to get UTF8Data.
    // po UTF8Data <c2a2>
    NSData *UTF8Data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *actual = [BSUnicodeConverter unicodeCodePointsFromUTF8Data:UTF8Data];

    NSArray *expected = @[@0x00a2];

    XCTAssertEqualObjects(expected, actual);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointsFromUTF8DataaBeta {
    NSError *error;
    NSString *string = @"aβ";

    // For purposes of testing, use framework method to get UTF8Data.
    // po UTF8Data <61ceb2>
    NSData *UTF8Data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *actual = [BSUnicodeConverter unicodeCodePointsFromUTF8Data:UTF8Data];

    NSArray *expected = @[@0x61, @0x03b2];

    XCTAssertEqualObjects(expected, actual);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointsFromUTF8DataEuro {
    NSError *error;
    // U+20AC Euro € UTF-8 0xe282ac
    NSString *string = euroString;
    // For purposes of testing, use framework method to get UTF8Data.
    // <e282ac>
    NSData *UTF8Data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *actual = [BSUnicodeConverter unicodeCodePointsFromUTF8Data:UTF8Data];

    NSArray *expected = @[@0x20ac];

    XCTAssertEqualObjects(expected, actual);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointsFromUTF8DataHwair {
    NSError *error;
    // U+10348 hwair 𐍈 UTF-8 0xf0908d88
    NSString *string = hwairString;
    // For purposes of testing, use framework method to get UTF8Data.
    // po UTF8Data <f0908d88> (4 bytes)
    NSData *UTF8Data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *actual = [BSUnicodeConverter unicodeCodePointsFromUTF8Data:UTF8Data];

    NSArray *expected = @[@0x010348];

    XCTAssertEqualObjects(expected, actual);
    XCTAssertNil(error);
}

- (void)testUnicodeCodePointsFromUTF8Data {
    NSError *error;
    NSString *string = @"aβ¢𐍈€f";
    // For purposes of testing, use framework method to get UTF8Data.
    // po UTF8Data <61ceb2c2 a2f0908d 88e282ac 66>
    NSData *UTF8Data = [string dataUsingEncoding:NSUTF8StringEncoding];

    // po actual (97, 946, 162, 66376, 8364, 102)
    NSArray *actual = [BSUnicodeConverter unicodeCodePointsFromUTF8Data:UTF8Data];

    // According to some references, NSString dataUsingEncoding:NSUnicodeStringEncoding
    // returns something more like UTF-16 than Unicode
    // So don't use this
    // po expectedUnicodeData
    // <fffe6100 b203a200 00d848df ac206600>
    // NSData *expectedUnicodeData = [string dataUsingEncoding:NSUnicodeStringEncoding];

    // I independently checked expected via online converter http://ratfactor.com/utf-8-to-unicode
    NSArray *expected = @[@0x61, @0x03b2, @0x00a2, @0x010348, @0x20ac, @0x66];

    XCTAssertEqualObjects(expected, actual);
    XCTAssertNil(error);
}

#pragma mark - testUTF32BigEndianFromUnicodeCodePoint

- (void)testUTF32BigEndianFromUnicodeCodePoint0 {
    uint32_t unicodeCodePoint = 0x0;

    NSData *actual = [BSUnicodeConverter UTF32BigEndianFromUnicodeCodePoint:unicodeCodePoint];
    
    uint8_t byte0 = 0x00;
    uint8_t byte1 = 0x00;
    uint8_t byte2 = 0x00;
    uint8_t byte3 = 0x00;
    uint8_t bytes[] = {byte0, byte1, byte2, byte3};
    NSData *expected = [NSData dataWithBytes:bytes length:4];
    
    XCTAssertEqualObjects(expected, actual);
}

- (void)testUTF32BigEndianFromUnicodeCodePointa {
    uint32_t unicodeCodePoint = 0x61;

    NSData *actual = [BSUnicodeConverter UTF32BigEndianFromUnicodeCodePoint:unicodeCodePoint];
    
    uint8_t byte0 = 0x00;
    uint8_t byte1 = 0x00;
    uint8_t byte2 = 0x00;
    uint8_t byte3 = 0x61;
    uint8_t bytes[] = {byte0, byte1, byte2, byte3};
    NSData *expected = [NSData dataWithBytes:bytes length:4];
    
    XCTAssertEqualObjects(expected, actual);
}

- (void)testUTF32BigEndianFromUnicodeCodePointCent {
    // U+00A2 cent ¢ UTF-8 0xc2a2
    uint32_t unicodeCodePoint = 0x00a2;

    NSData *actual = [BSUnicodeConverter UTF32BigEndianFromUnicodeCodePoint:unicodeCodePoint];
    
    uint8_t byte0 = 0x00;
    uint8_t byte1 = 0x00;
    uint8_t byte2 = 0x00;
    uint8_t byte3 = 0xa2;
    uint8_t bytes[] = {byte0, byte1, byte2, byte3};
    NSData *expected = [NSData dataWithBytes:bytes length:4];
    
    XCTAssertEqualObjects(expected, actual);
}

- (void)testUTF32BigEndianFromUnicodeCodePointEuro {
    // U+20AC Euro € UTF-8 0xe282ac
    uint32_t unicodeCodePoint = 0x20ac;

    NSData *actual = [BSUnicodeConverter UTF32BigEndianFromUnicodeCodePoint:unicodeCodePoint];
    
    uint8_t byte0 = 0x00;
    uint8_t byte1 = 0x00;
    uint8_t byte2 = 0x20;
    uint8_t byte3 = 0xac;
    uint8_t bytes[] = {byte0, byte1, byte2, byte3};
    NSData *expected = [NSData dataWithBytes:bytes length:4];
    
    XCTAssertEqualObjects(expected, actual);
}

- (void)testUTF32BigEndianFromUnicodeCodePointHwair {
    // U+10348 hwair 𐍈 UTF-8 0xf0908d88
    uint32_t unicodeCodePoint = 0x10348;

    NSData *actual = [BSUnicodeConverter UTF32BigEndianFromUnicodeCodePoint:unicodeCodePoint];
    
    uint8_t byte0 = 0x00;
    uint8_t byte1 = 0x01;
    uint8_t byte2 = 0x03;
    uint8_t byte3 = 0x48;
    uint8_t bytes[] = {byte0, byte1, byte2, byte3};
    NSData *expected = [NSData dataWithBytes:bytes length:4];
    
    XCTAssertEqualObjects(expected, actual);
}

#pragma mark - testUTF32BigEndianFromUnicodeCodePoints

- (void)testUTF32BigEndianFromUnicodeCodePoints0 {
    uint32_t unicodeCodePoint = 0x0;
    NSArray *unicodeCodePoints = @[[NSNumber numberWithUnsignedInt:unicodeCodePoint]];

    NSData *actual = [BSUnicodeConverter UTF32BigEndianFromUnicodeCodePoints:unicodeCodePoints];
    
    uint8_t bytes[] = {0x00, 0x00, 0x00, 0x00};
    NSData *expected = [NSData dataWithBytes:bytes length:4];
    
    XCTAssertEqualObjects(expected, actual);
}

- (void)testUTF32BigEndianFromUnicodeCodePointsEmpty {
    NSArray *emptyArray = [NSArray array];

    NSData *actual = [BSUnicodeConverter UTF32BigEndianFromUnicodeCodePoints:emptyArray];

    // empty data
    NSData *expected = [NSData data];
    
    XCTAssertEqualObjects(expected, actual);
}

- (void)testUTF32BigEndianFromUnicodeCodePointsHwair {
    // U+10348 hwair 𐍈 UTF-8 0xf0908d88
    uint32_t unicodeCodePoint = 0x10348;
    NSArray *unicodeCodePoints = @[[NSNumber numberWithUnsignedInt:unicodeCodePoint]];

    NSData *actual = [BSUnicodeConverter UTF32BigEndianFromUnicodeCodePoints:unicodeCodePoints];
    
    uint8_t bytes[] = {0x00, 0x01, 0x03, 0x48};
    NSData *expected = [NSData dataWithBytes:bytes length:4];
    
    XCTAssertEqualObjects(expected, actual);
}

- (void)testUTF32BigEndianFromUnicodeCodePointsaHwair {
    uint32_t unicodea = 0x61;
    // U+10348 hwair 𐍈 UTF-8 0xf0908d88
    uint32_t unicodeHwair = 0x10348;
    NSArray *unicodeCodePoints = @[[NSNumber numberWithUnsignedInt:unicodea],
                                   [NSNumber numberWithUnsignedInt:unicodeHwair]];

    NSData *actual = [BSUnicodeConverter UTF32BigEndianFromUnicodeCodePoints:unicodeCodePoints];
    
    uint8_t bytes[] = {0x00, 0x00, 0x00, 0x61,
        0x00, 0x01, 0x03, 0x48};
    NSData *expected = [NSData dataWithBytes:bytes length:8];
    
    XCTAssertEqualObjects(expected, actual);
}

- (void)testStringFromUTF32BigEndianFromUTF8DataFromString {

    NSArray *array = @[@"",
                       @"�",      // replacement character literal representation
                       @"\ufffd", // replacement character
                       @"\ufffe", // byte order marker BOM
                       @"a",
                       centString,
                       euroString,
                       hwairString,
                       @"aβ¢𐍈€f",
                       @"español",
                       @"It's working 53 times already!",
                       @"中华人民共和国", // People's Republic of China
                       @"string with \ntwo lines"
                       ];

    for (NSString *string in array) {
        
        NSString *tranformedString = [BSUnicodeConverterTests
                                      stringFromUTF32BigEndianFromUTF8DataFromString:string];
        XCTAssertTrue([string isEqualToString:tranformedString]);
    }
}

@end
