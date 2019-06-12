import 'package:meta/meta.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:${ProjectName}/redux/action_report.dart';
import 'package:${ProjectName}/data/model/page_data.dart';

class Get${ModelEntryName}sAction extends Action {
  final bool isRefresh;

  Get${ModelEntryName}sAction({this.isRefresh, completer})
      : super(completer, "Get${ModelEntryName}sAction");
}

class Get${ModelEntryName}Action extends Action {
  final ${clsUNNameType} ${clsUNName};

  Get${ModelEntryName}Action({@required this.${clsUNName}, completer})
      : super(completer, "Get${ModelEntryName}Action");
}

class Create${ModelEntryName}Action extends Action {
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};

  Create${ModelEntryName}Action({@required this.${(ModelEntryName)?lower_case}, completer})
      : super(completer, "Create${ModelEntryName}Action");
}

class Update${ModelEntryName}Action extends Action {
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};

  Update${ModelEntryName}Action({@required this.${(ModelEntryName)?lower_case}, completer})
      : super(completer, "Update${ModelEntryName}Action");
}

class Delete${ModelEntryName}Action extends Action {
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};

  Delete${ModelEntryName}Action({@required this.${(ModelEntryName)?lower_case}, completer})
      : super(completer, "Delete${ModelEntryName}Action");
}

<#if ModelEntryName=="User">
class ${ModelEntryName}LoginAction extends Action {
  final Login l;

  ${ModelEntryName}LoginAction({@required this.l, completer})
      : super(completer, "${ModelEntryName}LoginAction");
}

class SyncProfileAction extends Action {
  final User profile;

  SyncProfileAction({@required this.profile, completer})
      : super(completer, "SyncProfileAction");
}
</#if>

class Sync${ModelEntryName}sAction extends Action {
  final Page page;
  final List<${ModelEntryName}> ${(ModelEntryName)?lower_case}s;

  Sync${ModelEntryName}sAction({this.page, this.${(ModelEntryName)?lower_case}s, completer})
      : super(completer, "Sync${ModelEntryName}sAction");
}

class Sync${ModelEntryName}Action extends Action {
  final ${ModelEntryName} ${(ModelEntryName)?lower_case};

  Sync${ModelEntryName}Action({@required this.${(ModelEntryName)?lower_case}, completer})
      : super(completer, "Sync${ModelEntryName}Action");
}

class Remove${ModelEntryName}Action extends Action {
  final ${clsUNNameType} ${clsUNName};

  Remove${ModelEntryName}Action({@required this.${clsUNName}, completer})
      : super(null, "Remove${ModelEntryName}Action");
}

class Search${ModelEntryName}Action extends Action {
  final String query;

  Search${ModelEntryName}Action({this.query, completer})
        : super(completer, "Search${ModelEntryName}Action");
}

class SyncSearch${ModelEntryName}Action extends Action {
  final List<${ModelEntryName}> search${ModelEntryName}s;

  SyncSearch${ModelEntryName}Action({this.search${ModelEntryName}s, completer})
        : super(completer, "SyncSearch${ModelEntryName}Action");
}