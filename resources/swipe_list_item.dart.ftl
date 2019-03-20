import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SwipeListItem<T> extends StatelessWidget {
  const SwipeListItem(
      {Key key,
      @required this.item,
      @required this.child,
      @required this.onArchive,
      @required this.onDelete})
      : super(key: key);

  final T item;
  final void Function(T) onArchive;
  final void Function(T) onDelete;
  final Widget child;

  void _handleArchive() {
    onArchive(item);
  }

  void _handleDelete() {
    onDelete(item);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Slidable(
      delegate: SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: this.child,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: _handleDelete,
        ),
      ],
    );
  }
}