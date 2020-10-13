import 'package:reed_solomon/reed_solomon.dart';

void main() {
  ReedSolomon reedSolomon = ReedSolomon(
    symbolSizeInBits: 8,
    numberOfCorrectableSymbols: 9,
    primitivePolynomial: 301,
    initialRoot: 1,
  );

  List<int> messageIn = [233, 131, 133, 175, 161, 150, 130, 130, 141, 147, 149, 141, 155, 134, 66, 67, 68, 69, 142, 164, 129, 118, 249, 4, 53, 128, 255, 2, 218, 96, 83, 223, 194, 16, 146, 194, 131, 16, 241, 251];
  List<int> messageOut = reedSolomon.decode(messageIn);

  print(messageOut);
  // [232, 131, 133, 175, 161, 150, 130, 130, 141, 147, 149, 141, 155, 140, 66, 67, 68, 69, 142, 164, 129, 118];
}
