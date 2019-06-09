import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
<#if GenerateActionButton>
import 'package:${ProjectName}/data/model/choice_data.dart';
</#if>
import 'package:shared_preferences/shared_preferences.dart';
import 'package:${ProjectName}/trans/translations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:${ProjectName}/redux/app/app_state.dart';
import 'package:${ProjectName}/features/<#if IsCustomWidget>customize/</#if>${(PageName)?lower_case}/${(PageName)?lower_case}<#if GenSliverTabView>_tab</#if>_view_model.dart';
import 'package:${ProjectName}/redux/action_report.dart';
import 'package:${ProjectName}/utils/progress_dialog.dart';
<#if viewModelDelete>
import 'package:${ProjectName}/features/widget/swipe_list_item.dart';
</#if>
<#if GenSliverGrid>
import 'package:${ProjectName}/features/widget/spannable_grid.dart';
</#if>

class ${PageName}<#if GenSliverTabView>Tab</#if>View extends StatelessWidget {
  ${PageName}<#if GenSliverTabView>Tab</#if>View({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ${PageName}<#if GenSliverTabView>Tab</#if>ViewModel>(
      distinct: true,
      converter: (store) => ${PageName}<#if GenSliverTabView>Tab</#if>ViewModel.fromStore(store),
      builder: (_, viewModel) => ${PageName}<#if GenSliverTabView>Tab</#if>ViewContent(
            viewModel: viewModel,
          ),
    );
  }
}

class ${PageName}<#if GenSliverTabView>Tab</#if>ViewContent extends StatefulWidget {
  final ${PageName}<#if GenSliverTabView>Tab</#if>ViewModel viewModel;

  ${PageName}<#if GenSliverTabView>Tab</#if>ViewContent({Key key, this.viewModel}) : super(key: key);

  @override
  _${PageName}<#if GenSliverTabView>Tab</#if>ViewContentState createState() => _${PageName}<#if GenSliverTabView>Tab</#if>ViewContentState();
}

<#if GenSliverToBoxAdapter || GenSliverGrid || GenSliverFixedExtentList>
const double _fabHalfSize = 28.0;

