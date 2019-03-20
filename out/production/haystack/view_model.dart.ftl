import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:${ProjectName}/redux/app/app_state.dart';
import 'package:${ProjectName}/redux/${(ModelEntryName)?lower_case}/${(ModelEntryName)?lower_case}_actions.dart';
import 'package:${ProjectName}/redux/loading_status.dart';
import 'package:${ProjectName}/utils/toast_utils.dart';

class ${PageName}ViewModel {
  final LoadingStatus status;
  final List<${ModelEntryName}> ${(ModelEntryName)?lower_case}s;
  final dynamic error;
  <#if PageType == "LOGIN">
  final Function(BuildContext, Login) login;
  </#if>
  final Function(bool) get${ModelEntryName}s;
  final Function(int) get${ModelEntryName};
  final Function(BuildContext, ${ModelEntryName}) create${ModelEntryName};
  final Function(BuildContext, ${ModelEntryName}) update${ModelEntryName};
  final Function(${ModelEntryName}) delete${ModelEntryName};

  ${PageName}ViewModel({
    this.status,
    this.${(ModelEntryName)?lower_case}s,
    this.error,
    <#if PageType == "LOGIN">
    this.login,
    </#if>
    this.get${ModelEntryName}s,
    this.get${ModelEntryName},
    this.create${ModelEntryName},
    this.update${ModelEntryName},
    this.delete${ModelEntryName},
  });

  static ${PageName}ViewModel fromStore(Store<AppState> store) {
    _handleCreateOrUpdateCompleted(BuildContext context) {
      Navigator.of(context).pop();
    }

    <#if PageType == "LOGIN">
    _handleLoginCompleted(BuildContext context) {
      Navigator.of(context).pop();
    }
    </#if>

    return ${PageName}ViewModel(
      status: store.state.${(ModelEntryName)?lower_case}State.loadingStatus,
      ${(ModelEntryName)?lower_case}s: store.state.${(ModelEntryName)?lower_case}State.${(ModelEntryName)?lower_case}s.values.toList() ?? [],
      error: store.state.${(ModelEntryName)?lower_case}State.error,
      <#if PageType == "LOGIN">
      login: (context, l) {
        final Completer<Null> completer = Completer<Null>();
        store.dispatch(UserLoginAction(l: l, completer: completer));
        completer.future.then((_) {
          _handleLoginCompleted(context);
          showToast("Login successful");
        }).catchError((error) => showToast(error));
      },
      </#if>
      get${ModelEntryName}s: (isRefresh) {
        store.dispatch(Get${ModelEntryName}sAction(isRefresh: isRefresh));
      },
      get${ModelEntryName}: (${(ModelEntryName)?lower_case}Id) {
        store.dispatch(Get${ModelEntryName}Action(id: ${(ModelEntryName)?lower_case}Id));
      },
      create${ModelEntryName}: (context, ${(ModelEntryName)?lower_case}) {
        final Completer<Null> completer = Completer<Null>();
        store.dispatch(
            Create${ModelEntryName}Action(${(ModelEntryName)?lower_case}: ${(ModelEntryName)?lower_case}, completer: completer));
        completer.future.then((_) {
          _handleCreateOrUpdateCompleted(context);
          showToast("Create successful");
        }).catchError((error) => showToast(error));
      },
      update${ModelEntryName}: (context, ${(ModelEntryName)?lower_case}) {
        final Completer<Null> completer = Completer<Null>();
        store.dispatch(
            Update${ModelEntryName}Action(${(ModelEntryName)?lower_case}: ${(ModelEntryName)?lower_case}, completer: completer));
        completer.future.then((_) {
          _handleCreateOrUpdateCompleted(context);
          showToast("Update successful");
        }).catchError((error) => showToast(error));
      },
      delete${ModelEntryName}: (${(ModelEntryName)?lower_case}) {
        final Completer<Null> completer = Completer<Null>();
        store.dispatch(Delete${ModelEntryName}Action(${(ModelEntryName)?lower_case}: ${(ModelEntryName)?lower_case}, completer: completer));
        completer.future
            .then((_) => showToast("Delete successful"))
            .catchError((error) => showToast(error));
      },
    );
  }
}
