import 'package:redux/redux.dart';
import 'package:${ProjectName}/redux/loading_status.dart';
import 'package:${ProjectName}/redux/${(ModelEntryName)?lower_case}/${(ModelEntryName)?lower_case}_actions.dart';
import 'package:${ProjectName}/redux/${(ModelEntryName)?lower_case}/${(ModelEntryName)?lower_case}_state.dart';

final ${(ModelEntryName)?lower_case}Reducer = combineReducers<${ModelEntryName}State>([
  TypedReducer<${ModelEntryName}State, ${ModelEntryName}StatusAction>(_${(ModelEntryName)?lower_case}Loading),
  TypedReducer<${ModelEntryName}State, Sync${ModelEntryName}sAction>(_sync${ModelEntryName}s),
  TypedReducer<${ModelEntryName}State, Sync${ModelEntryName}Action>(_sync${ModelEntryName}),
  TypedReducer<${ModelEntryName}State, Remove${ModelEntryName}Action>(_remove${ModelEntryName}),
  TypedReducer<${ModelEntryName}State, ${ModelEntryName}FailAction>(_${(ModelEntryName)?lower_case}Fail),
]);

${ModelEntryName}State _${(ModelEntryName)?lower_case}Loading(${ModelEntryName}State state, ${ModelEntryName}StatusAction action) {
  return state.copyWith(loadingStatus: action.status, error: "");
}

${ModelEntryName}State _sync${ModelEntryName}s(${ModelEntryName}State state, Sync${ModelEntryName}sAction action) {
  for (var ${(ModelEntryName)?lower_case} in action.${(ModelEntryName)?lower_case}s) {
    state.${(ModelEntryName)?lower_case}s.putIfAbsent(${(ModelEntryName)?lower_case}.id.toString(), () => ${(ModelEntryName)?lower_case});
  }
  state.page.currPage = action.page.currPage;
  state.page.pageSize = action.page.pageSize;
  state.page.totalCount = action.page.totalCount;
  state.page.totalPage = action.page.totalPage;
  return state.copyWith(
      ${(ModelEntryName)?lower_case}s: state.${(ModelEntryName)?lower_case}s, loadingStatus: LoadingStatus.success, error: "");
}

${ModelEntryName}State _sync${ModelEntryName}(${ModelEntryName}State state, Sync${ModelEntryName}Action action) {
  state.${(ModelEntryName)?lower_case}s.update(action.${(ModelEntryName)?lower_case}.id.toString(), (u) => action.${(ModelEntryName)?lower_case},
      ifAbsent: () => action.${(ModelEntryName)?lower_case});
  return state.copyWith(
      ${(ModelEntryName)?lower_case}s: state.${(ModelEntryName)?lower_case}s, loadingStatus: LoadingStatus.success, error: "");
}

${ModelEntryName}State _remove${ModelEntryName}(${ModelEntryName}State state, Remove${ModelEntryName}Action action) {
  return state.copyWith(
      ${(ModelEntryName)?lower_case}s: state.${(ModelEntryName)?lower_case}s..remove(action.id.toString()),
      loadingStatus: LoadingStatus.success,
      error: "");
}

${ModelEntryName}State _${(ModelEntryName)?lower_case}Fail(${ModelEntryName}State state, ${ModelEntryName}FailAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.error, error: action.error);
}