</#if>
class _${PageName}<#if GenSliverTabView>Tab</#if>ViewContentState extends State<${PageName}<#if GenSliverTabView>Tab</#if>ViewContent> {
  <#if HasActionSearch>
  final _SearchDemoSearchDelegate _delegate = _SearchDemoSearchDelegate();
  </#if>
  <#if GenerateListView || GenSliverToBoxAdapter || GenSliverGrid || GenSliverFixedExtentList || GenSliverTabView>
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final TrackingScrollController _scrollController = TrackingScrollController();
  </#if>
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  <#if GenerateBottomTabBar>
  PageController pageController;
  int page = 0;
  List pages = ["Home","Notice","Mine"];
  </#if>
  <#if GenSliverToBoxAdapter || GenSliverGrid || GenSliverFixedExtentList || GenSliverTabBar>
  final double _appBarHeight = 256.0;
  </#if>
  var _status;
  var _processBar;
  <#if GenSliverTabBar>
  var _tabs = ["tab1", "tab2", "tab3"];
  </#if>

  <#if PageType == "LOGIN">
  String _userName = "";
  String _password = "";
  FocusNode _focusUserName = FocusNode();
  FocusNode _focusPassword = FocusNode();

  </#if>
  @override
  void initState() {
    super.initState();
	<#if GenerateListView || GenSliverGrid || GenSliverFixedExtentList>
    if (this.widget.viewModel.${(ModelEntryName)?lower_case}s.length == 0) {
      _status = ActionStatus.running;
      this.widget.viewModel.get${ModelEntryName}s(true, get${ModelEntryName}sCallback);
    }
	</#if>
	<#if GenerateBottomTabBar>
	pageController = PageController(initialPage: this.page);
	</#if>
	<#if PageType == "LOGIN">
    initLogin();
	</#if>
  }

  <#if GenerateListView || GenSliverGrid || GenSliverFixedExtentList>
  void get${ModelEntryName}sCallback(ActionReport report) {
    setState(() {
      _status = report.status;
    });
  }

  </#if>
  <#if viewModelCreate>
  void create${ModelEntryName}Callback(ActionReport report) {
    if (report.status == ActionStatus.running) {
      showProcessBar("Creating...");
    } else {
      hideProcessBar();
    }
  }

  </#if>
  <#if viewModelUpdate>
  void update${ModelEntryName}Callback(ActionReport report) {
    if (report.status == ActionStatus.running) {
      showProcessBar("Updating...");
    } else {
      hideProcessBar();
    }
  }

  </#if>
  <#if viewModelDelete>
  void delete${ModelEntryName}Callback(ActionReport report) {
    if (report.status == ActionStatus.running) {
      showProcessBar("Deleting...");
    } else {
      hideProcessBar();
    }
  }

  </#if>
  <#if PageType == "LOGIN">
  void loginCallback(ActionReport report) {
    if (report.status == ActionStatus.running) {
      showProcessBar("Login...");
    } else if (report.status == ActionStatus.error) {
      hideProcessBar();
    } else {
      hideProcessBar();
      Navigator.of(context).pushReplacementNamed("/home");
    }
  }

  Future initLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString("username");
    _password = prefs.getString("password");
    if (_userName != null &&
        _password != null &&
        _password.isNotEmpty &&
        _userName.isNotEmpty) {
      widget.viewModel.login(Login(_userName, _password), loginCallback);
    }
  }

  </#if>
  void showError(String error) {
    final snackBar = SnackBar(content: Text(error));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var widget;

    <#if PageType == "LOGIN">
    widget = loginForm();
    <#elseif GenSliverToBoxAdapter || GenSliverGrid || GenSliverFixedExtentList || GenSliverTabBar>
    widget = buildCustomScrollView();
    <#elseif PageType == "PROFILE">
    <#else>
	<#if GenerateListView>
    widget = NotificationListener(
        onNotification: _onNotification,
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: this.widget.viewModel.${(ModelEntryName)?lower_case}s.length + 1,
            itemBuilder: (_, int index) => _createItem(context, index),
          ),
        ));
	<#elseif GenerateTopTabBar>
    widget = TabBarView(
      children: [
        Icon(Icons.directions_car),
        Icon(Icons.directions_transit),
        Icon(Icons.directions_bike),
      ],
    );
	<#elseif GenerateBottomTabBar>
	widget = PageView(
        children: <Widget>[ContactView(), Message(), Mine()],
        controller: pageController,
        onPageChanged: onPageChanged,
      );
	<#else>
	  widget = Text("Hello word");
	</#if>
	</#if>
	<#if GenerateTopTabBar>
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          title: Text("${PageName}"),
		  <#if (ActionList?size > 0)>
		  actions: _buildActionButton(),
		  </#if>
        ),
        body: widget,
      ),
    );
	<#elseif GenSliverTabView>
    widget = SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return NotificationListener(
            onNotification: _onNotification,
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  //TODO add your widget here
				  SliverFixedExtentList(
					  itemExtent: 50.0,
					  delegate: SliverChildBuilderDelegate(
						(BuildContext context, int index) {
						  return Container(
							alignment: Alignment.center,
							color: Colors.lightGreen[100 * (index % 9)],
							child: _createItem(context, index),
						  );
						},
						childCount: 15,
					  ),
					)
                ],
              ),
            ),
          );
        },
      ),
    );

	return widget;
	<#else>
    return Scaffold(
      key: _scaffoldKey,
	  <#if PageType =="MANNUL" && GenerateAppBar>
      appBar: AppBar(
        title: Text(<#if GenerateBottomTabBar>pages[page]<#else>"${PageName}View"</#if>),
		<#if (ActionList?size > 0)>
		actions: _buildActionButton(),
		</#if>
      ),
	  </#if>
	  <#if GenerateDrawer>
	  drawer: _buildDrawer(),
	  </#if>
      body: widget,
	  <#if GenerateBottomTabBar>
	  bottomNavigationBar: BottomNavigationBar(items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(pages[0]),
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text(pages[1]),
              backgroundColor: Colors.grey),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              title: Text(pages[2]),
              backgroundColor: Colors.blue)
        ], onTap: onTap, currentIndex: page)
	  </#if>
    );
	</#if>
  }
  <#if GenerateListView || GenSliverToBoxAdapter || GenSliverGrid || GenSliverFixedExtentList || GenSliverTabView>
  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      print(notification.scrollDelta);
      print(notification.metrics.toString());
      if (notification.metrics.extentAfter < 15.0) {
        // load more
        if (this._status != ActionStatus.running) {
          // have next page
          _loadMoreData();
          setState(() {});
        }
      }
    }

    return true;
  }

  Future<Null> _loadMoreData() {
	<#if GenerateListView || GenSliverGrid || GenSliverFixedExtentList>
    widget.viewModel.get${ModelEntryName}s(false, get${ModelEntryName}sCallback);
	</#if>
    return null;
  }

  Future<Null> _handleRefresh() async {
    _refreshIndicatorKey.currentState.show();
	<#if GenerateListView || GenSliverGrid || GenSliverFixedExtentList>
    widget.viewModel.get${ModelEntryName}s(true, get${ModelEntryName}sCallback);
	</#if>
    return null;
  }

  _createItem(BuildContext context, int index) {
    if (index < this.widget.viewModel.${(ModelEntryName)?lower_case}s?.length) {
      return <#if viewModelDelete>SwipeListItem<${ModelEntryName}>(
          item: this.widget.viewModel.${(ModelEntryName)?lower_case}s[index],
          onArchive: _handleArchive,
          onDelete: _handleDelete,
          child: </#if>Container(
              child: _${ModelEntryName}ListItem(
                ${(ModelEntryName)?lower_case}: this.widget.viewModel.${(ModelEntryName)?lower_case}s[index],
                onTap: () {
                  //Navigator.push(
                  //  context,
                  //  MaterialPageRoute(
                  //    builder: (context) =>
                  //        View${ModelEntryName}(${(ModelEntryName)?lower_case}: this.widget.viewModel.${(ModelEntryName)?lower_case}s[index]),
                  //  ),
                  //);
                },
              ),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))))<#if viewModelDelete>)</#if>;
    }

    return Container(
      height: 44.0,
      child: Center(
        child: _getLoadMoreWidget(),
      ),
    );
  }

  <#if viewModelDelete>
  void _handleArchive(${ModelEntryName} item) {}

  void _handleDelete(${ModelEntryName} item) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text("DELETE"),
            content: Text('Do you want to delete this item'),
            actions: <Widget>[
              FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    this.widget.viewModel.delete${ModelEntryName}(item, delete${ModelEntryName}Callback);
                    Navigator.pop(context);
                  })
            ],
          ),
    );
  }

  </#if>
  Widget _getLoadMoreWidget() {
    if (this._status == ActionStatus.running) {
      return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: CircularProgressIndicator());
    } else {
      return SizedBox();
    }
  }

  </#if>
  <#if GenerateBottomTabBar>
  void onTap(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this.page = page;
    });
  }

  </#if>
  <#if PageType == "LOGIN">
  Widget loginForm() {
	return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 30.0,
          right: 30.0,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 48.0,
                child: Image.asset('assets/images/flower.png'),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              maxLines: 1,
              onChanged: (name) => _userName = name,
              style: TextStyle(fontSize: 15.0, color: Colors.black),
              focusNode: _focusUserName,
              decoration: InputDecoration(
                  hintText: "UserName",
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  labelStyle: TextStyle(fontWeight: FontWeight.w700)),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              maxLines: 1,
              obscureText: true,
              onChanged: (password) => _password = password,
              style: TextStyle(fontSize: 15.0, color: Colors.black),
              focusNode: _focusPassword,
              decoration: InputDecoration(
                  hintText: "Password",
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  labelStyle: TextStyle(fontWeight: FontWeight.w700)),
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.lightBlueAccent.shade100,
                elevation: 5.0,
                child: MaterialButton(
                  minWidth: 200.0,
                  height: 42.0,
                  onPressed: () {
                    if (_userName.isEmpty) {
                      showError("UserName is empty!");
                      return;
                    }

                    if (_password.isEmpty) {
                      showError("Password is empty!");
                      return;
                    }

                    widget.viewModel.login(Login(_userName, _password), loginCallback);
                  },
                  color: Colors.lightBlueAccent,
                  child: Text('Log In', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            FlatButton(
              child: Text(
                'Forgot password?',
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  </#if>
  <#if GenSliverToBoxAdapter || GenSliverGrid || GenSliverFixedExtentList || GenSliverTabBar>
  Widget buildCustomScrollView() {
    var body;

    <#if GenSliverTabBar>
    body = TabBarView(
      // These are the contents of the tab views, below the tabs.
      children: _tabs.map((String name) {
        return ${PageName}TabView();// TODO replace your tab view here
      }).toList(),
    );
    <#else>
	var subWidget;
	<#if GenSliverToBoxAdapter>
    subWidget = SliverToBoxAdapter(
        child: Stack(children: <Widget>[
      Container(
		  <#if FabInAppBar>
          padding: const EdgeInsets.only(top: _fabHalfSize),
		  </#if>
          child: Container(
              color: Theme.of(context).canvasColor,
              child: Column(
                children: <Widget>[
                  Card(
                      child: Image.network(
                    "https://images.unsplash.com/photo-1556228578-626e9590b81f?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjY5MjI3fQ",
                    fit: BoxFit.cover,
                    height: _appBarHeight,
                  )),
                  Card(
                      child: Image.network(
                        "https://images.unsplash.com/photo-1556228578-626e9590b81f?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjY5MjI3fQ",
                        fit: BoxFit.cover,
                        height: _appBarHeight,
                      )),
                  Card(
                      child: Image.network(
                        "https://images.unsplash.com/photo-1556228578-626e9590b81f?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjY5MjI3fQ",
                        fit: BoxFit.cover,
                        height: _appBarHeight,
                      )),
                  Card(
                      child: Image.network(
                        "https://images.unsplash.com/photo-1556228578-626e9590b81f?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjY5MjI3fQ",
                        fit: BoxFit.cover,
                        height: _appBarHeight,
                      )),
                ],
              ))),
      <#if FabInAppBar>
      Positioned(
        right: 16.0,
        child: FloatingActionButton(
          child: Icon(Icons.favorite),
          onPressed: () {},
        ),
      )
      </#if>
    ]));
    </#if>
    <#if GenSliverGrid>
    subWidget = SliverGrid(
            gridDelegate: ${PageName}GridDelegate(),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _createItem(context, index);
               },
               childCount: 20,
             ),
           );
    </#if>
    <#if GenSliverFixedExtentList>
    subWidget = SliverFixedExtentList(
      itemExtent: 50.0,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            color: Colors.lightGreen[100 * (index % 9)],
            child: _createItem(context, index),
          );
        },
        childCount: 15,
      ),
    );
    </#if>
    body = SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return NotificationListener(
            onNotification: _onNotification,
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  subWidget
                ],
              ),
            ),
          );
        },
      ),
    );
	</#if>

    return <#if GenSliverTabBar>DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: </#if>Stack(
        children: <Widget>[
          NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              // These are the slivers that show up in the "outer" scroll view.
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  child: SliverAppBar(
                    pinned: true,
                    expandedHeight:  _appBarHeight<#if FabInAppBar> - _fabHalfSize</#if>,
                    forceElevated: innerBoxIsScrolled,
                    <#if (ActionList?size > 0)>
                    actions: _buildActionButton(),
                    </#if>
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding:
                          EdgeInsets.only(left: 16, bottom: 16<#if GenSliverTabBar> + 48.0</#if>),
                      title: Text("Titile"),
                      background: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Hero(
                              tag: "image_tag",
                              child: Image.network(
                                "https://images.unsplash.com/photo-1556228578-626e9590b81f?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjY5MjI3fQ",
                                fit: BoxFit.cover,
                                height: _appBarHeight,
                              )),
                          // This gradient ensures that the toolbar icons are distinct
                          // against the background image.
                          const DecoratedBox(
                            decoration: const BoxDecoration(
                              gradient: const LinearGradient(
                                begin: const Alignment(0.0, -1.0),
                                end: const Alignment(0.0, -0.4),
                                colors: const <Color>[
                                  const Color(0x60000000),
                                  const Color(0x00000000)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    <#if GenSliverTabBar>
                    bottom: TabBar(
                      tabs:
                          _tabs.map((String name) => Tab(text: name)).toList(),
                    ),
                    </#if>
                  ),
                ),
              ];
            },
            body: body,
          ),
        ],
      <#if GenSliverTabBar>
      ),
      </#if>
    );
  }

  </#if>
  <#if GenerateDrawer>
  Drawer _buildDrawer() {
    var fontFamily = "Roboto";
    var accountEmail = Text(
        "haystack1206@gmail.com",
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontFamily: fontFamily
        )
    );
    var accountName = Text(
        "HAY",
        style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontFamily: fontFamily
        )
    );
    var accountPicture = CircleAvatar(
        child: Image.asset("assets/icons/ic_launcher.png"),
        backgroundColor: Theme.of(context).accentColor
    );

    var header = UserAccountsDrawerHeader(
      accountEmail: accountEmail,
      accountName: accountName,
      onDetailsPressed: _onTap,
      currentAccountPicture: accountPicture,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor
      ),
    );

    var tileItem1 = ListTile(
        leading: Icon(Icons.add_a_photo),
        title: Text("Add Photo"),
        subtitle: Text("Add a photo to your album"),
        onTap: _onTap
    );
    var tileItem2 = ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text("Exit"),
        onTap: _onTap
    );

    var listView = ListView(children: [header, tileItem1, tileItem2]);

    var drawer = Drawer(child: listView);

    return drawer;
  }

  void _onTap() {
    // Update the state of the app
    // ...
    // Then close the drawer
    Navigator.pop(context);
  }

  </#if>
  <#if (ActionBtnCount > 0)>
  List<Widget> _buildActionButton() {
    return <Widget>[
      <#list ActionList as act>
      <#if act_index == 0>
      <#if act == "search">
      IconButton(
        icon: Icon(choices[0].icon),
        onPressed: () async {
          final int selected = await showSearch<int>(
            context: context,
            delegate: _delegate,
          );
          if (selected != null) {
            setState(() {
              showError("you select $selected");
            });
          }
        },
      ),
      <#else>
      IconButton(
        icon: Icon(choices[0].icon),
        onPressed: () {
          _select(choices[0]);
        },
      ),
      </#if>
      </#if>
      </#list>
      <#if (ActionBtnCount > 1)>
      // overflow menu
      PopupMenuButton<Choice>(
        onSelected: _select,
        itemBuilder: (BuildContext context) {
          return choices.skip(1).map((Choice choice) {
            return PopupMenuItem<Choice>(
              value: choice,
              child: Row(
                children: <Widget>[Icon(choice.icon), Text(choice.title)],
              ),
            );
          }).toList();
        },
      ),
      </#if>
    ];
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {});
  }

  </#if>
  void hideProcessBar() {
    if (_processBar != null && _processBar.isShowing()) {
      _processBar.hide();
      _processBar = null;
    }
  }

  void showProcessBar(String msg) {
    if (_processBar == null) {
      _processBar = new ProgressDialog(context);
    }
    _processBar.setMessage(msg);
    _processBar.show();
  }
}
<#if GenerateActionButton>

