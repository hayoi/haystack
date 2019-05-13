import 'dart:async';

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

enum ActionStatus { running, complete, complete_no_more, error }

class Action {
  final String actionName;
  final Completer<ActionReport> completer;

  Action(this.completer, this.actionName);
}

void catchError(action, error) {
  if (action.completer != null) {
    action.completer.complete(ActionReport(
        actionName: action.actionName,
        status: ActionStatus.error,
        msg: "${r"${action.actionName}"} is error;${r"${error.toString()}"}"));
  }
}

void completed(action) {
  if (action.completer != null) {
    action.completer.complete(ActionReport(
        actionName: action.actionName,
        status: ActionStatus.complete,
        msg: "${r"${action.actionName}"} is completed"));
  }
}

void noMoreItem(action) {
  if (action.completer != null) {
    action.completer.complete(ActionReport(
        actionName: action.actionName,
        status: ActionStatus.complete,
        msg: "no more items"));
  }
}

void running(action) {
  if (action.completer != null) {
    action.completer.complete(ActionReport(
        actionName: action.actionName,
        status: ActionStatus.running,
        msg: "${r"${action.actionName}"} is running"));
  }
}

void idEmpty(action) {
  if (action.completer != null) {
    action.completer.complete(ActionReport(
        actionName: action.actionName,
        status: ActionStatus.error,
        msg: "Id is empty"));
  }
}
