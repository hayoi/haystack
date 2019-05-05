import 'package:redux/redux.dart';
import 'package:${ProjectName}/redux/action_report.dart';
import 'package:${ProjectName}/redux/app/app_state.dart';
import 'package:${ProjectName}/redux/${(ModelEntryName)?lower_case}/${(ModelEntryName)?lower_case}_actions.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:${ProjectName}/data/remote/${(ModelEntryName)?lower_case}_repository.dart';
<#if genDatabase>
import 'package:${ProjectName}/data/db/${(ModelEntryName)?lower_case}_repository_db.dart';
</#if>
import 'package:${ProjectName}/redux/${(ModelEntryName)?lower_case}/${(ModelEntryName)?lower_case}_actions.dart';
import 'package:${ProjectName}/data/model/page_data.dart';

List<Middleware<AppState>> create${ModelEntryName}Middleware([
  ${ModelEntryName}Repository _repository = const ${ModelEntryName}Repository(),
  <#if genDatabase>
  ${ModelEntryName}RepositoryDB _repositoryDB = const ${ModelEntryName}RepositoryDB(),
  </#if>
]) {
  <#if ModelEntryName=="User">
  final login = _createLogin(_repository<#if genDatabase>, _repositoryDB</#if>);
  </#if>
  final get${ModelEntryName} = _createGet${ModelEntryName}(_repository<#if genDatabase>, _repositoryDB</#if>);
  final get${ModelEntryName}s = _createGet${ModelEntryName}s(_repository<#if genDatabase>, _repositoryDB</#if>);
  final create${ModelEntryName} = _createCreate${ModelEntryName}(_repository<#if genDatabase>, _repositoryDB</#if>);
  final update${ModelEntryName} = _createUpdate${ModelEntryName}(_repository<#if genDatabase>, _repositoryDB</#if>);
  final delete${ModelEntryName} = _createDelete${ModelEntryName}(_repository<#if genDatabase>, _repositoryDB</#if>);

  return [
    <#if ModelEntryName=="User">
    TypedMiddleware<AppState, ${ModelEntryName}LoginAction>(login),
    </#if>
    TypedMiddleware<AppState, Get${ModelEntryName}Action>(get${ModelEntryName}),
    TypedMiddleware<AppState, Get${ModelEntryName}sAction>(get${ModelEntryName}s),
    TypedMiddleware<AppState, Create${ModelEntryName}Action>(create${ModelEntryName}),
    TypedMiddleware<AppState, Update${ModelEntryName}Action>(update${ModelEntryName}),
    TypedMiddleware<AppState, Delete${ModelEntryName}Action>(delete${ModelEntryName}),
  ];
}

<#if ModelEntryName=="User">
Middleware<AppState> _createLogin(
    ${ModelEntryName}Repository repository<#if genDatabase>, ${ModelEntryName}RepositoryDB repositoryDB</#if>) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (checkActionRunning(store, action)) return;
    running(next, action);
    repository.login(action.l).then((item) {
      next(Sync${ModelEntryName}Action(${(ModelEntryName)?lower_case}: item));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}
</#if>

Middleware<AppState> _createGet${ModelEntryName}(
    ${ModelEntryName}Repository repository<#if genDatabase>, ${ModelEntryName}RepositoryDB repositoryDB</#if>) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (checkActionRunning(store, action)) return;
    if (action.${clsUNName} == null) {
      idEmpty(next, action);
    } else {
      running(next, action);
      repository.get${ModelEntryName}(action.${clsUNName}).then((item) {
        next(Sync${ModelEntryName}Action(${(ModelEntryName)?lower_case}: item));
        completed(next, action);
      }).catchError((error) {
        catchError(next, action, error);
      });
    }
  };
}

Middleware<AppState> _createGet${ModelEntryName}s(
    ${ModelEntryName}Repository repository<#if genDatabase>, ${ModelEntryName}RepositoryDB repositoryDB</#if>) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (checkActionRunning(store, action)) return;
    running(next, action);
    if (action.isRefresh) {
      store.state.${(ModelEntryName)?lower_case}State.page.currPage = 1;
      store.state.${(ModelEntryName)?lower_case}State.${(ModelEntryName)?lower_case}s.clear();
    } else {
      var p = ++store.state.${(ModelEntryName)?lower_case}State.page.currPage;
      if (p > ++store.state.${(ModelEntryName)?lower_case}State.page.totalPage) {
        noMoreItem(next, action);
        return;
      }
    }
    repository
        .get${ModelEntryName}sList(
            "sorting",
            store.state.${(ModelEntryName)?lower_case}State.page.currPage,
            store.state.${(ModelEntryName)?lower_case}State.page.pageSize)
        .then((map) {
      if (map.isNotEmpty) {
        var page = Page(
            currPage: map["currPage"],
            totalPage: map["totalPage"],
            totalCount: map["totalCount"]);
        var l = map["list"] ?? List();
        List<${ModelEntryName}> list =
            l.map<${ModelEntryName}>((item) => new ${ModelEntryName}.fromJson(item)).toList();
        next(Sync${ModelEntryName}sAction(page: page, ${(ModelEntryName)?lower_case}s: list));
      }
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
//    repositoryDB
//        .get${ModelEntryName}sList(
//            "id",
//            store.state.${(ModelEntryName)?lower_case}State.page.pageSize,
//            store.state.${(ModelEntryName)?lower_case}State.page.pageSize *
//                store.state.${(ModelEntryName)?lower_case}State.page.currPage)
//        .then((map) {
//      if (map.isNotEmpty) {
//        var page = Page(currPage: store.state.${(ModelEntryName)?lower_case}State.page.currPage + 1);
//        next(Sync${ModelEntryName}sAction(page: page, ${(ModelEntryName)?lower_case}s: map));
//        completed(next, action);
//      }
//    }).catchError((error) {
//      catchError(next, action, error);
//    });
  };
}

Middleware<AppState> _createCreate${ModelEntryName}(
    ${ModelEntryName}Repository repository<#if genDatabase>, ${ModelEntryName}RepositoryDB repositoryDB</#if>) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (checkActionRunning(store, action)) return;
    running(next, action);
    repository.create${ModelEntryName}(action.${(ModelEntryName)?lower_case}).then((item) {
      next(Sync${ModelEntryName}Action(${(ModelEntryName)?lower_case}: item));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _createUpdate${ModelEntryName}(
    ${ModelEntryName}Repository repository<#if genDatabase>, ${ModelEntryName}RepositoryDB repositoryDB</#if>) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (checkActionRunning(store, action)) return;
    running(next, action);
    repository.update${ModelEntryName}(action.${(ModelEntryName)?lower_case}).then((item) {
      next(Sync${ModelEntryName}Action(${(ModelEntryName)?lower_case}: item));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _createDelete${ModelEntryName}(
    ${ModelEntryName}Repository repository<#if genDatabase>, ${ModelEntryName}RepositoryDB repositoryDB</#if>) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (checkActionRunning(store, action)) return;
    running(next, action);
    repository.delete${ModelEntryName}(action.${(ModelEntryName)?lower_case}.${clsUNName}).then((item) {
      next(Remove${ModelEntryName}Action(${clsUNName}: action.${(ModelEntryName)?lower_case}.${clsUNName}));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

bool checkActionRunning(Store<AppState> store, action) {
  if (store.state.photoState.status[action.actionName]?.status ==
      ActionStatus.running) {
    return true; // do nothing if there is a same action running.
  }
  return false;
}

void catchError(NextDispatcher next, action, error) {
  next(${ModelEntryName}StatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: "${r"${action.actionName}"} is error;${r"${error.toString()}"}")));
}

void completed(NextDispatcher next, action) {
  next(${ModelEntryName}StatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.complete,
          msg: "${r"${action.actionName}"} is completed")));
}

void noMoreItem(NextDispatcher next, action) {
  next(${ModelEntryName}StatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.complete,
          msg: "no more items")));
}

void running(NextDispatcher next, action) {
  next(${ModelEntryName}StatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.running,
          msg: "${r"${action.actionName}"} is running")));
}

void idEmpty(NextDispatcher next, action) {
  next(${ModelEntryName}StatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: "Id is empty")));
}
