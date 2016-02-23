# Purpose
Convert from UTF-8 to UTF-32 without using standard Unicode conversion faculties.

# Problem statement
The task: implement a function that converts UTF-8 encoded string to UTF-32.
You cannot use any standard Unicode conversion faculties in your implementation.
The function will be a part of widely used utility library used in many contexts.
It is up to you to define the input and output data types and error handling semantics.
The code should be production quality and include tests.

# Results

## Questions
Ok to use a 3rd party library like libiconv or ICU?
Generally popular libraries are used an written by many people and so are high quality and have tests.

### Byte order mark
// https://en.wikipedia.org/wiki/UTF-8
Some Windows programs such as Notepad add a byte order mark at the beginning.
Should code add a byte order mark at beginning of UTF-16 for use by Windows?

### Endianess
Should code have an option to export UTF-16 as either little endian or big endian?

## Assumptions
For purposes of demonstrating coding ability and learning more about Unicode I am writing an implementation with tests.
However it seems likely any new implementation (such as mine) initially will have more bugs than a library that has been widely used.
Also memory space and time performance probably will be worse, but that may be acceptable.

It may be better to use an existing open source library, find and fix any specifically identified bugs.
Then submit a pull request to the owner of the library.
Alternativley could wrap the standard conversion methods in another class that catches and fixes any specifically identified bugs.

### Testing
Tests may use expected values that I looked up or calculated manually.
OK to use "standard unicode conversion faculties" to test other code.
For example ok to use NSString dataUsingEncoding: to generate NSData with UTF-8 encoded bytes.

Assume code will run in an "8 bit clean" environment that allows setting high bit.
https://en.wikipedia.org/wiki/Comparison_of_Unicode_encodings

## Plan
Start by using standard conversion methods to gain familiarity with Unicode details and API.
Then add custom implementation.
Use unambiguous type uint8_t in preference to char or OSX Cocoa platform specific UInt8.

### Convert UTF-8 encoded NSString to NSData
Write a method to convert NSString to NSData
NSData wraps a buffer array that will contain UTF-8 encoded bytes.

### Decode UTF-8 to Unicode
Decode UTF-8 encoded string to Unicode code points.
Implement a custom decoder.
Test convert strings.

### Encode Unicode to UTF-32
Implement an encoder that converts Unicode code points to UTF-32.
In simplest encoding, start with all zeros, hex 00 00 00 00 and add unicode code point.

---

# Appendix Background

## Unicode
Highest code point is 0x10FFFF, which fits in 3 bytes.

## UTF-8
Uses 1 to 4 bytes per code point.
UTF-8 encoded strings can contain characters encoded to 1, 2, 3 and 4 byte lengths.
Early decoders threw errors when given bad input, and malware exploited this
to create denial of service attacks.
If decoding fails, consider returning replacement character "�" (U+FFFD)
https://en.wikipedia.org/wiki/UTF-8

## UTF-32
"The UTF-32 form of a code point is a direct representation of that code point's numerical value."
Uses fixed length 4 bytes per code point.
UTF-32 may be big-endian UTF-32BE or little endian UTF-32LE.
Uses Byte Order Mark BOM at beginning of string?

# Appendix References

## Problem statement
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

## Third party libraries
http://www.opensource.apple.com/source/JavaScriptCore/JavaScriptCore-721.26/wtf/unicode/UTF8.cpp

http://icu-project.org/apiref/icu4c/index.html

### libiconv
I assume GPL/LGPL licensing restrictions would not be a problem.
https://www.gnu.org/software/libiconv/

iconv command line tool is available for *nix.
On Windows can use via Cygwin or use win_iconv.
https://en.wikipedia.org/wiki/Iconv

### glib
Sounds overly big for this application
https://en.wikipedia.org/wiki/GLib
https://developer.gnome.org/glib/2.30/glib-Unicode-Manipulation.html

---