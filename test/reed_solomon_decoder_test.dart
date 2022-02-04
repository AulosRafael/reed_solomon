import 'package:dart_reed_solomon/src/reed_solomon.dart';
import 'package:dart_reed_solomon/src/reed_solomon_exception.dart';
import 'package:test/test.dart';

void main() {
  late int _codewordSize;
  late int _symbolSizeInBits;
  late ReedSolomon _sut;
  late List<int> _data;
  late List<int> _expected;

  group('Galois Field 1 (UPU 4-state barcode)', () {
    setUp(() {
      _symbolSizeInBits = 6;
      _codewordSize = (1 << _symbolSizeInBits);
      _sut = ReedSolomon(
        symbolSizeInBits: _symbolSizeInBits,
        numberOfCorrectableSymbols: 6,
        primitivePolynomial: 67,
        initialRoot: 1,
      );
      _data = [
        8,
        32,
        22,
        28,
        24,
        57,
        33,
        50,
        46,
        46,
        38,
        8,
        32,
        35,
        13,
        8,
        7,
        31,
        6,
        49,
        29,
        52,
        31,
        43,
        16
      ];
      _expected = [8, 32, 22, 28, 24, 57, 33, 50, 46, 46, 38, 8, 32];
    });

    test(
      'Given there are errors in the positions 4-6-10-13-16-23 when tries to decode then returns the _expected decoded list',
      () {
        // Assemble
        var error = List.filled(_data.length, 0);
        error[4] = error[6] = error[10] = error[13] = error[16] = error[23] = 5;

        var msgIn = List.generate(
          _data.length,
          (k) => (_data[k] ^ error[k]) % _codewordSize,
        );

        // Act
        var msgOut = _sut.decode(msgIn);

        // Assert
        expect(msgOut.sublist(0, _expected.length), _expected);
      },
    );

    test(
      'Given there are errors in the positions 2-4-13-19-22 when tries to decode then returns the _expected decoded list',
      () {
        // Assemble
        var error = List.filled(_data.length, 0);
        error[2] = error[19] = 1;
        error[4] = 3;
        error[13] = error[22] = 5;

        var msgIn = List.generate(
          _data.length,
          (k) => (_data[k] ^ error[k]) % _codewordSize,
        );

        // Act
        var msgOut = _sut.decode(msgIn);

        // Assert
        expect(msgOut.sublist(0, _expected.length), _expected);
      },
    );

    test(
      'Given there are errors in the positions 0 and 24 when tries to decode then returns the _expected decoded list',
      () {
        // Assemble
        var error = List.filled(_data.length, 0);
        error[0] = 10;
        error[24] = 5;

        var msgIn = List.generate(
          _data.length,
          (k) => (_data[k] ^ error[k]) % _codewordSize,
        );

        // Act
        var msgOut = _sut.decode(msgIn);

        // Assert
        expect(msgOut.sublist(0, _expected.length), _expected);
      },
    );

    test(
      'Given there are errors in the positions 2-3-4-6-10-13-16-23 when tries to decode then an Reed Solomon exception is thrown',
      () {
        // Assemble
        var error = List.filled(_data.length, 0);
        error[2] = error[3] = error[4] = error[6] = 3;
        error[10] = error[13] = error[16] = error[23] = 5;

        var msgIn = List.generate(
          _data.length,
          (k) => (_data[k] ^ error[k]) % _codewordSize,
        );

        // Act
        var action = () => _sut.decode(msgIn);

        // Assert
        expect(action, throwsA(isA<ReedSolomonException>()));
      },
    );

    test(
      'message is too long - Reed Solomon exception is thrown',
      () {
        // Assemble
        var _codewordSize = (1 << _symbolSizeInBits);
        var _msgIn = List<int>.filled(_codewordSize, 0);

        // Act
        var action = () => _sut.encode(_msgIn);

        // Assert
        expect(action, throwsA(isA<ReedSolomonException>()));
      },
    );
  });

  test(
    'Galois Field 2 (QR Code)',
    () {
      var _symbolSizeInBits = 8;
      var _codewordSize = (1 << _symbolSizeInBits);
      var _sut = ReedSolomon(
        symbolSizeInBits: _symbolSizeInBits,
        numberOfCorrectableSymbols: 5,
        primitivePolynomial: 285,
        initialRoot: 1,
      );

      // Assemble
      List<int> _data = [
        10,
        223,
        66,
        197,
        69,
        53,
        32,
        157,
        68,
        136,
        97,
        234,
        28,
        90,
        52,
        110,
        81,
        68,
        27,
        56,
        27,
        61,
        181,
        197,
        202,
        196,
        101,
        174,
        196,
        139,
        48,
        150,
        104,
        165,
        47,
        55,
        239,
        144,
        157,
        109,
        176,
        61,
        18,
        168,
        35,
        82,
        250,
        168,
        240,
        229,
        167,
        35,
        159,
        41,
        203,
        109,
        125,
        128,
        148,
        21,
        78,
        133,
        26,
        194,
        213,
        42,
        222,
        114,
        45,
        240,
        120,
        179,
        90,
        37,
        151,
        230,
        158,
        142,
        226,
        66,
        95,
        238,
        18,
        168,
        33,
        175,
        96,
        182,
        209,
        26,
        70,
        109,
        105,
        169,
        234,
        232,
        254,
        233,
        20,
        39,
        166,
        125,
        202,
        178,
        141,
        165,
        31,
        241,
        7,
        5,
        16,
        222,
        180,
        120,
        212,
        249,
        23,
        100,
        206,
        250,
        61,
        247,
        95,
        25,
        74,
        225,
        228,
        185,
        159,
        248,
        200,
        183,
        148,
        195,
        51,
        158,
        53,
        156,
        223,
        44,
        128,
        250,
        242,
        222,
        211,
        82,
        10,
        90,
        91,
        12,
        3,
        78,
        86,
        7,
        84,
        247,
        247,
        9,
        101,
        227,
        124,
        139,
        8,
        209,
        133,
        10,
        242,
        196,
        177,
        156,
        240,
        188,
        24,
        210,
        248,
        234,
        164,
        94,
        209,
        91,
        241,
        196,
        66,
        167,
        97,
        58,
        176,
        203,
        35,
        56,
        173,
        109,
        249,
        78,
        38,
        211,
        246,
        42,
        255,
        225,
        185,
        170,
        159,
        28,
        17,
        55,
        24,
        174,
        184,
        30,
        95,
        58,
        246,
        34,
        61,
        31,
        132,
        182,
        164,
        187,
        11,
        219,
        221,
        219,
        229,
        71,
        22,
        233,
        199,
        198,
        195,
        242,
        174,
        163,
        243,
        179,
        193,
        39,
        101,
        79,
        166,
        232,
        63,
        124,
        36,
        20,
        51,
        33,
        131,
        93,
        14,
        55,
        221,
        6,
        255
      ];

      List<int> _expected = [
        10,
        223,
        66,
        197,
        69,
        53,
        32,
        157,
        68,
        136,
        97,
        234,
        28,
        90,
        52,
        110,
        81,
        68,
        27,
        56,
        27,
        61,
        181,
        197,
        202,
        196,
        101,
        174,
        196,
        139,
        48,
        150,
        104,
        165,
        47,
        55,
        239,
        144,
        157,
        109,
        176,
        61,
        18,
        168,
        35,
        82,
        250,
        168,
        240,
        229,
        167,
        35,
        159,
        41,
        203,
        109,
        125,
        128,
        148,
        21,
        78,
        133,
        26,
        194,
        213,
        42,
        222,
        114,
        45,
        240,
        120,
        179,
        90,
        37,
        151,
        230,
        158,
        142,
        226,
        66,
        95,
        238,
        18,
        168,
        33,
        175,
        96,
        182,
        209,
        26,
        70,
        109,
        105,
        169,
        234,
        232,
        254,
        233,
        20,
        39,
        166,
        125,
        202,
        178,
        141,
        165,
        31,
        241,
        7,
        5,
        16,
        222,
        180,
        120,
        212,
        249,
        23,
        100,
        206,
        250,
        61,
        247,
        95,
        25,
        74,
        225,
        228,
        185,
        159,
        248,
        200,
        183,
        148,
        195,
        51,
        158,
        53,
        156,
        223,
        44,
        128,
        250,
        242,
        222,
        211,
        82,
        10,
        90,
        91,
        12,
        3,
        78,
        86,
        7,
        84,
        247,
        247,
        9,
        101,
        227,
        124,
        139,
        8,
        209,
        133,
        10,
        242,
        196,
        177,
        156,
        240,
        188,
        24,
        210,
        248,
        234,
        164,
        94,
        209,
        91,
        241,
        196,
        66,
        167,
        97,
        58,
        176,
        203,
        35,
        56,
        173,
        109,
        249,
        78,
        38,
        211,
        246,
        42,
        255,
        225,
        185,
        170,
        159,
        28,
        17,
        55,
        24,
        174,
        184,
        30,
        95,
        58,
        246,
        34,
        61,
        31,
        132,
        182,
        164,
        187,
        11,
        219,
        221,
        219,
        229,
        71,
        22,
        233,
        199,
        198,
        195,
        242,
        174,
        163,
        243,
        179,
        193,
        39,
        101,
        79,
        166,
        232,
        63,
        124,
        36
      ];

      var error = List.filled(_data.length, 0);
      error[29] = 177;
      error[181] = 142;
      error[186] = 28;
      error[195] = 2;

      var msgIn = List.generate(
        _data.length,
        (k) => (_data[k] ^ error[k]) % _codewordSize,
      );

      // Act
      var msgOut = _sut.decode(msgIn);

      // Assert
      expect(msgOut.sublist(0, _expected.length), _expected);
    },
  );

  test(
    'Galois Field 3 (Data Matrix Code)',
    () {
      var _symbolSizeInBits = 8;
      var _codewordSize = (1 << _symbolSizeInBits);
      var _sut = ReedSolomon(
        symbolSizeInBits: _symbolSizeInBits,
        numberOfCorrectableSymbols: 9,
        primitivePolynomial: 301,
        initialRoot: 1,
      );

      // Assemble
      List<int> _data = [
        232,
        131,
        133,
        175,
        161,
        150,
        130,
        130,
        141,
        147,
        149,
        141,
        155,
        140,
        66,
        67,
        68,
        69,
        142,
        164,
        129,
        118,
        255,
        4,
        53,
        128,
        255,
        2,
        218,
        96,
        83,
        214,
        194,
        16,
        146,
        194,
        131,
        16,
        241,
        255
      ];

      List<int> _expected = [
        232,
        131,
        133,
        175,
        161,
        150,
        130,
        130,
        141,
        147,
        149,
        141,
        155,
        140,
        66,
        67,
        68,
        69,
        142,
        164,
        129,
        118
      ];

      var error = List.filled(_data.length, 0);
      error[0] = 1;
      error[22] = 6;
      error[39] = 4;
      error[31] = 9;
      error[13] = 10;

      var msgIn = List.generate(
        _data.length,
        (k) => (_data[k] ^ error[k]) % _codewordSize,
      );

      // Act
      var msgOut = _sut.decode(msgIn);

      // Assert
      expect(msgOut.sublist(0, _expected.length), _expected);
    },
  );
}
