# Reed Solomon

An implementation of Reed-Solomon error correction using Dart language.

Based on [Reed–Solomon codes for coders](https://en.m.wikiversity.org/wiki/Reed–Solomon_codes_for_coders).

## Usage

Create a new `ReedSolomon` object
```dart
var reedSolomon = ReedSolomon(
        symbolSizeInBits: 8,
        numberOfCorrectableSymbols: 5,
        primitivePolynomial: 285,
        initialRoot: 1,
      );
```

and decode `message`
```dart
reedSolomon.decode(message);
```

where `message` is a list of integers.
