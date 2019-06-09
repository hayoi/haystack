import 'dart:async';
import 'package:redux/redux.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:${ProjectName}/redux/action_report.dart';
import 'package:${ProjectName}/redux/app/app_state.dart';
import 'package:${ProjectName}/features/action_callback.dart';
import 'package:${ProjectName}/redux/${(ModelEntryName)?lower_case}/${(ModelEntryName)?lower_case}_actions.dart';

class ${PageName}<#if GenSliverTabView>Tab</#if>ViewModel {
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};
  <#if viewModelQuery || GenerateListView || GenSliverGrid || GenSliverFixedExtentList || GenSliverTabView>
  final List<${ModelEntryName}> ${(ModelEntryName)?lower_case}s;
  final Function(bool, ActionCallback) get${ModelEntryName}s;
  </#if>
  <#if viewModelGet>
  final Function(${clsUNNameType!}, ActionCallback) get${ModelEntryName};
  </#if>
  <#if viewModelCreate>
  final Function(${ModelEntryName}, ActionCallback) create${ModelEntryName};
  </#if>
  <#if viewModelUpdate>
  final Function(${ModelEntryName}, ActionCallback) update${ModelEntryName};
  </#if>
  <#if viewModelDelete>
  final Function(${ModelEntryName}, ActionCallback) delete${ModelEntryName};
  </#if>
  <#if PageType == "LOGIN">
  final Function(Login, ActionCallback) login;
  </#if>

  ${PageName}<#if GenSliverTabView>Tab</#if>ViewModel({
    this.${(ModelEntryName)?lower_case},
    <#if viewModelQuery || GenerateListView || GenSliverGrid || GenSliverFixedExtentList || GenSliverTabView>
    this.${(ModelEntryName)?lower_case}s,
    this.get${ModelEntryName}s,
    </#if>
    <#if viewModelGet>
    this.get${ModelEntryName},
    </#if>
    <#if viewModelCreate>
    this.create${ModelEntryName},
    </#if>
    <#if viewModelUpdate>
    this.update${ModelEntryName},
    </#if>
    <#if viewModelDelete>
    this.delete${ModelEntryName},
    </#if>
    <#if PageType == "LOGIN">
    this.login,
    </#if>
  });

  static ${PageName}<#if GenSliverTabView>Tab</#if>ViewModel fromStore(Store<AppState> store) {
    return ${PageName}<#if GenSliverTabView>Tab</#if>ViewModel(
      ${(ModelEntryName)?lower_case}: store.state.${(ModelEntryName)?lower_case}State.${(ModelEntryName)?lower_case},
      <#if viewModelQuery || GenerateListView || GenSliverGrid || GenSliverFixedExtentList || GenSliverTabView>
      ${(ModelEntryName)?lower_case}s: store.state.${(ModelEntryName)?lower_case}State.${(ModelEntryName)?lower_case}s.values.toList() ?? [],
      get${ModelEntryName}s: (isRefresh, callback) {
        final Completer<ActionReport> completer = Completer<ActionReport>();
        store.dispatch(Get${ModelEntryName}sAction(isRefresh: isRefresh, completer: completer));
        completer.future.then((status) {
          callback(status);
        }).catchError((error) => callback(error));
      },
      </#if>
      <#if viewModelGet>
      get${ModelEntryName}: (<#if clsUNNameType??>${clsUNName!}, callback<#else>callback</#if>) {
        final Completer<ActionReport> completer = Completer<ActionReport>();
        store.dispatch(Get${ModelEntryName}Action(<#if clsUNNameType??>${clsUNName!}: ${clsUNName!}, completer: completer<#else>completer: completer</#if>));
        completer.future.then((status) {
          callback(status);
        }).catchError((error) => callback(error));
      },
      </#if>
      <#if viewModelCreate>
      create${ModelEntryName}: (${(ModelEntryName)?lower_case}, callback) {
        final Completer<ActionReport> completer = Completer<ActionReport>();
        store.dispatch(Create${ModelEntryName}Action(${(ModelEntryName)?lower_case}: ${(ModelEntryName)?lower_case}, completer: completer));
        completer.future.then((status) {
          callback(status);
        }).catchError((error) => callback(error));
      },
      </#if>
      <#if viewModelUpdate>
      update${ModelEntryName}: (${(ModelEntryName)?lower_case}, callback) {
        final Completer<ActionReport> completer = Completer<ActionReport>();
        store.dispatch(Update${ModelEntryName}Action(${(ModelEntryName)?lower_case}: ${(ModelEntryName)?lower_case}, completer: completer));
        completer.future.then((status) {
          callback(status);
        }).catchError((error) => callback(error));
      },
      </#if>
      <#if viewModelDelete>
      delete${ModelEntryName}: (${(ModelEntryName)?lower_case}, callback) {
        final Completer<ActionReport> completer = Completer<ActionReport>();
        store.dispatch(Delete${ModelEntryName}Action(${(ModelEntryName)?lower_case}: ${(ModelEntryName)?lower_case}, completer: completer));
        completer.future.then((status) {
          callback(status);
        }).catchError((error) => callback(error));
      },
      </#if>
      <#if PageType == "LOGIN">
      login: (l, callback) {
        final Completer<ActionReport> completer = Completer<ActionReport>();
        store.dispatch(${ModelEntryName}LoginAction(l: l, completer: completer));
        completer.future.then((status) {
          callback(status);
        }).catchError((error) => callback(error));
      },
      </#if>
    );
  }
}
