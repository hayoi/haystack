import 'dart:async';
import 'package:dio/dio.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:${ProjectName}/injection/dependency_injection.dart';
import 'package:${ProjectName}/utils/network_utils.dart';

class ${ModelEntryName}Repository {
  const ${ModelEntryName}Repository();

  Future<Map> get${ModelEntryName}sList(String sorting, int page, int limit) {
    return new Injector().dio.get("${(ModelEntryName)?lower_case}/", data: {
      "sorting": sorting,
      "page": page,
      "limit": limit
    }).then((d) {
      var results = new NetworkUtils().decodeResp(d);

      return results
          .map<${ModelEntryName}>((${(ModelEntryName)?lower_case}) => new ${ModelEntryName}.fromJson(${(ModelEntryName)?lower_case}))
          .toList();
    });
  }

  Future<${ModelEntryName}> create${ModelEntryName}(${ModelEntryName} ${(ModelEntryName)?lower_case}) {
    var dio = new Injector().dio;
    Options options = dio.options;
    options.data = ${(ModelEntryName)?lower_case};
    return dio.post("${(ModelEntryName)?lower_case}/", options: options).then((d) {
      var results = new NetworkUtils().decodeResp(d);

      return new ${ModelEntryName}.fromJson(results);
    });
  }

  Future<${ModelEntryName}> update${ModelEntryName}(${ModelEntryName} ${(ModelEntryName)?lower_case}) {
    var dio = new Injector().dio;
    Options options = dio.options;
    options.data = ${(ModelEntryName)?lower_case};
    return dio.put("${(ModelEntryName)?lower_case}/", options: options).then((d) {
      var results = new NetworkUtils().decodeResp(d);

      return new ${ModelEntryName}.fromJson(results);
    });
  }

  Future<int> delete${ModelEntryName}(int id) {
    return new Injector().dio.delete("${(ModelEntryName)?lower_case}/", data: {"id": id}).then((d) {
      var results = new NetworkUtils().decodeResp(d);

      return id;
    });
  }

  Future<${ModelEntryName}> get${ModelEntryName}(int id) {
    return new Injector().dio.get("${(ModelEntryName)?lower_case}/", data: {"id": id}).then((d) {
      var results = new NetworkUtils().decodeResp(d);

      return new ${ModelEntryName}.fromJson(results);
    });
  }

  <#if ModelEntryName == "User">
  Future<${ModelEntryName}> login(Login login) {
    var dio = new Injector().dio;
    Options options = dio.options;
    options.data = login.toJson();
    return dio.post("login/", options: options).then((d) {
      var results = new NetworkUtils().decodeResp(d);

      return new ${ModelEntryName}.fromJson(results["user"]);
    });
  }
  </#if>
}
