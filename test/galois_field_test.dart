import 'package:test/test.dart';
import 'package:dart_reed_solomon/src/galois_field.dart';

void main() {
  GaloisField _sut;

  setUpAll(() {
    _sut = GaloisField(285, 256);
  });

  test('add numbers', () {
    // Assemble
    var a = 51;
    var b = 29;
    var expected = 46;

    // Act
    var result = _sut.add(a, b);

    // Assert
    expect(result, expected);
  });

  test('multiply numbers with a or b equal to zero', () {
    // Assemble
    var a = 0;
    var b = 29;
    var expected = 0;

    // Act
    var result = _sut.multiply(a, b);

    // Assert
    expect(result, expected);
  });

  test('multiply numbers with a and b nonzero', () {
    // Assemble
    var a = 137;
    var b = 42;
    var expected = 195;

    // Act
    var result = _sut.multiply(a, b);

    // Assert
    expect(result, expected);
  });

  test('divide numbers with a equal to zero', () {
    // Assemble
    var a = 0;
    var b = 42;
    var expected = 0;

    // Act
    var result = _sut.divide(a, b);

    // Assert
    expect(result, expected);
  });

  test('divide numbers with b equal to zero', () {
    // Assemble
    var a = 137;
    var b = 0;

    // Act
    var action = () => _sut.divide(a, b);

    // Assert
    expect(action, throwsA(isA<IntegerDivisionByZeroException>()));
  });

  test('divide numbers with a and b nonzero', () {
    // Assemble
    var a = 137;
    var b = 42;
    var expected = 220;

    // Act
    var result = _sut.divide(a, b);

    // Assert
    expect(result, expected);
  });

  test('inverse number', () {
    // Assemble
    var a = 137;
    var expected = 49;

    // Act
    var result = _sut.inverse(a);

    // Assert
    expect(result, expected);
  });

  test('pow number', () {
    // Assemble
    var a = 137;
    var expected = 82;

    // Act
    var result = _sut.pow(a, 2);

    // Assert
    expect(result, expected);
  });
}
