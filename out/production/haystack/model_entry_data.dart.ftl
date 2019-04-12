import 'dart:convert';
import 'package:intl/intl.dart';
<#if genDatabase>
import 'package:sqflite/sqflite.dart';
</#if>

class ${ModelEntryName} {
  <#list Fields as item>
  ${item.type} ${item.name};
  </#list>

  ${ModelEntryName}({
  <#list Fields as item>
    <#if item.defaultValue == "null">
    this.${item.name},
    <#else>
    this.${item.name} = ${item.defaultValue},
    </#if>
  </#list>
  });

  ${ModelEntryName}.fromJson(Map<String, dynamic>  map) :
        <#list Fields as item>
        <#if item.originalValue == "Object">
        ${item.name} = ${item.type}.fromMap(map['${item.jsonName}'])<#if item_has_next>,<#else>;</#if>
        <#elseif item.type == "List<int>">
        ${item.name} = map['${item.jsonName}'] == null
            ? []
            : map['${item.jsonName}'].cast<int>().toList()<#if item_has_next>,<#else>;</#if>
        <#elseif item.type == "List<String>">
        ${item.name} = map['${item.jsonName}'] == null
            ? []
            : map['${item.jsonName}'].cast<String>().toList()<#if item_has_next>,<#else>;</#if>
        <#elseif item.type == "List<bool>">
        ${item.name} = map['${item.jsonName}'] == null
            ? []
            : map['${item.jsonName}'].cast<bool>().toList()<#if item_has_next>,<#else>;</#if>
        <#elseif item.type == "DateTime">
        ${item.name} = map['${item.jsonName}'] == null ? null
               : DateTime.parse(map["${item.jsonName}"])<#if item_has_next>,<#else>;</#if>
        <#elseif item.type == "List">
        ${item.name} = map['${item.jsonName}']
                        .map((obj) => ${item.type?substring(5,item.type?length-1)}.fromMap(obj))
                        .toList()
                        .cast<${item.type?substring(5,item.type?length-1)}>()<#if item_has_next>,<#else>;</#if>
        <#elseif item.type == "int" || item.type == "double" || item.type == "String" || item.type == "bool">
        ${item.name} = map['${item.jsonName}']  ?? ${item.defaultValue}<#if item_has_next>,<#else>;</#if>
        </#if>
        </#list>

  Map<String, dynamic> toJson() => {
        <#list Fields as item>
        <#if item.originalValue == "Object">
        '${item.jsonName}': ${item.name}.toJson(),
        <#elseif item.type == "DateTime">
        '${item.jsonName}': ${item.name} == null? null
               : DateFormat('yyyy-MM-dd HH:mm:ss').format(${item.name}),
        <#else>
        '${item.jsonName}': ${item.name},
        </#if>
        </#list>
      };

  ${ModelEntryName} copyWith({
    <#list Fields as item>
    ${item.type} ${item.name},
    </#list>
  }) {
    return ${ModelEntryName}(
      <#list Fields as item>
      ${item.name}: ${item.name} ?? this.${item.name},
      </#list>
    );
  }
  <#if genDatabase>

  static Future createTable(Database db) async {
    db.execute("""
            CREATE TABLE IF NOT EXISTS ${(ModelEntryName)?lower_case} (
              <#list Fields as item>
              <#if item.name == "id">
              ${item.jsonName} INTEGER PRIMARY KEY<#if item_has_next>,<#else> </#if>
              <#elseif item.originalValue != "Object">
              ${item.jsonName} <#if item.type == "int">INTEGER<#elseif item.type == "String">TEXT<#elseif item.type == "Float">REAL<#elseif item.type == "bool">INTEGER<#elseif item.type == "DateTime">TEXT</#if><#if item_has_next>,<#else> </#if>
              </#if>
              </#list>
            )""");}

  ${ModelEntryName}.fromMap(Map<String, dynamic>  map) :
        <#list Fields as item>
        <#if (item.type == "int" || item.type == "String")>
        ${item.name} = map['${item.jsonName}']<#if item_has_next>,<#else>;</#if>
        <#elseif item.type?starts_with("List")>
        ${item.name} = json.decode(map['${item.jsonName}'])<#if item_has_next>,<#else>;</#if>
        <#elseif item.type == "DateTime">
        ${item.name} = map['${item.jsonName}'] == null? null
               : DateTime.parse(map["${item.jsonName}"])<#if item_has_next>,<#else>;</#if>
        <#elseif item.type == "bool">
        ${item.name} = (map['${item.jsonName}'] == 1)<#if item_has_next>,<#else>;</#if>
        </#if>
        </#list>

  Map<String, dynamic> toMap() => {
        <#list Fields as item>
        <#if (item.type == "int" || item.type == "String")>
        '${item.jsonName}': ${item.name},
        <#elseif item.type?starts_with("List")>
        '${item.jsonName}': ${item.name}.toString(),
        <#elseif item.type == "DateTime">
        '${item.jsonName}': ${item.name} == null? null
               : DateFormat('yyyy-MM-dd HH:mm:ss').format(${item.name}),
        <#elseif item.type == "bool">
        '${item.jsonName}': (${item.name} == true)?1:0,
        </#if>
        </#list>
      };
  </#if>

}

<#if ModelEntryName == "User">
class Login {
  String name;
  String password;

  Login(this.name, this.password);

  Map<String, dynamic> toJson() => {
        'name': name,
        'password': password,
      };
}
</#if>