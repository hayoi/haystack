import 'dart:async';
import 'package:dio/dio.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:${ProjectName}/data/network_common.dart';

class ${ModelEntryName}Repository {
  const ${ModelEntryName}Repository();

  Future<Map> get${ModelEntryName}sList(String sorting, int page, int limit) {
    return new NetworkCommon().dio.get("${(ModelEntryName)?lower_case}/", queryParameters: {
      "sorting": sorting,
      "page": page,
      "limit": limit
    }).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return results;
    });
  }

  Future<${ModelEntryName}> create${ModelEntryName}(${ModelEntryName} ${(ModelEntryName)?lower_case}) {
    var dio = new NetworkCommon().dio;
    dio.options.headers.putIfAbsent("Accept", () {
      return "application/json";
    });
    return dio.post("${(ModelEntryName)?lower_case}/", data: ${(ModelEntryName)?lower_case}).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return new ${ModelEntryName}.fromJson(results);
    });
  }

  Future<${ModelEntryName}> update${ModelEntryName}(${ModelEntryName} ${(ModelEntryName)?lower_case}) {
    var dio = new NetworkCommon().dio;
    dio.options.headers.putIfAbsent("Accept", () {
      return "application/json";
    });
    return dio.put("${(ModelEntryName)?lower_case}/", data: ${(ModelEntryName)?lower_case}).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return new ${ModelEntryName}.fromJson(results);
    });
  }

  Future<int> delete${ModelEntryName}(${clsUNNameType} ${clsUNName}) {
    return new NetworkCommon().dio.delete("${(ModelEntryName)?lower_case}/", queryParameters: {"${clsUNName}": ${clsUNName}}).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return 0;
    });
  }

  Future<${ModelEntryName}> get${ModelEntryName}(${clsUNNameType} ${clsUNName}) {
    return new NetworkCommon().dio.get("${(ModelEntryName)?lower_case}/", queryParameters: {"${clsUNName}": ${clsUNName}}).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return new ${ModelEntryName}.fromJson(results);
    });
  }
  
  Future<List<${ModelEntryName}>> search${ModelEntryName}(String query, int page, int perPage) {
    return new NetworkCommon().dio.get("search/${(ModelEntryName)?lower_case}", queryParameters: {
      "query": query,
      "page": page,
      "per_page": perPage
    }).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return  results["results"].map<${ModelEntryName}>((item) => new ${ModelEntryName}.fromJson(item)).toList();
    });
  }

  <#if ModelEntryName == "User">
  Future<${ModelEntryName}> login(Login login) {
    var dio = new NetworkCommon().dio;
    dio.options.headers.putIfAbsent("Accept", () {
      return "application/json";
    });
    return dio.post("login/", data: login.toJson()).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return new ${ModelEntryName}.fromJson(results["user"]);
    });
  }
  </#if>
}
