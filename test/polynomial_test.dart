import 'package:test/test.dart';
import 'package:dart_reed_solomon/src/galois_field.dart';
import 'package:dart_reed_solomon/src/polynomial.dart';

void main() {
  GaloisField _galoisField;
  GFPolynomial _sut;

  setUpAll(() {
    _galoisField = GaloisField(285, 256);
    _sut = GFPolynomial(_galoisField, <int>[1, 15, 54, 120, 64]);
  });

  test('length and degree of polynomial', () {
    // Assemble
    var degreeExpected = 4;
    var lengthExpected = 5;

    // Act
    var degree = _sut.degree;
    var length = _sut.length;

    // Assert
    expect(degree, degreeExpected);
    expect(length, lengthExpected);
  });

  test('multiply polynomial by escalar', () {
    // Assemble
    var a = 7;
    var expected = [7, 45, 130, 117, 221];

    // Act
    var result = _sut.multiplyByScalar(a).coefficients;

    // Assert
    expect(result, expected);
  });

  test('add polynomials', () {
    // Assemble
    var q = GFPolynomial(_galoisField, <int>[1, 23, 76]);
    var expected = [1, 15, 55, 111, 12];

    // Act
    var result = _sut.add(q).coefficients;

    // Assert
    expect(result, expected);
  });

  test('multiply polynomials', () {
    // Assemble
    var q = GFPolynomial(_galoisField, <int>[1, 23, 76]);
    var expected = [1, 24, 167, 30, 146, 216, 234];

    // Act
    var result = _sut.multiply(q).coefficients;

    // Assert
    expect(result, expected);
  });

  test('divide polynomials', () {
    // Assemble
    var q = GFPolynomial(_galoisField, <int>[1, 23, 76]);
    var quotientExpected = [1, 24, 175];
    var remainderExpected = [222, 95];

    // Act
    var result = _sut.divide(q);
    var quotient = result[0].coefficients;
    var remainder = result[1].coefficients;

    // Assert
    expect(quotient, quotientExpected);
    expect(remainder, remainderExpected);
  });

  test('evaluate polynomial', () {
    // Assemble
    var a = 3;
    var expected = 98;

    // Act
    var result = _sut.evaluate(a);

    // Assert
    expect(result, expected);
  });

  test('multiply polynomial by monomial', () {
    // Assemble
    var degree = 2;
    var coeff = 3;
    var expected = [3, 17, 90, 136, 192, 0, 0];

    // Act
    var result = _sut.multiplyByMonominal(degree, coeff).coefficients;

    // Assert
    expect(result, expected);
  });
}
