import 'package:meta/meta.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:${ProjectName}/data/model/page_data.dart';
import 'package:${ProjectName}/redux/action_report.dart';

class ${ModelEntryName}State {
  <#if ModelEntryName == "User">
  final User profile;
  </#if>
  final List<${ModelEntryName}> search${ModelEntryName}s;
  final Map<String, ${ModelEntryName}> ${(ModelEntryName)?lower_case}s;
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};
  final Page page;

  ${ModelEntryName}State({
    <#if ModelEntryName == "User">
    @required this.profile,
    </#if>
    @required this.search${ModelEntryName}s,
    @required this.${(ModelEntryName)?lower_case}s,
    @required this.${(ModelEntryName)?lower_case},
    @required this.page,
  });

  ${ModelEntryName}State copyWith({
    <#if ModelEntryName == "User">
    User profile,
    </#if>
    List<${ModelEntryName}> search${ModelEntryName}s,
    Map<String, ${ModelEntryName}> ${(ModelEntryName)?lower_case}s,
    ${ModelEntryName} ${(ModelEntryName)?lower_case},
    Page page,
  }) {
    return ${ModelEntryName}State(
      <#if ModelEntryName == "User">
      profile: profile ?? this.profile,
      </#if>
      search${ModelEntryName}s: search${ModelEntryName}s ?? this.search${ModelEntryName}s,
      ${(ModelEntryName)?lower_case}s: ${(ModelEntryName)?lower_case}s ?? this.${(ModelEntryName)?lower_case}s ?? Map(),
      ${(ModelEntryName)?lower_case}: ${(ModelEntryName)?lower_case} ?? this.${(ModelEntryName)?lower_case},
      page: page ?? this.page,
    );
  }
}
