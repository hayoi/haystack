import 'package:${ProjectName}/data/db/${(ModelEntryName)?lower_case}_repository_db.dart';
import 'package:redux/redux.dart';
import 'package:${ProjectName}/redux/app/app_state.dart';
import 'package:${ProjectName}/redux/loading_status.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:${ProjectName}/data/remote/${(ModelEntryName)?lower_case}_repository.dart';
import 'package:${ProjectName}/redux/${(ModelEntryName)?lower_case}/${(ModelEntryName)?lower_case}_actions.dart';
import 'package:${ProjectName}/data/model/page_data.dart';

List<Middleware<AppState>> create${ModelEntryName}Middleware([
  ${ModelEntryName}Repository _repository = const ${ModelEntryName}Repository(),
  ${ModelEntryName}RepositoryDB _repositoryDB = const ${ModelEntryName}RepositoryDB(),
]) {
  <#if ModelEntryName=="User">
  final login = _createLogin(_repository, _repositoryDB);
  </#if>
  final get${ModelEntryName} = _createGet${ModelEntryName}(_repository, _repositoryDB);
  final get${ModelEntryName}s = _createGet${ModelEntryName}s(_repository, _repositoryDB);
  final create${ModelEntryName} = _createCreate${ModelEntryName}(_repository, _repositoryDB);
  final update${ModelEntryName} = _createUpdate${ModelEntryName}(_repository, _repositoryDB);
  final delete${ModelEntryName} = _createDelete${ModelEntryName}(_repository, _repositoryDB);

  return [
    <#if ModelEntryName=="User">
    TypedMiddleware<AppState, UserLoginAction>(login),
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
    UserRepository repository, UserRepositoryDB repositoryDB) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(UserStatusAction(status: LoadingStatus.loading));
    repository.login(action.l).then((item) {
      if (action.completer != null) {
        action.completer.complete();
      }
      next(SyncUserAction(user: item));
    }).catchError((error) {
      if (action.completer != null) {
        action.completer.completeError(error);
      }
      next(UserFailAction(error: error.toString()));
    });
  };
}
</#if>

Middleware<AppState> _createGet${ModelEntryName}(
    ${ModelEntryName}Repository repository, ${ModelEntryName}RepositoryDB repositoryDB) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action.id == null) {
      next(${ModelEntryName}StatusAction(status: LoadingStatus.success));
    } else {
      next(${ModelEntryName}StatusAction(status: LoadingStatus.loading));
      repository.get${ModelEntryName}(action.id).then((item) {
        next(Sync${ModelEntryName}Action(${(ModelEntryName)?lower_case}: item));
        next(${ModelEntryName}StatusAction(status: LoadingStatus.success));
      }).catchError((error) {
        next(${ModelEntryName}FailAction(error: error.toString()));
        next(${ModelEntryName}StatusAction(status: LoadingStatus.init));
      });
    }
  };
}

Middleware<AppState> _createGet${ModelEntryName}s(
    ${ModelEntryName}Repository repository, ${ModelEntryName}RepositoryDB repositoryDB) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(${ModelEntryName}StatusAction(status: LoadingStatus.loading));
    if (action.isRefresh) {
      store.state.${(ModelEntryName)?lower_case}State.page.currPage = 0;
      store.state.${(ModelEntryName)?lower_case}State.${(ModelEntryName)?lower_case}s.clear();
    } else {
      var p = ++store.state.${(ModelEntryName)?lower_case}State.page.currPage;
      if (p > ++store.state.${(ModelEntryName)?lower_case}State.page.totalPage) {
        next(${ModelEntryName}StatusAction(status: LoadingStatus.success));
        return;
      }
    }
    repository
        .get${ModelEntryName}sList(
            "id",
            store.state.${(ModelEntryName)?lower_case}State.page.pageSize,
            store.state.${(ModelEntryName)?lower_case}State.page.pageSize *
                store.state.${(ModelEntryName)?lower_case}State.page.currPage)
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
    }).catchError((error) {
      next(${ModelEntryName}FailAction(error: error.toString()));
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
//      }
//    }).catchError((error) {
//      next(${ModelEntryName}FailAction(error: error.toString()));
//    });
  };
}

Middleware<AppState> _createCreate${ModelEntryName}(
    ${ModelEntryName}Repository repository, ${ModelEntryName}RepositoryDB repositoryDB) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(${ModelEntryName}StatusAction(status: LoadingStatus.loading));
    repository.create${ModelEntryName}(action.${(ModelEntryName)?lower_case}).then((item) {
      if (action.completer != null) {
        action.completer.complete();
      }
      next(Sync${ModelEntryName}Action(${(ModelEntryName)?lower_case}: item));
    }).catchError((error) {
      if (action.completer != null) {
        action.completer.completeError(error);
      }
      next(${ModelEntryName}FailAction(error: error.toString()));
    });
  };
}

Middleware<AppState> _createUpdate${ModelEntryName}(
    ${ModelEntryName}Repository repository, ${ModelEntryName}RepositoryDB repositoryDB) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(${ModelEntryName}StatusAction(status: LoadingStatus.loading));
    repository.update${ModelEntryName}(action.${(ModelEntryName)?lower_case}).then((item) {
      if (action.completer != null) {
        action.completer.complete();
      }
      next(Sync${ModelEntryName}Action(${(ModelEntryName)?lower_case}: item));
    }).catchError((error) {
      if (action.completer != null) {
        action.completer.completeError(error);
      }
      next(${ModelEntryName}FailAction(error: error.toString()));
    });
  };
}

Middleware<AppState> _createDelete${ModelEntryName}(
    ${ModelEntryName}Repository repository, ${ModelEntryName}RepositoryDB repositoryDB) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    next(${ModelEntryName}StatusAction(status: LoadingStatus.loading));
    repository.delete${ModelEntryName}(action.${(ModelEntryName)?lower_case}.id).then((item) {
      if (action.completer != null) {
        action.completer.complete();
      }
      next(Remove${ModelEntryName}Action(id: action.${(ModelEntryName)?lower_case}.id));
    }).catchError((error) {
      if (action.completer != null) {
        action.completer.completeError(error);
      }
      next(${ModelEntryName}FailAction(error: error.toString()));
    });
  };
}
