import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple DI
class Injector {
  static final Injector _singleton = new Injector._internal();

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  Future<SharedPreferences> get sharedP async {
    return await SharedPreferences.getInstance();
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
      options.headers["Authorization"] =
          "Bearer ${r"${prefs.getString('token')}"}";

      print(
          "Pre request: ${r"${options.method}"} ${r"${options.baseUrl}"}${r"${options.path}"}");
      print("Pre request ${r"${options.headers.toString()}"}");

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

      print(
          "Response From: ${r"${response.request.method}"} ${r"${response.request.baseUrl}"}${r"${response.request.path}"}");
      print("Response From: ${r"${response.toString()}"}");
      return response; // continue
    }, onError: (DioError e) {
      // Do something with response error
      return DioError; //continue
    }));
    return dio;
  }
}
