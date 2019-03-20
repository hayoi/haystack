import 'dart:async';

import 'package:meta/meta.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:${ProjectName}/redux/loading_status.dart';
import 'package:${ProjectName}/data/model/page_data.dart';

class Get${ModelEntryName}sAction {
  Get${ModelEntryName}sAction({this.isRefresh});

  final bool isRefresh;
}

class Get${ModelEntryName}Action {
  final int id;

  Get${ModelEntryName}Action({this.id});
}

class ${ModelEntryName}StatusAction {
  ${ModelEntryName}StatusAction({this.status});

  final LoadingStatus status;
}

class Sync${ModelEntryName}sAction {
  Sync${ModelEntryName}sAction({this.page, this.${(ModelEntryName)?lower_case}s});

  final Page page;
  final List<${ModelEntryName}> ${(ModelEntryName)?lower_case}s;
}

class Sync${ModelEntryName}Action {
  Sync${ModelEntryName}Action({this.${(ModelEntryName)?lower_case}});

  final ${ModelEntryName} ${(ModelEntryName)?lower_case};
}

class Create${ModelEntryName}Action {
  Create${ModelEntryName}Action({this.${(ModelEntryName)?lower_case}, this.completer});

  final Completer completer;
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};
}

class Update${ModelEntryName}Action {
  Update${ModelEntryName}Action({this.${(ModelEntryName)?lower_case}, this.completer});

  final Completer completer;
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};
}

class Delete${ModelEntryName}Action {
  Delete${ModelEntryName}Action({this.${(ModelEntryName)?lower_case}, this.completer});

  final Completer completer;
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};
}

class Remove${ModelEntryName}Action {
  Remove${ModelEntryName}Action({this.id});

  final int id;
}

class ${ModelEntryName}FailAction {
  final String error;

  ${ModelEntryName}FailAction({this.error});
}

<#if ModelEntryName=="User">
class UserLoginAction {
  UserLoginAction({this.l, this.completer});

  final Login l;
  final Completer completer;
}
</#if>