import 'package:bytebank/models/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should return the value when create a transaction', () {
    final transaction = Transaction(null, 200, null);
    expect(transaction.value, 200);
  });

  test('Should show error when create transaction with less than zero', (){
    expect(() => Transaction(null, 0, null), throwsAssertionError);
  });
}
