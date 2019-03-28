class ActionReport {
  String actionName;
  ActionStatus status;
  String msg;

  ActionReport({
    this.actionName,
    this.status,
    this.msg,
  });

  ActionReport copyWith({
    String actionName,
    ActionStatus status,
    String msg,
  }) {
    return ActionReport(
      actionName: actionName ?? this.actionName,
      status: status ?? this.status,
      msg: msg ?? this.msg,
    );
  }
}

enum ActionStatus { running, complete, error }
