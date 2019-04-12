import 'package:meta/meta.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:${ProjectName}/redux/action_report.dart';
import 'package:${ProjectName}/data/model/page_data.dart';

class Get${ModelEntryName}sAction {
  final String actionName = "Get${ModelEntryName}sAction";
  final bool isRefresh;

  Get${ModelEntryName}sAction({this.isRefresh});
}

class Get${ModelEntryName}Action {
  final String actionName = "Get${ModelEntryName}Action";
  final int id;

  Get${ModelEntryName}Action({@required this.id});
}

class ${ModelEntryName}StatusAction {
  final String actionName = "${ModelEntryName}StatusAction";
  final ActionReport report;

  ${ModelEntryName}StatusAction({@required this.report});
}

class Sync${ModelEntryName}sAction {
  final String actionName = "Sync${ModelEntryName}sAction";
  final Page page;
  final List<${ModelEntryName}> ${(ModelEntryName)?lower_case}s;

  Sync${ModelEntryName}sAction({this.page, this.${(ModelEntryName)?lower_case}s});
}

class Sync${ModelEntryName}Action {
  final String actionName = "Sync${ModelEntryName}Action";
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};

  Sync${ModelEntryName}Action({@required this.${(ModelEntryName)?lower_case}});
}
<#if ModelEntryName == "User">

class SyncProfileAction {
  final String actionName = "SyncProfileAction";
  final User profile;

  SyncProfileAction({@required this.profile});
}
</#if>

class Create${ModelEntryName}Action {
  final String actionName = "Create${ModelEntryName}Action";
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};

  Create${ModelEntryName}Action({@required this.${(ModelEntryName)?lower_case}});
}

class Update${ModelEntryName}Action {
  final String actionName = "Update${ModelEntryName}Action";
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};

  Update${ModelEntryName}Action({@required this.${(ModelEntryName)?lower_case}});
}

class Delete${ModelEntryName}Action {
  final String actionName = "Delete${ModelEntryName}Action";
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};

  Delete${ModelEntryName}Action({@required this.${(ModelEntryName)?lower_case}});
}

class Remove${ModelEntryName}Action {
  final String actionName = "Remove${ModelEntryName}Action";
  final int id;

  Remove${ModelEntryName}Action({@required this.id});
}

<#if ModelEntryName=="User">
class ${ModelEntryName}LoginAction {
  final String actionName = "${ModelEntryName}LoginAction";
  final Login l;

  ${ModelEntryName}LoginAction({@required this.l});
}
</#if>