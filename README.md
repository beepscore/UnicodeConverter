# Purpose
Convert from UTF-8 to UTF-32 without using standard "Unicode conversion faculties".

# References
MobileSDE-CodingProblem-Smartsheet.pdf by Smartsheet

UTF-8
https://en.wikipedia.org/wiki/UTF-8
UTF-16
https://en.wikipedia.org/wiki/UTF-16
UTF-32
https://en.wikipedia.org/wiki/UTF-32

# Results
Problem statement-
"You cannot use any standard Unicode conversion faculties in your implementation."

## Assumptions
Problem statement may allow using some "standard unicode conversion faculties" for setup and testing.
Assume can use conversion to generate test input.
Tests can get expected values by manually looking up some values.
Tests can get expected values using standard conversion faculties?

## Plan
Start with simple implementation to practice using standard conversion API.
Later could avoid some standard conversions
e.g. use NSString* pointer address and string length and read bytes.

Write a method to convert NSString to NSData or array of UTF-8 encoded bytes.
May need to null terminate array similar to a C string, or else pass length around as metadata.
Test convert strings containing characters that convert to 1, 2, and 3 byte lengths. 

Convert UTF-8 to UTF-32.
Is there any advantage to going through intermediate format code points?
Is there any advantage to going through intermediate format UTF-16?
I think UTF-16 allows different endian byte order.
Does UTF-32 allow different endian byte order?