const List<Choice> choices = const <Choice>[
  <#list ActionList as act>
  <#if act == "search">
  const Choice(title: 'Search', icon: Icons.search),
  </#if>
  <#if act == "add">
  const Choice(title: 'Add', icon: Icons.add),
  </#if>
  <#if act == "save">
  const Choice(title: 'Save', icon: Icons.save),
  </#if>
  <#if act == "edit">
  const Choice(title: 'Edit', icon: Icons.edit),
  </#if>
  </#list>
];
</#if>
<#if GenerateListView || GenSliverToBoxAdapter || GenSliverGrid || GenSliverFixedExtentList || GenSliverTabView>

class _${ModelEntryName}ListItem extends ListTile {
  _${ModelEntryName}ListItem({${ModelEntryName} ${(ModelEntryName)?lower_case}, GestureTapCallback onTap})
      : super(
            title: Text("Title"),
            subtitle: Text("Subtitle"),
            leading: CircleAvatar(child: Text("T")),
            onTap: onTap);
}
</#if>
<#if GenSliverGrid>

class ${PageName}GridDelegate extends SpanableSliverGridDelegate {
  ${PageName}GridDelegate() : super(2, mainAxisSpacing: 10.0, crossAxisSpacing: 10.0);

  @override
  int getCrossAxisSpan(int index) {
    if (index % 5 == 0) return 2;

    return 1;
  }

