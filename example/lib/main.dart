import 'package:dart_reed_solomon/reed_solomon.dart';

void main() {
  List<int> messageIn, messageOut;

  ReedSolomon reedSolomon = ReedSolomon(
    symbolSizeInBits: 6,
    numberOfCorrectableSymbols: 6,
    primitivePolynomial: 67,
    initialRoot: 1,
  );

  // ENCODER
  try {
    messageIn = [8, 32, 22, 28, 24, 57, 33, 50, 46, 46, 38, 8, 32];
    messageOut = reedSolomon.encode(messageIn); 
  } on ReedSolomonException catch(e) {
    // TODO: implement catch
  }

  // DECODER
  try {
    messageIn = [8, 32, 22, 28, 24, 57, 33, 50, 46, 46, 38, 8, 32, 35, 13, 8, 7, 31, 6, 49, 29, 52, 31, 43, 16];
    messageOut = reedSolomon.decode(messageIn); 
  } on ReedSolomonException catch(e) {
    // TODO: implement catch
  } 

}
