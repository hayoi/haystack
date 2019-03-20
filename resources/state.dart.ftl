import 'package:meta/meta.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:${ProjectName}/redux/loading_status.dart';
import 'package:${ProjectName}/data/model/page_data.dart';

class ${ModelEntryName}State {
  final Map<String, ${ModelEntryName}> ${(ModelEntryName)?lower_case}s;
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};
  final LoadingStatus loadingStatus;
  final dynamic error;
  final Page page;

  ${ModelEntryName}State({
    @required this.${(ModelEntryName)?lower_case}s,
    @required this.${(ModelEntryName)?lower_case},
    @required this.loadingStatus,
    @required this.error,
    @required this.page,
  });

  ${ModelEntryName}State copyWith({
    Map<String, ${ModelEntryName}> ${(ModelEntryName)?lower_case}s,
    ${ModelEntryName} ${(ModelEntryName)?lower_case},
    LoadingStatus loadingStatus,
    dynamic error,
    Page page,
  }) {
    return ${ModelEntryName}State(
      ${(ModelEntryName)?lower_case}s: ${(ModelEntryName)?lower_case}s ?? this.${(ModelEntryName)?lower_case}s ?? Map(),
      ${(ModelEntryName)?lower_case}: ${(ModelEntryName)?lower_case} ?? this.${(ModelEntryName)?lower_case},
      loadingStatus: loadingStatus ?? this.loadingStatus,
      error: error ?? this.error,
      page: page ?? this.page,
    );
  }
}
