import 'package:redux/redux.dart';
import 'package:${ProjectName}/redux/${(ModelEntryName)?lower_case}/${(ModelEntryName)?lower_case}_actions.dart';
import 'package:${ProjectName}/redux/${(ModelEntryName)?lower_case}/${(ModelEntryName)?lower_case}_state.dart';

final ${(ModelEntryName)?lower_case}Reducer = combineReducers<${ModelEntryName}State>([
  TypedReducer<${ModelEntryName}State, ${ModelEntryName}StatusAction>(_${(ModelEntryName)?lower_case}Status),
  TypedReducer<${ModelEntryName}State, Sync${ModelEntryName}sAction>(_sync${ModelEntryName}s),
  TypedReducer<${ModelEntryName}State, Sync${ModelEntryName}Action>(_sync${ModelEntryName}),
  <#if ModelEntryName == "User">
  TypedReducer<UserState, SyncProfileAction>(_syncProfile),
  </#if>
  TypedReducer<${ModelEntryName}State, Remove${ModelEntryName}Action>(_remove${ModelEntryName}),
]);

${ModelEntryName}State _${(ModelEntryName)?lower_case}Status(${ModelEntryName}State state, ${ModelEntryName}StatusAction action) {
  var status = state.status ?? Map();
  status.update(action.report.actionName, (v) => action.report,
      ifAbsent: () => action.report);
  return state.copyWith(status: status);
}

${ModelEntryName}State _sync${ModelEntryName}s(${ModelEntryName}State state, Sync${ModelEntryName}sAction action) {
  for (var ${(ModelEntryName)?lower_case} in action.${(ModelEntryName)?lower_case}s) {
    state.${(ModelEntryName)?lower_case}s.update(${(ModelEntryName)?lower_case}.${clsUNName}.toString(), (v) => ${(ModelEntryName)?lower_case}, ifAbsent: () => ${(ModelEntryName)?lower_case});
  }
  state.page.currPage = action.page.currPage;
  state.page.pageSize = action.page.pageSize;
  state.page.totalCount = action.page.totalCount;
  state.page.totalPage = action.page.totalPage;
  return state.copyWith(${(ModelEntryName)?lower_case}s: state.${(ModelEntryName)?lower_case}s);
}

${ModelEntryName}State _sync${ModelEntryName}(${ModelEntryName}State state, Sync${ModelEntryName}Action action) {
  state.${(ModelEntryName)?lower_case}s.update(action.${(ModelEntryName)?lower_case}.${clsUNName}.toString(), (u) => action.${(ModelEntryName)?lower_case},
      ifAbsent: () => action.${(ModelEntryName)?lower_case});
  return state.copyWith(${(ModelEntryName)?lower_case}s: state.${(ModelEntryName)?lower_case}s, ${(ModelEntryName)?lower_case}: action.${(ModelEntryName)?lower_case});
}
<#if ModelEntryName == "User">

${ModelEntryName}State _syncProfile(${ModelEntryName}State state, SyncProfileAction action) {
  return state.copyWith(profile: action.profile);
}
</#if>

${ModelEntryName}State _remove${ModelEntryName}(${ModelEntryName}State state, Remove${ModelEntryName}Action action) {
  return state.copyWith(${(ModelEntryName)?lower_case}s: state.${(ModelEntryName)?lower_case}s..remove(action.${clsUNName}.toString()));
}