  @override
  double getMainAxisExtent(int index) {
//    if(index == 0)
//      return 320.0;
//
//    if(index == 1 || index == 10)
//      return 250.0;

    return 220.0;
  }

</#if>
<#if HasActionSearch>

class _SearchDemoSearchDelegate extends SearchDelegate<int> {
  final List<int> _data =
      List<int>.generate(100001, (int i) => i).reversed.toList();
  final List<int> _history = <int>[42607, 85604, 66374, 44, 174];

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<int> suggestions = query.isEmpty
        ? _history
        : _data.where((int i) => '$i'.startsWith(query));

    return _SuggestionList(
      query: query,
      suggestions: suggestions.map((int i) => '$i').toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final int searched = int.tryParse(query);
    if (searched == null || !_data.contains(searched)) {
      return Center(
        child: Text(
          '"$query"\n is not a valid integer between 0 and 100,000.\nTry again.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView(
      children: <Widget>[
        _ResultCard(
          title: 'This integer',
          integer: searched,
          searchDelegate: this,
        ),
        _ResultCard(
          title: 'Next integer',
          integer: searched + 1,
          searchDelegate: this,
        ),
        _ResultCard(
          title: 'Previous integer',
          integer: searched - 1,
          searchDelegate: this,
        ),
      ],
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? IconButton(
              tooltip: 'Voice Search',
              icon: const Icon(Icons.mic),
              onPressed: () {
                query = 'TODO: implement voice input';
              },
            )
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
    ];
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({this.integer, this.title, this.searchDelegate});

  final int integer;
  final String title;
  final SearchDelegate<int> searchDelegate;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        searchDelegate.close(context, integer);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(title),
              Text(
                '$integer',
                style: theme.textTheme.headline.copyWith(fontSize: 72.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style:
                  theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: theme.textTheme.subhead,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
</#if>