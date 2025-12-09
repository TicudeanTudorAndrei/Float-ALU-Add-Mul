# Floating-Point ALU (IEEE-754 Single Precision)

This project implements a floating-point ALU in VHDL, supporting IEEE-754 single-precision addition and multiplication. 

The design includes exponent alignment, mantissa processing, normalization, rounding, exception handling, and full simulation through custom Vivado testbenches. The ALU integrates modular components such as adders, shifters, normalizers, matrix multipliers, and edge-case handlers.

## Features
- IEEE-754 single-precision floating-point addition
- IEEE-754 single-precision floating-point multiplication
- Automatic normalization and rounding
- Overflow / underflow detection
- NaN and ±Infinity handling
- Fully modular VHDL structure (aligner, mantissa processor, normalizer, exponent unit, matrix multiplier, etc.)

## Floating-Point Addition Algorithm (IEEE-754)
1. Unpack Fields
    - Extract the sign, exponent, and mantissa from both operands
    - Add the implicit leading 1 to the mantissa for normalized numbers
2. Align Exponents
    - Compare the exponents of the two numbers
    - Shift the mantissa of the number with the smaller exponent to the right until both exponents are equal
3. Add/Subtract Mantissas
    - If the signs of the operands are the same, add the mantissas
    - If the signs differ, subtract the smaller mantissa from the larger
    - Determine the sign of the result based on the operand magnitudes and signs
4. Normalize Result
    - Shift the mantissa left or right to restore the leading 1 in normalized numbers
    - Adjust the exponent accordingly
5. Round Result
    - Apply rounding rules (e.g., round to nearest even) to maintain precision
6. Repack into IEEE-754 Format
    - Combine the sign, adjusted exponent, and mantissa into a 32-bit floating-point number
7. Handle Special Cases
    - NaN: result is NaN if any operand is NaN
    - ±Infinity: handle overflow conditions
    - ±0: maintain correct sign
    - Overflow/Underflow: adjust exponent and signal exceptions

## Floating-Point Multiplication Algorithm (IEEE-754)
1. Unpack Fields
    - Extract sign, exponent, and mantissa
    - Add implicit leading 1 for normalized numbers
2. Compute Sign
    - XOR the signs of the operands to determine the result sign
3. Add Exponents
    - Sum the exponents of the operands and subtract the bias (127 for single-precision)
4. Multiply Mantissas
    - Multiply the mantissas using a matrix-based or partial-product generator
    - Resulting mantissa may be twice as wide, requiring normalization
5. Normalize Result
    - Shift mantissa left or right to restore the leading 1
    - Adjust the exponent accordingly
6. Round Result
    - Apply rounding (e.g., round to nearest even)
7. Repack into IEEE-754 Format
    - Combine the sign, adjusted exponent, and mantissa into 32-bit floating-point format
8. Exception Handling
    - NaN: if any operand is NaN or invalid operation occurs
    - ±Infinity: handle overflow or division by zero scenarios
    - Overflow/Underflow: detect and signal as appropriate
  
