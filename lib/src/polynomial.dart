import 'package:reed_solomon/src/galois_field.dart';
import 'dart:math' as math;

class GFPolynomial {
  final GaloisField _galoisField;
  List<int> _coefficients;

  GFPolynomial(this._galoisField, this._coefficients) {
    while (this.length > 1 && this.isZero) {
      this._coefficients = this._coefficients.sublist(1);
    }
  }

  GFPolynomial.zero(this._galoisField, int len) {
    this._coefficients = List.filled(len, 0);
  }

  List<int> get coefficients => this._coefficients;
  bool get isZero => this._coefficients[0] == 0;
  int get degree => this._coefficients.length - 1;
  int get length => this._coefficients.length;

  int operator [](int i) => this._coefficients[i];
  void operator []=(int i, int value) => this._coefficients[i] = value;

  GFPolynomial multiplyByScalar(int a) {
    List<int> result = List<int>.filled(this.length, 0);
    for (int i = 0; i < this.length; i++) {
      result[i] = this._galoisField.multiply(this._coefficients[i], a);
    }

    return GFPolynomial(this._galoisField, result);
  }

  GFPolynomial add(GFPolynomial q) {
    if (this.isZero) {
      return q;
    } else if (q.isZero) {
      return this;
    }

    int len = math.max(this.length, q.length);
    List<int> result = List<int>.filled(len, 0);

    for (int i = 0; i < this.length; i++) {
      result[i + result.length - this.length] ^= this._coefficients[i];
    }

    for (int i = 0; i < q.length; i++) {
      result[i + result.length - q.length] ^= q[i];
    }

    return GFPolynomial(this._galoisField, result);
  }

  GFPolynomial multiply(GFPolynomial q) {
    if (this.isZero || q.isZero) {
      return GFPolynomial.zero(this._galoisField, 1);
    }

    int len = this.length + q.length - 1;
    List<int> result = List<int>.filled(len, 0);

    for (int j = 0; j < q.length; j++) {
      for (int i = 0; i < this.length; i++) {
        result[i + j] ^=
            this._galoisField.multiply(this._coefficients[i], q[j]);
      }
    }

    return GFPolynomial(this._galoisField, result);
  }

  int evaluate(int a) {
    int y = this._coefficients[0];
    for (int i = 1; i < this.length; i++) {
      y = this._galoisField.multiply(y, a) ^ this._coefficients[i];
    }

    return y;
  }

  List<GFPolynomial> divide(GFPolynomial divisor) {
    if (this.degree < divisor.degree) {
      return <GFPolynomial>[
        GFPolynomial(this._galoisField, <int>[0]),
        this
      ];
    }

    GFPolynomial remainder =
        GFPolynomial(this._galoisField, List.from(this.coefficients));
    int coef;

    for (int i = 0; i < this.length - divisor.length + 1; i++) {
      coef = remainder[i];
      if (coef != 0) {
        for (int j = 1; j < divisor.length; j++) {
          if (divisor[j] != 0) {
            remainder[i + j] =
                remainder[i + j] ^ this._galoisField.multiply(divisor[j], coef);
          }
        }
      }
    }

    int separator = divisor.length - 1;

    return <GFPolynomial>[
      GFPolynomial(
        remainder._galoisField,
        remainder.coefficients.sublist(
          0,
          remainder.length - separator,
        ),
      ),
      GFPolynomial(
        remainder._galoisField,
        remainder.coefficients.sublist(
          remainder.length - separator,
        ),
      )
    ];
  }

  GFPolynomial multiplyByMonominal(int degree, int coeff) {
    if (coeff == 0) {
      return GFPolynomial.zero(this._galoisField, 1);
    }

    int size = this.length;
    List<int> result = List<int>.filled(size + degree, 0);

    for (int i = 0; i < size; i++) {
      result[i] = this._galoisField.multiply(this.coefficients[i], coeff);
    }

    return GFPolynomial(this._galoisField, result);
  }
}
