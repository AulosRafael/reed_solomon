class GaloisField {
  final int _size;
  final List<int> _log;
  final List<int> _aLog;

  GaloisField(int pp, this._size)
      : this._aLog = List<int>.filled(_size, 0),
        this._log = List<int>.filled(_size, 0) {
    var x = 1;
    for (var i = 0; i < this._size; i++) {
      this._aLog[i] = x;
      this._log[x] = i;
      x <<= 1;
      if (x >= this._size) {
        x = (x ^ pp) & (this._size - 1);
      }
    }
  }

  int get size => this._size;

  int add(int a, int b) {
    return a ^ b;
  }

  int multiply(int a, int b) {
    if (a == 0 || b == 0) {
      return 0;
    }

    return this._aLog[(this._log[a] + this._log[b]) % (this._size - 1)];
  }

  int divide(int a, int b) {
    if (b == 0) {
      throw IntegerDivisionByZeroException();
    } else if (a == 0) {
      return 0;
    }

    return this._aLog[
        (this._log[a] + (this._size - 1) - this._log[b]) % (this._size - 1)];
  }

  int inverse(int x) {
    return this._aLog[(this._size - 1) - this._log[x]];
  }

  int pow(int x, int power) {
    return this._aLog[(this._log[x] * power) % (this._size - 1)];
  }
}
