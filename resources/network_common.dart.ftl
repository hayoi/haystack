import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkCommon {
  static final NetworkCommon _singleton = new NetworkCommon._internal();

  factory NetworkCommon() {
    return _singleton;
  }

  NetworkCommon._internal();

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
    if (code != 0) {
      throw new Exception("statusCode:$code, msg: $msg");
    }
    return results;
  }

  Dio get dio {
    Dio dio = new Dio();
    // Set default configs
    dio.options.baseUrl = 'http://192.168.1.186:5000/';
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      // Do something before request is sent
      // set the token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      options.headers["Authorization"] = "Bearer ${r"${prefs.getString('token')}"}";

      print("Pre request:${r"${options.method}"},${r"${options.baseUrl}"}${r"${options.path}"}");
      print("Pre request:${r"${options.headers.toString()}"}");

      return options; //continue
    }, onResponse: (Response response) async {
      // Do something with response data

      if (response.request.path == "login/") {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        final int statusCode = response.statusCode;

        if (statusCode == 200) {
          final String jsonBody = response.data;
          final JsonDecoder _decoder = new JsonDecoder();
          final resultContainer = _decoder.convert(jsonBody);
          final int code = resultContainer['code'];
          if (code == 0) {
            final Map results = resultContainer['data'];
            prefs.setString("token", results["token"]);
            prefs.setInt("expired", results["expired"]);
          }
        }
      }

      print("Response From:${r"${response.request.method}"},${r"${response.request.baseUrl}"}${r"${response.request.path}"}");
      print("Response From:${r"${response.toString()}"}");
      return response; // continue
    }, onError: (DioError e) {
      // Do something with response error
      return DioError; //continue
    }));
    return dio;
  }
}
