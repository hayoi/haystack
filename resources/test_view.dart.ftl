import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:${ProjectName}/data/model/user_data.dart';
import 'package:${ProjectName}/features/widget/ensure_visible_when_focused.dart';

class TestView extends StatefulWidget {
  TestView({Key key}) : super(key: key);

  @override
  _TestViewState createState() => new _TestViewState();
}

class _TestViewState extends State<TestView> {
  User _user;
  bool _isLoading = false;
  FocusNode _focusname = new FocusNode();
  TextEditingController _nameC = new TextEditingController();

  int radioValue = 0;

  bool _isChecked = false;

  double _discreteValue = 10.0;

  String _timePicker = " Time picker";

  String _datePicker = "Date picker";

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widget;
    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle =
        theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);

    if (_isLoading) {
      widget = new Center(
          child: new Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: new CircularProgressIndicator()));
    } else {
      widget = ListView(
        padding: EdgeInsets.all(5.0),
        children: <Widget>[
          buttonExample(),
          textField1(),
          TextField(),
          textfield2(),
          checkboxExample(),
          radioExample(),
          sliderExample(),
          FlatButton(
            child: Text(_datePicker),
            onPressed: () async {
              final DateTime picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: new DateTime(2015, 8),
                  lastDate: new DateTime(2101));
              if (picked != null) {
                setState(() {
                  _datePicker = picked.toString();
                });
              }
            },
          ),
          FlatButton(
            child: Text(_timePicker),
            onPressed: () async {
              final TimeOfDay picked = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());
              if (picked != null) {
                setState(() {
                  _timePicker = picked.toString();
                });
              }
            },
          ),
          alertExample(context, dialogTextStyle),
          alertExample2(context, dialogTextStyle),
          sampleDialog(context),
          bottomSheet(context),
          RaisedButton(
            child: Text("Persist bottom sheet"),
            onPressed: () {
              _showBottomSheet();
            },
          ),
          chip(),
          LinearProgressIndicator(),
          SizedBox(
            height: 20.0,
          ),
          SizedBox(height: 100.0, child: const LinearProgressIndicator()),

        ],
      );

