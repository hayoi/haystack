import 'package:meta/meta.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:${ProjectName}/data/model/page_data.dart';
import 'package:${ProjectName}/redux/action_report.dart';

class ${ModelEntryName}State {
  final Map<String, ${ModelEntryName}> ${(ModelEntryName)?lower_case}s;
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};
  final Map<String, ActionReport> status;
  final Page page;

  ${ModelEntryName}State({
    @required this.${(ModelEntryName)?lower_case}s,
    @required this.${(ModelEntryName)?lower_case},
    @required this.status,
    @required this.page,
  });

  ${ModelEntryName}State copyWith({
    Map<String, ${ModelEntryName}> ${(ModelEntryName)?lower_case}s,
    ${ModelEntryName} ${(ModelEntryName)?lower_case},
    Map<String, ActionReport> status,
    Page page,
  }) {
    return ${ModelEntryName}State(
      ${(ModelEntryName)?lower_case}s: ${(ModelEntryName)?lower_case}s ?? this.${(ModelEntryName)?lower_case}s ?? Map(),
      ${(ModelEntryName)?lower_case}: ${(ModelEntryName)?lower_case} ?? this.${(ModelEntryName)?lower_case},
      status: status ?? this.status,
      page: page ?? this.page,
    );
  }
}
