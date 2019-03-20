import 'dart:async';

import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:${ProjectName}/data/db/database_client.dart';
import 'package:sqflite/sqflite.dart';

class ${ModelEntryName}RepositoryDB {
  const ${ModelEntryName}RepositoryDB();

  Future<List<${ModelEntryName}>> get${ModelEntryName}sList(String sorting, int limit, int skipCount) async {
    Database db = await DatabaseClient().db;
    List<Map> results = await db.query("${(ModelEntryName)?lower_case}", limit: limit, offset: skipCount, orderBy: "${r"${sorting}"} DESC");

    List<${ModelEntryName}> ${(ModelEntryName)?lower_case}s = new List();
    results.forEach((result) {
      ${ModelEntryName} ${(ModelEntryName)?lower_case} = ${ModelEntryName}.fromMap(result);
      ${(ModelEntryName)?lower_case}s.add(${(ModelEntryName)?lower_case});
    });
    return ${(ModelEntryName)?lower_case}s;
  }

  Future<${ModelEntryName}> create${ModelEntryName}(${ModelEntryName} ${(ModelEntryName)?lower_case}) async {
    try {
      var count = 0;
      Database db = await DatabaseClient().db;
      if (${(ModelEntryName)?lower_case}.id != null) {
        count = Sqflite.firstIntValue(await db
            .rawQuery("SELECT COUNT(*) FROM ${(ModelEntryName)?lower_case} WHERE id = ?", [${(ModelEntryName)?lower_case}.id]));
      }
      if (count == 0) {
        ${(ModelEntryName)?lower_case}.id = await db.insert("${(ModelEntryName)?lower_case}", ${(ModelEntryName)?lower_case}.toMap());
      } else {
        await db.update("${(ModelEntryName)?lower_case}", ${(ModelEntryName)?lower_case}.toMap(),
            where: "id = ?", whereArgs: [${(ModelEntryName)?lower_case}.id]);
      }
    } catch (e) {
      print(e.toString());
    }
    return ${(ModelEntryName)?lower_case};
  }

  Future<int> delete${ModelEntryName}(int id) async {
    Database db = await DatabaseClient().db;
    return db.delete("${(ModelEntryName)?lower_case}", where: "id = ?", whereArgs: [id]);
  }

  Future<${ModelEntryName}> get${ModelEntryName}(int id) async {
    Database db = await DatabaseClient().db;
    List<Map> results =
        await db.query("${(ModelEntryName)?lower_case}", where: "id = ?", whereArgs: [id]);
    ${ModelEntryName} ${(ModelEntryName)?lower_case} = ${ModelEntryName}.fromMap(results[0]);
    return ${(ModelEntryName)?lower_case};
  }

  Future<${ModelEntryName}> update${ModelEntryName}(${ModelEntryName} ${(ModelEntryName)?lower_case}) async {
    Database db = await DatabaseClient().db;
    var count = Sqflite.firstIntValue(await db
        .rawQuery("SELECT COUNT(*) FROM ${(ModelEntryName)?lower_case} WHERE id = ?", [${(ModelEntryName)?lower_case}.id]));
    if (count == 0) {
      ${(ModelEntryName)?lower_case}.id = await db.insert("${(ModelEntryName)?lower_case}", ${(ModelEntryName)?lower_case}.toMap());
    } else {
      await db.update("${(ModelEntryName)?lower_case}", ${(ModelEntryName)?lower_case}.toMap(),
          where: "id = ?", whereArgs: [${(ModelEntryName)?lower_case}.id]);
    }
    return ${(ModelEntryName)?lower_case};
  }

}