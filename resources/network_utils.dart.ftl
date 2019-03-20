import 'dart:convert';
import 'package:dio/dio.dart';

class NetworkUtils {
  static final NetworkUtils _singleton = new NetworkUtils._internal();

  factory NetworkUtils() {
    return _singleton;
  }

  NetworkUtils._internal();

  final JsonDecoder _decoder = new JsonDecoder();

  dynamic decodeResp(d) {
    // ignore: cast_to_non_type
    var response = d as Response;
    final String jsonBody = response.data;
    final statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
      throw new Exception("statusCode: $statusCode");
    }

    final contactsContainer = _decoder.convert(jsonBody);
    final String msg = contactsContainer['msg'];
    final int code = contactsContainer['code'];
    final results = contactsContainer['data'];
    if (code != 10000) {
      throw new Exception("statusCode:$code, msg: $msg");
    }
    return results;
  }
}
