//
//  UnicodeConverterTests.m
//  UnicodeConverterTests
//
//  Created by Steve Baker on 2/19/15.
//  Copyright (c) 2015 Beepscore LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UnicodeConverter.h"

@interface UnicodeConverterTests : XCTestCase

@end

@implementation UnicodeConverterTests

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
    uint8_t* buffer = [UnicodeConverter bytesFromString:string encoding:NSUTF8StringEncoding];
    char *charBuffer = (char*)buffer;
    XCTAssertEqual(97, charBuffer[0]);
    XCTAssertEqual(0x61, charBuffer[0]);
}

- (void)testBytesFromStringTwo {
    NSString *string = @"a";
    uint8_t* buffer = [UnicodeConverter bytesFromStringTwo:string encoding:NSUTF8StringEncoding];
    char *charBuffer = (char*)buffer;
    XCTAssertEqual(97, charBuffer[0]);
    XCTAssertEqual(0x61, charBuffer[0]);
}

- (void)testDataFromStringBytes {
    // https://en.wikipedia.org/wiki/UTF-8
    // character decimal hex
    // A         65      41
    // a         97      61
    NSArray* testArray = @[@{@"testString":@"A", @"byteIndex":@0, @"byteValue":@65},
                           @{@"testString":@"A", @"byteIndex":@0, @"byteValue":@0x41},
                           @{@"testString":@"a", @"byteIndex":@0, @"byteValue":@97},
                           @{@"testString":@"a", @"byteIndex":@0, @"byteValue":@0x61},
                           @{@"testString":@"ab", @"byteIndex":@0, @"byteValue":@0x61},
                           @{@"testString":@"ab", @"byteIndex":@1, @"byteValue":@0x62},
                           @{@"testString":@"ñ", @"byteIndex":@0, @"byteValue":@0xc3},
                           @{@"testString":@"ñ", @"byteIndex":@1, @"byteValue":@0xb1},
                           @{@"testString":@"ña", @"byteIndex":@2, @"byteValue":@0x61}
                           ];
    
    for (NSDictionary* testDict in testArray) {
        NSString *testString = testDict[@"testString"];
        NSData *data = [UnicodeConverter dataFromString:testString
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
        NSData *data = [UnicodeConverter dataFromString:string encoding:NSUTF8StringEncoding];
        int expected = [testDict[string] intValue];
        XCTAssertEqual(expected, [data length], @"%@", string);
    }
}

- (void)testDataFromStringUTF8CharactersTwoByte {
    NSDictionary* testDict = @{@"ñ": @2,
                               };

    for (NSString* string in testDict) {
        NSData *data = [UnicodeConverter dataFromString:string encoding:NSUTF8StringEncoding];
        int expected = [testDict[string] intValue];
        XCTAssertEqual(expected, [data length], @"%@", string);
    }
}

- (void)testStringFromDataFromString {
    NSArray* testStrings = @[@"testing", @"español"];
    
    for (NSString* string in testStrings) {
        NSData *data = [UnicodeConverter dataFromString:string encoding:NSUTF8StringEncoding];
        NSString *actual = [UnicodeConverter stringFromData:data encoding:NSUTF8StringEncoding];
        XCTAssertEqualObjects(string, actual);
    }
}

@end
