import 'package:reed_solomon/reed_solomon.dart';

void main() {
  List<int> messageIn = [8, 32, 22, 28, 24, 57, 33, 50, 46, 46, 38, 8, 32, 35, 13, 8, 7, 31, 6, 49, 29, 52, 31, 43, 16];

  ReedSolomon reedSolomon = ReedSolomon(
    symbolSizeInBits: 6,
    numberOfCorrectableSymbols: 6,
    primitivePolynomial: 67,
    initialRoot: 1,
  );

  try {
    List<int> messageOut = reedSolomon.decode(messageIn); 
    // messageOut = [8, 32, 22, 28, 24, 57, 33, 50, 46, 46, 38, 8, 32];
    // TODO: implement try
  } on ReedSolomonException catch(e) {
    // TODO: implement catch
  } 
}
