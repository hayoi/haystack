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

    if (jsonBody is String) {
      return _decoder.convert(jsonBody);
    } else {
      return jsonBody;
    }
  }

  Dio get dio {
    Dio dio = new Dio();
    // Set default configs
    dio.options.baseUrl = 'http://192.168.1.186:5000/';
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      /// Do something before request is sent
      /// set the token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      options.headers["Authorization"] = "Bearer ${r"${prefs.getString('token')}"}";

      print("Pre request:${r"${options.method}"},${r"${options.baseUrl}"}${r"${options.path}"}");
      print("Pre request:${r"${options.headers.toString()}"}");

      return options; //continue
    }, onResponse: (Response response) async {
      // Do something with response data
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        if (response.request.path == "login/") {
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          /// login complete, save the token
          /// response data:
          /// {
          ///   "code": 0,
          ///   "data": Object,
          ///   "msg": "OK"
          ///  }
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
      } else if(statusCode == 401){
        /// token expired, re-login or refresh token
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var username = prefs.getString("username");
        var password = prefs.getString("password");
        FormData formData = new FormData.from({
          "username": username,
          "password": password,
        });
        new Dio().post("login/", data: formData).then((resp){
          final String jsonBody = response.data;
          final JsonDecoder _decoder = new JsonDecoder();
          final resultContainer = _decoder.convert(jsonBody);
          final int code = resultContainer['code'];
          if (code == 0) {
            final Map results = resultContainer['data'];
            prefs.setString("token", results["token"]);
            prefs.setInt("expired", results["expired"]);

            RequestOptions ro = response.request;
            ro.headers["Authorization"] = "Bearer ${r"${prefs.getString('token')}"}";
            return ro;
          } else {
            throw Exception("Exception in re-login");
          }
        });
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
