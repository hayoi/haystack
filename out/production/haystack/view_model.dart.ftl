import 'package:redux/redux.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:${ProjectName}/redux/action_report.dart';
import 'package:${ProjectName}/redux/app/app_state.dart';
import 'package:${ProjectName}/redux/${(ModelEntryName)?lower_case}/${(ModelEntryName)?lower_case}_actions.dart';

class ${PageName}ViewModel {
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};
  <#if viewModelQuery || GenerateListView>
  final List<${ModelEntryName}> ${(ModelEntryName)?lower_case}s;
  final Function(bool) get${ModelEntryName}s;
  final ActionReport get${ModelEntryName}sReport;
  </#if>
  <#if viewModelGet>
  final Function(int) get${ModelEntryName};
  final ActionReport get${ModelEntryName}Report;
  </#if>
  <#if viewModelCreate>
  final Function(${ModelEntryName}) create${ModelEntryName};
  final ActionReport create${ModelEntryName}Report;
  </#if>
  <#if viewModelUpdate>
  final Function(${ModelEntryName}) update${ModelEntryName};
  final ActionReport update${ModelEntryName}Report;
  </#if>
  <#if viewModelDelete>
  final Function(${ModelEntryName}) delete${ModelEntryName};
  final ActionReport delete${ModelEntryName}Report;
  </#if>
  <#if PageType == "LOGIN">
  final Function(Login) login;
  final ActionReport loginReport;
  </#if>

  ${PageName}ViewModel({
    this.${(ModelEntryName)?lower_case},
    <#if viewModelQuery || GenerateListView>
    this.${(ModelEntryName)?lower_case}s,
    this.get${ModelEntryName}s,
    this.get${ModelEntryName}sReport,
    </#if>
    <#if viewModelGet>
    this.get${ModelEntryName},
    this.get${ModelEntryName}Report,
    </#if>
    <#if viewModelCreate>
    this.create${ModelEntryName},
    this.create${ModelEntryName}Report,
    </#if>
    <#if viewModelUpdate>
    this.update${ModelEntryName},
    this.update${ModelEntryName}Report,
    </#if>
    <#if viewModelDelete>
    this.delete${ModelEntryName},
    this.delete${ModelEntryName}Report,
    </#if>
    <#if PageType == "LOGIN">
    this.login,
    this.loginReport,
    </#if>
  });

  static ${PageName}ViewModel fromStore(Store<AppState> store) {
    return ${PageName}ViewModel(
      ${(ModelEntryName)?lower_case}: store.state.${(ModelEntryName)?lower_case}State.${(ModelEntryName)?lower_case},
      <#if viewModelQuery || GenerateListView>
      ${(ModelEntryName)?lower_case}s: store.state.${(ModelEntryName)?lower_case}State.${(ModelEntryName)?lower_case}s.values.toList() ?? [],
      get${ModelEntryName}s: (isRefresh) {
        store.dispatch(Get${ModelEntryName}sAction(isRefresh: isRefresh));
      },
      get${ModelEntryName}sReport: store.state.${(ModelEntryName)?lower_case}State.status["Get${ModelEntryName}sAction"],
      </#if>
      <#if viewModelGet>
      get${ModelEntryName}: (${(ModelEntryName)?lower_case}Id) {
        store.dispatch(Get${ModelEntryName}Action(id: ${(ModelEntryName)?lower_case}Id));
      },
      get${ModelEntryName}Report: store.state.${(ModelEntryName)?lower_case}State.status["Get${ModelEntryName}Action"],
      </#if>
      <#if viewModelCreate>
      create${ModelEntryName}: (${(ModelEntryName)?lower_case}) {
        store.dispatch(Create${ModelEntryName}Action(${(ModelEntryName)?lower_case}: ${(ModelEntryName)?lower_case}));
      },
      create${ModelEntryName}Report: store.state.${(ModelEntryName)?lower_case}State.status["Create${ModelEntryName}Action"],
      </#if>
      <#if viewModelUpdate>
      update${ModelEntryName}: (${(ModelEntryName)?lower_case}) {
        store.dispatch(Update${ModelEntryName}Action(${(ModelEntryName)?lower_case}: ${(ModelEntryName)?lower_case}));
      },
      update${ModelEntryName}Report: store.state.${(ModelEntryName)?lower_case}State.status["Update${ModelEntryName}Action"],
      </#if>
      <#if viewModelDelete>
      delete${ModelEntryName}: (${(ModelEntryName)?lower_case}) {
        store.dispatch(Delete${ModelEntryName}Action(${(ModelEntryName)?lower_case}: ${(ModelEntryName)?lower_case}));
      },
      delete${ModelEntryName}Report: store.state.${(ModelEntryName)?lower_case}State.status["Delete${ModelEntryName}Action"],
      </#if>
      <#if PageType == "LOGIN">
      login: (l) {
        store.dispatch(${ModelEntryName}LoginAction(l: l));
      },
      loginReport: store.state.userState.status["UserLoginAction"],
      </#if>
    );
  }
}
