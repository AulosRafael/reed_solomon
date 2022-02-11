import 'package:dart_reed_solomon_nullsafety/src/reed_solomon.dart';
import 'package:dart_reed_solomon_nullsafety/src/reed_solomon_exception.dart';
import 'package:test/test.dart';

void main() {
  late int _symbolSizeInBits;
  late ReedSolomon _sut;
  late List<int> _data;
  late List<int> _expected;

  group('Galois Field 1 (UPU 4-state barcode)', () {
    setUp(() {
      _symbolSizeInBits = 6;
      _sut = ReedSolomon(
        symbolSizeInBits: _symbolSizeInBits,
        numberOfCorrectableSymbols: 6,
        primitivePolynomial: 67,
        initialRoot: 1,
      );

      _data = [8, 32, 22, 28, 24, 57, 33, 50, 46, 46, 38, 8, 32];
      _expected = [52, 48, 21, 62, 52, 17, 51, 54, 13, 52, 0, 12];
    });

    test(
      'Endode data',
      () {
        // Act
        var msgOut = _sut.encode(_data);

        // Assert
        expect(msgOut, _expected);
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
      var _sut = ReedSolomon(
        symbolSizeInBits: 8,
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
        36
      ];
      List<int> _expected = [160, 203, 123, 7, 218, 229, 97, 178, 55, 240];

      // Act
      var msgOut = _sut.encode(_data);

      // Assert
      expect(msgOut, _expected);
    },
  );

  test(
    'Galois Field 3 (Data Matrix Code)',
    () {
      var _sut = ReedSolomon(
        symbolSizeInBits: 8,
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
        118
      ];
      List<int> _expected = [
        60,
        16,
        16,
        56,
        213,
        39,
        201,
        249,
        73,
        114,
        88,
        240,
        51,
        230,
        54,
        113,
        152,
        234
      ];

      // Act
      var msgOut = _sut.encode(_data);

      // Assert
      expect(msgOut, _expected);
    },
  );
}
