# Purpose
Convert from UTF-8 to UTF-32 without using standard "Unicode conversion faculties".

# Results

## Problem statement
"You cannot use any standard Unicode conversion faculties in your implementation."

## Assumptions
OK to use "standard unicode conversion faculties" to generate source UTF-8 string.
OK to use "standard unicode conversion faculties" to test other code.
Tests can get expected values by manually looking up some values.

## Plan
Start by using standard conversion methods to gain familiarity with API.
Then add custom methods.

### UTF-8 

#### Generate a UTF-8 string
Use "standard unicode conversion faculties" to generate source UTF-8 string.
Write a method to convert NSString to NSData or array of UTF-8 encoded bytes.

#### Decode UTF-8 string to Unicode code points
Implement a custom decoder.
Test convert strings containing characters that convert to 1, 2, and 3 byte lengths. 

### UTF-32 
Implement an encoder that converts Unicode code points to UTF-32.
In simplest encoding, start with all zeros, hex 00 00 00 00 and add unicode code point. 

---

# Appendix Background

## UTF-8 
Uses 1 to 4 bytes per code point.

## UTF-32
Uses fixed length 4 bytes per code point.
UTF-32 may be big-endian UTF-32BE or little endian UTF-32LE.
In simplest encoding, start with all zeros, hex 00 00 00 00 and add unicode code point. 

---

# References
MobileSDE-CodingProblem-Smartsheet.pdf by Smartsheet

## UTF-8
https://en.wikipedia.org/wiki/UTF-8
http://ratfactor.com/utf-8-to-unicode

## UTF-16
https://en.wikipedia.org/wiki/UTF-16

## UTF-32
https://en.wikipedia.org/wiki/UTF-32
