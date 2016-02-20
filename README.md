# Purpose
Convert from UTF-8 to UTF-32 without using standard Unicode conversion faculties.

# Results

## Problem statement
The task: implement a function that converts UTF-8 encoded string to UTF-32.
You cannot use any standard Unicode conversion faculties in your implementation.
The function will be a part of widely used utility library used in many contexts.
It is up to you to define the input and output data types and error handling semantics.
The code should be production quality and include tests.

## Assumptions
For purposes of demonstrating coding ability I can write an implementation with tests.
However it seems likely any new implementation (such as mine) initially will have more bugs than a library that has been used before.
It may be better to use an existing open source library, find and fix any specifically identified bugs.
Then submit a pull request to the owner of the library.
Alternativley could wrap the standard conversion methods in another class that catches and fixes any specifically identified bugs.

OK to use "standard unicode conversion faculties" to generate source UTF-8 string.
For example ok to use NSString dataUsingEncoding:
OK to use "standard unicode conversion faculties" to test other code.
Tests can get expected values by manually looking up some values.

Assume code will run in an "8 bit clean" environment that allows setting high bit.
https://en.wikipedia.org/wiki/Comparison_of_Unicode_encodings

## Questions
Does "standard" mean in the standard library?
Ok to use 3rd party library like glib or ICU?
http://www.opensource.apple.com/source/JavaScriptCore/JavaScriptCore-721.26/wtf/unicode/UTF8.cpp
https://developer.gnome.org/glib/2.30/glib-Unicode-Manipulation.html
http://icu-project.org/apiref/icu4c/index.html

## Plan
Start by using standard conversion methods to gain familiarity with API.
Then add custom methods.
Use type uint8_t in preference to char or OSX Cocoa platform specific UInt8.

### UTF-8

#### Generate a UTF-8 encoded string
Use "standard unicode conversion faculties" to generate source UTF-8 string.
Write a method to convert NSString to NSData or array of UTF-8 encoded bytes.

##### Byte order mark
// https://en.wikipedia.org/wiki/UTF-8
Some Windows programs such as Notepad add a byte order mark at the beginning.
Check for byte order mark at beginning of string and handle it.

#### Decode UTF-8 encoded string to Unicode code points
Implement a custom decoder.
Test convert strings.

### UTF-32
Implement an encoder that converts Unicode code points to UTF-32.
In simplest encoding, start with all zeros, hex 00 00 00 00 and add unicode code point.

---

# Appendix Background

## UTF-8
Uses 1 to 4 bytes per code point.
UTF-8 encoded strings can contain characters encoded to 1, 2, 3 and 4 byte lengths.
Early decoders threw errors when given bad input, and malware exploited this
to create denial of service attacks.
If decoding fails, consider returning replacement character "�" (U+FFFD)
https://en.wikipedia.org/wiki/UTF-8

## UTF-32
Uses fixed length 4 bytes per code point.
UTF-32 may be big-endian UTF-32BE or little endian UTF-32LE.
In simplest encoding, start with all zeros, hex 00 00 00 00 and add unicode code point. 

---

# References
MobileSDE-CodingProblem-Smartsheet.pdf by Smartsheet
http://www.objc.io/issue-9/unicode.html

## UTF-8
https://en.wikipedia.org/wiki/UTF-8
Table 3-7 Well-Formed UTF-8 Byte Sequences
http://www.unicode.org/versions/Unicode7.0.0/ch03.pdf#G7404
http://ratfactor.com/utf-8-to-unicode

## UTF-16
https://en.wikipedia.org/wiki/UTF-16

## UTF-32
https://en.wikipedia.org/wiki/UTF-32