//      widget = TheGridView().build();
    }
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("TestView"),
        actions: _buildActionButton(),
      ),
      body: widget,
      floatingActionButton: new FloatingActionButton(
          elevation: 4.0,
          child: new Icon(Icons.add),
          onPressed: () {
            Fluttertoast.showToast(
                msg: "click the floating button",
                toastLength: Toast.LENGTH_SHORT);
          }),
    );
  }

  Chip chip() {
    return Chip(
          avatar: new CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            child: new Text('AB'),
          ),
          label: new Text('Aaron Burr'),
        );
  }

  RaisedButton bottomSheet(BuildContext context) {
    return new RaisedButton(
            child: const Text('SHOW BOTTOM SHEET'),
            onPressed: () {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return new Container(
                        child: new Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: new Text(
                                'This is the modal bottom sheet. Click anywhere to dismiss.',
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 24.0))));
                  });
            });
  }

  RaisedButton sampleDialog(BuildContext context) {
    return new RaisedButton(
            child: const Text('SIMPLE'),
            onPressed: () {
              showDemoDialog<String>(
                  context: context,
                  child: new SimpleDialog(
                      title: const Text('Set backup account'),
                      children: <Widget>[
                        SimpleDialogOption(
                          child: Text("hello, guy"),
                          onPressed: () {
                            Navigator.pop(context, 'hello11');
                          },
                        ),
                        SimpleDialogOption(
                          child: Text("hello, guy"),
                          onPressed: () {
                            Navigator.pop(context, 'hello22');
                          },
                        ),
                        SimpleDialogOption(
                          child: Text("hello, guy"),
                          onPressed: () {
                            Navigator.pop(context, 'hello33');
                          },
                        ),
                        SimpleDialogOption(
                          child: Text("hello, guy"),
                          onPressed: () {
                            Navigator.pop(context, 'hello44');
                          },
                        ),
                      ]));
            });
  }

  RaisedButton alertExample2(BuildContext context, TextStyle dialogTextStyle) {
    return new RaisedButton(
            child: const Text('ALERT WITH TITLE'),
            onPressed: () {
              showDemoDialog<DialogDemoAction>(
                  context: context,
                  child: new AlertDialog(
                      title: const Text('Use Google\'s location service?'),
                      content: new Text(_alertWithTitleText,
                          style: dialogTextStyle),
                      actions: <Widget>[
                        new FlatButton(
                            child: const Text('DISAGREE'),
                            onPressed: () {
                              Navigator.pop(
                                  context, DialogDemoAction.disagree);
                            }),
                        new FlatButton(
                            child: const Text('AGREE'),
                            onPressed: () {
                              Navigator.pop(context, DialogDemoAction.agree);
                            })
                      ]));
            });
  }

  RaisedButton alertExample(BuildContext context, TextStyle dialogTextStyle) {
    return new RaisedButton(
            child: const Text('ALERT'),
            onPressed: () {
              showDemoDialog<DialogDemoAction>(
                  context: context,
                  child: new AlertDialog(
                      content: new Text(_alertWithoutTitleText,
                          style: dialogTextStyle),
                      actions: <Widget>[
                        new FlatButton(
                            child: const Text('CANCEL'),
                            onPressed: () {
                              Navigator.pop(context, DialogDemoAction.cancel);
                            }),
                        new FlatButton(
                            child: const Text('DISCARD'),
                            onPressed: () {
                              Navigator.pop(
                                  context, DialogDemoAction.discard);
                            })
                      ]));
            });
  }

  Slider sliderExample() {
    return new Slider(
            value: _discreteValue,
            min: 0.0,
            max: 200.0,
            divisions: 5,
            label: '${_discreteValue.round()}',
            onChanged: (double value) {
              setState(() {
                _discreteValue = value;
              });
            });
  }

  Row radioExample() {
    return Row(
          children: <Widget>[
            new Radio<int>(
                value: 0,
                groupValue: radioValue,
                onChanged: handleRadioValueChanged),
            Text("CCC"),
            new Radio<int>(
                value: 1,
                groupValue: radioValue,
                onChanged: handleRadioValueChanged),
            Text("DDD"),
            new Radio<int>(
                value: 2,
                groupValue: radioValue,
                onChanged: handleRadioValueChanged),
            Text("EEE"),
          ],
        );
  }

  EnsureVisibleWhenFocused textfield2() {
    return EnsureVisibleWhenFocused(
            focusNode: _focusname,
            child: new TextField(
              maxLines: 1,
              controller: _nameC,
              style: new TextStyle(fontSize: 15.0, color: Colors.black),
              focusNode: _focusname,
              decoration: new InputDecoration(
                  labelText: "hintText",
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  labelStyle: TextStyle(fontWeight: FontWeight.w700)),
            ));
  }

  Row checkboxExample() {
    return Row(
          children: <Widget>[
            Checkbox(
                value: _isChecked,
                onChanged: (flag) {
                  setState(() {
                    _isChecked = flag;
                  });
                }),
            Text("AAA"),
            Checkbox(
              value: _isChecked,
              onChanged: (flag) {},
            ),
            Text("BBB")
          ],
        );
  }

  TextField textField1() {
    return TextField(
          maxLines: 1,
          style: new TextStyle(fontSize: 15.0, color: Colors.black),
          decoration: new InputDecoration(
              hintText: "hintText",
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0)),
              labelStyle: TextStyle(fontWeight: FontWeight.w700)),
        );
  }

  Row buttonExample() {
    return Row(
          children: <Widget>[
            RaisedButton(
              child: Text("I'm a Button"),
              onPressed: () {
                Fluttertoast.showToast(
                    msg: "click the raise button",
                    toastLength: Toast.LENGTH_SHORT);
              },
            ),
            FlatButton(
              child: Text("I'm a flat button"),
              onPressed: () {
                Fluttertoast.showToast(
                    msg: "click the flat button",
                    toastLength: Toast.LENGTH_SHORT);
              },
            ),
            IconButton(
              icon: Icon(Icons.add_comment),
              onPressed: () {
                Fluttertoast.showToast(
                    msg: "click the Icon button",
                    toastLength: Toast.LENGTH_SHORT);
              },
            )
          ],
        );
  }

  void _showBottomSheet() {
    _scaffoldKey.currentState
        .showBottomSheet<void>((BuildContext context) {
          final ThemeData themeData = Theme.of(context);
          return new Container(
              decoration: new BoxDecoration(
                  border: new Border(
                      top: new BorderSide(color: themeData.disabledColor))),
              child: new Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: new Text(
                      'This is a Material persistent bottom sheet. Drag downwards to dismiss it.',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: themeData.accentColor, fontSize: 24.0))));
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              // re-enable the button
            });
          }
        });
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
        Fluttertoast.showToast(
            msg: value.toString(), toastLength: Toast.LENGTH_SHORT);
      }
    });
  }

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
    });
  }

  List<Widget> _buildActionButton() {
    return <Widget>[
      // action button
      IconButton(
        icon: Icon(choices[0].icon),
        onPressed: () {
          _select(choices[0]);
        },
      ),
      // action button
      IconButton(
        icon: Icon(choices[1].icon),
        onPressed: () {
          _select(choices[1]);
        },
      ),
      // overflow menu
      PopupMenuButton<Choice>(
        onSelected: _select,
        itemBuilder: (BuildContext context) {
          return choices.skip(2).map((Choice choice) {
            return PopupMenuItem<Choice>(
              value: choice,
              child: Row(
                children: <Widget>[new Icon(choice.icon), Text(choice.title)],
              ),
            );
          }).toList();
        },
      ),
    ];
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {});
  }

}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Save', icon: Icons.save),
  const Choice(title: 'Search', icon: Icons.search),
  const Choice(title: 'Add', icon: Icons.add),
  const Choice(title: 'Message', icon: Icons.message),
];

enum DialogDemoAction {
  cancel,
  discard,
  disagree,
  agree,
}

const String _alertWithoutTitleText = 'Discard draft?';

const String _alertWithTitleText =
    'Let Google help apps determine location. This means sending anonymous location '
    'data to Google, even when no apps are running.';

class TheGridView {
  Card makeGridCell(String name, IconData icon) {
    return Card(
      elevation: 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Center(child: Icon(icon)),
          Center(child: Text(name)),
        ],
      ),
    );
  }

  GridView build() {
    return GridView.count(
        primary: true,
        padding: EdgeInsets.all(1.0),
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
        children: <Widget>[
          makeGridCell("Home", Icons.home),
          makeGridCell("Email", Icons.email),
          makeGridCell("Chat", Icons.chat_bubble),
          makeGridCell("News", Icons.new_releases),
          makeGridCell("Network", Icons.network_wifi),
          makeGridCell("Options", Icons.settings),
        ]);
  }
}