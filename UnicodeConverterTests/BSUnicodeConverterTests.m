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

- (void)testBytesFromString {
    NSString *string = @"a";
    uint8_t* buffer = [BSUnicodeConverter bytesFromString:string encoding:NSUTF8StringEncoding];
    char *charBuffer = (char*)buffer;
    XCTAssertEqual(97, charBuffer[0]);
    XCTAssertEqual(0x61, charBuffer[0]);
}

- (void)testBytesFromStringTwo {
    NSString *string = @"a";
    BSUnicodeConverter *converter = [[BSUnicodeConverter alloc] init];
    uint8_t* buffer = [converter bytesFromStringTwo:string encoding:NSUTF8StringEncoding];
    char *charBuffer = (char*)buffer;
    XCTAssertEqual(97, charBuffer[0]);
    XCTAssertEqual(0x61, charBuffer[0]);
}

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

- (void)testStringFromDataFromString {
    NSArray* testStrings = @[@"testing", @"español"];
    
    for (NSString* string in testStrings) {
        NSData *data = [BSUnicodeConverter dataFromString:string encoding:NSUTF8StringEncoding];
        NSString *actual = [BSUnicodeConverter stringFromData:data encoding:NSUTF8StringEncoding];
        XCTAssertEqualObjects(string, actual);
    }
}

- (void)testCodePointFromUTF8DataA {
    // returns the first code point
    NSString* testString = @"A";
    NSData *data = [BSUnicodeConverter dataFromString:testString
                                             encoding:NSUTF8StringEncoding];
    uint32_t expected = 0x41;
    NSError *error = nil;
    uint32_t actual = [BSUnicodeConverter codePointFromUTF8Data:data
                                                       errorPtr:&error];

    XCTAssertNil(error);
    XCTAssertEqual(expected, actual);
    XCTAssertEqual(expected, actual, @"testString %@ expected 0x%x actual 0x%x",
                   testString, expected, actual);
}

- (void)testCodePointFromUTF8DataEuro {
    // returns the first code point
    NSString* testString = @"€";
    NSData *data = [BSUnicodeConverter dataFromString:testString
                                             encoding:NSUTF8StringEncoding];
    uint32_t expected = 0xe282ac;
    NSError *error = nil;
    uint32_t actual = [BSUnicodeConverter codePointFromUTF8Data:data
                                                       errorPtr:&error];

    XCTAssertNil(error);
    XCTAssertEqual(expected, actual);
}

@end
