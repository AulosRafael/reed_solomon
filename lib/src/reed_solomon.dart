import 'package:reed_solomon/src/galois_field.dart';
import 'package:reed_solomon/src/polynomial.dart';
import 'package:reed_solomon/src/reed_solomon_exception.dart';
import 'package:meta/meta.dart';

class ReedSolomon {
  final GaloisField _galoisField;
  final int _eccCount;
  final int _power;

  ReedSolomon({
    @required int symbolSizeInBits,
    @required int numberOfCorrectableSymbols,
    @required int primitivePolynomial,
    @required int initialRoot,
  })  : this._galoisField = GaloisField(
          primitivePolynomial,
          1 << symbolSizeInBits,
        ),
        this._eccCount = 2 * numberOfCorrectableSymbols,
        this._power = initialRoot;

  /// returns decoded [data]
  /// or throw [ReedSolomonException] if data cannot be decoded
  List<int> decode(List<int> data) {
    if (data.length > this._galoisField.size - 1) {
      throw ReedSolomonException(
          'message is too long, ${data.length} when max is ${this._galoisField.size - 1}');
    }

    GFPolynomial poly = GFPolynomial(this._galoisField, data);
    GFPolynomial synd = this._calculateSyndromes(poly);

    if (synd.isZero) return data.sublist(0, data.length - this._eccCount);

    GFPolynomial correctedData =
        this._correctError(GFPolynomial(this._galoisField, data), synd);
    synd = this._calculateSyndromes(correctedData);

    if (synd.isZero)
      return correctedData.coefficients
          .sublist(0, data.length - this._eccCount);

    throw ReedSolomonException('Data cannot be decoded');
  }

  GFPolynomial _calculateSyndromes(GFPolynomial data) {
    List<int> synd = List.filled(this._eccCount, 0, growable: true);

    for (int i = 0; i < this._eccCount; i++) {
      synd[i] = data.evaluate(this._galoisField.pow(2, i + this._power));
    }

    return GFPolynomial(this._galoisField, synd..insert(0, 0));
  }

  // Berlekamp-Massey algorithm
  GFPolynomial _findErrorLocator(GFPolynomial synd) {
    GFPolynomial locator = GFPolynomial(this._galoisField, <int>[1]);
    GFPolynomial oldLocator = GFPolynomial(this._galoisField, <int>[1]);

    int syndShift = 0;
    int k, delta;

    for (int i = 0; i < this._eccCount; i++) {
      k = i + syndShift;
      delta = synd[k];
      for (int j = 1; j < locator.length; j++) {
        int a = locator[locator.length - j - 1];
        int b = synd[k < j ? synd.length + k - j : k - j];
        delta = this._galoisField.add(delta, this._galoisField.multiply(a, b));
      }

      oldLocator = oldLocator.multiplyByMonominal(1, 1);

      if (delta != 0) {
        if (oldLocator.length > locator.length) {
          GFPolynomial tmp = oldLocator.multiplyByScalar(delta);
          oldLocator =
              locator.multiplyByScalar(this._galoisField.inverse(delta));
          locator = tmp;
        }

        locator = locator.add(oldLocator.multiplyByScalar(delta));
      }
    }

    GFPolynomial lambda = GFPolynomial(this._galoisField, locator.coefficients);

    return lambda;
  }

  List<int> _findErrorPositions(GFPolynomial lambda, int nmsg) {
    int errs = lambda.length - 1;
    List<int> errorPos = List<int>();
    int nsymbols = this._galoisField.size - 1;

    for (int i = 0; i < nsymbols; i++) {
      if (lambda.evaluate(this._galoisField.pow(2, i + this._power)) == 0) {
        errorPos.add((nsymbols - 1 - i));
      }
    }

    if (errorPos.length != errs) {
      throw ReedSolomonException('Too many or few errors found');
    }

    return errorPos;
  }

  GFPolynomial _findErrorEvaluator(
      GFPolynomial synd, GFPolynomial locators, int nsym) {
    GFPolynomial p = synd.multiply(locators);
    GFPolynomial q =
        GFPolynomial(this._galoisField, [1]..addAll(List.filled(nsym + 1, 0)));
    return p.divide(q)[1];
  }

  GFPolynomial _correctError(GFPolynomial data, GFPolynomial synd) {
    GFPolynomial lambda = this._findErrorLocator(synd);

    // Too many errors to correct
    if ((lambda.length - 1) * 2 > this._eccCount) {
      throw ReedSolomonException('Too many errors to correct');
    }

    List<int> coefsPos = this._findErrorPositions(lambda, data.length);
    if (coefsPos == null) return data;

    List<int> idError = List.generate(
        coefsPos.length, (index) => data.length - 1 - coefsPos[index]);

    GFPolynomial omega = this._findErrorEvaluator(
        GFPolynomial(this._galoisField, synd.coefficients.reversed.toList()),
        lambda,
        lambda.length - 1);

    // lambda's roots
    List<int> xInv = [];
    for (int i = 0; i < coefsPos.length; i++) {
      int l = this._galoisField.size - 1 - coefsPos[i];
      xInv.add(this._galoisField.pow(2, l));
    }

    GFPolynomial error = GFPolynomial.zero(this._galoisField, data.length);
    int a, b;
    int magnitude;

    // formal derivative
    List<int> derivative = List<int>();
    for (int i = 0; i < lambda.length - 1; i++) {
      int degree = lambda.length - 1 - i;
      derivative.add(degree.isEven ? 0 : lambda[i]);
    }

    GFPolynomial dLambda = GFPolynomial(this._galoisField, derivative);

    for (int i = 0; i < xInv.length; i++) {
      b = dLambda.evaluate(xInv[i]);

      //Could not find error magnitude
      if (b == 0) throw ReedSolomonException('Could not find error magnitude');

      a = omega.evaluate(xInv[i]);

      magnitude = this._galoisField.divide(a, b);
      error[idError[i]] = magnitude;
    }

    return data.add(GFPolynomial(this._galoisField, error.coefficients));
  }
}
