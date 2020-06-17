import 'dart:convert';

import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';

class TransactionWebClient {

  Future<List<Transaction>> findAll() async {
    final Response response =
    await client.get(baseUrl);

    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((json) => Transaction.fromJson(json)).toList();
  }

  Future<Transaction> save(Transaction transaction, password) async {
    // Converte o Map para Json
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(
      baseUrl,
      headers: {
        'Content-type': 'application/json',
        'password': password,
      },
      body: transactionJson,
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }

    throw HttpException(_getMessage(response.statusCode));
  }

  String _getMessage(int statusCode) {
    if(_statusCodeResponses.containsKey(statusCode)) return _statusCodeResponses[statusCode];
    return 'Unknown error';
  }

  static final Map<int, String> _statusCodeResponses = {
    400: 'there was an error, submitting transaction',
    401: 'Authentication failed',
    409: 'transaction always exists'
  };
}
class HttpException implements Exception {

  final String message;
  final Duration duration;

  HttpException(this.message, [this.duration]);

  String toString() {
    String result = "HttpException";
    if (duration != null) result = "HttpException after $duration";
    if (message != null) result = "$result: $message";
    return result;
  }
}