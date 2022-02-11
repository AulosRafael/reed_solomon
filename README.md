# Reed Solomon (Sound Null Safe fork)

_This package is a temporary fork of [dart_reed_solomon](https://pub.dartlang.org/packages/dart_reed_solomon) that adds sound null safety. The following description is taken from the original package._

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

and encode `message`
```dart
reedSolomon.encode(message);
```

or decode `message`
```dart
reedSolomon.decode(message);
```

where `message` is a list of integers.
