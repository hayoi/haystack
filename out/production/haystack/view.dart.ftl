import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:${ProjectName}/data/model/${(ModelEntryName)?lower_case}_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:${ProjectName}/trans/translations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:${ProjectName}/redux/loading_status.dart';
import 'package:${ProjectName}/redux/app/app_state.dart';
import 'package:${ProjectName}/features/<#if IsCustomWidget>customize/</#if>${(PageName)?lower_case}/${(PageName)?lower_case}_view_model.dart';
<#if GenerateListView>
import 'package:${ProjectName}/features/widget/swipe_list_item.dart';
</#if>
<#if GenSliverGrid>
import 'package:flutter_mvp/features/widget/spannable_grid.dart';
</#if>

class ${PageName}View extends StatelessWidget {
  ${PageName}View({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ${PageName}ViewModel>(
      distinct: true,
      converter: (store) => ${PageName}ViewModel.fromStore(store),
      builder: (_, viewModel) => ${PageName}ViewContent(
            viewModel: viewModel,
          ),
    );
  }
}

class ${PageName}ViewContent extends StatefulWidget {
  final ${PageName}ViewModel viewModel;

  ${PageName}ViewContent({Key key, this.viewModel}) : super(key: key);

  @override
  _${PageName}ViewContentState createState() => _${PageName}ViewContentState();
}

<#if FabInAppBar>
const double _fabHalfSize = 28.0;

</#if>
class _${PageName}ViewContentState extends State<${PageName}ViewContent> {
  <#if HasActionSearch>
  final _SearchDemoSearchDelegate _delegate = _SearchDemoSearchDelegate();
  </#if>
  <#if GenerateListView>
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final TrackingScrollController _scrollController = TrackingScrollController();
  </#if>
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  <#if GenerateBottomTabBar>
  PageController pageController;
  int page = 0;
  List pages = ["Home","Notice","Mine"];
  </#if>
  <#if GenerateCustomScrollView>
  final double _appBarHeight = 256.0;
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
	<#if GenerateListView>
    if (this.widget.viewModel.${(ModelEntryName)?lower_case}s.length == 0) {
      this.widget.viewModel.get${ModelEntryName}s(true);
    }
	</#if>
	<#if GenerateBottomTabBar>
	pageController = PageController(initialPage: this.page);
	</#if>
	<#if PageType == "LOGIN">
    initLogin();
	</#if>
  }
  
  <#if PageType == "LOGIN">
  Future initLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString("username");
    _password = prefs.getString("password");
    if (_userName != null &&
        _password != null &&
        _password.isNotEmpty &&
        _userName.isNotEmpty) {
      widget.viewModel.login(context, Login(_userName, _password));
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

    if (this.widget.viewModel.status == LoadingStatus.loading) {
      widget = Center(
          child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: CircularProgressIndicator()));
    } else {
      <#if PageType == "LOGIN">
      widget = loginForm();
      <#elseif PageType == "CUSTOMSCROLLVIEW">
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
    }
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
  <#if GenerateListView>

  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {

      if (_scrollController.mostRecentlyUpdatedPosition.maxScrollExtent > _scrollController.offset &&
          _scrollController.mostRecentlyUpdatedPosition.maxScrollExtent - _scrollController.offset <= 50) {
        // load more
        if (this.widget.viewModel.status == LoadingStatus.success ||
            this.widget.viewModel.status == LoadingStatus.error) {
          // have next page
          _loadMoreData();
          setState(() {});
        } else {}
      }
    }

    return true;
  }

  Future<Null> _loadMoreData() {
    widget.viewModel.get${ModelEntryName}s(false);
    return null;
  }

  Future<Null> _handleRefresh() async {
    _refreshIndicatorKey.currentState.show();
    widget.viewModel.get${ModelEntryName}s(true);
    return null;
  }

  _createItem(BuildContext context, int index) {
    if (index < this.widget.viewModel.${(ModelEntryName)?lower_case}s.length) {
      return SwipeListItem<${ModelEntryName}>(
          item: this.widget.viewModel.${(ModelEntryName)?lower_case}s[index],
          onArchive: _handleArchive,
          onDelete: _handleDelete,
          child: Container(
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
                  border: Border(bottom: BorderSide(color: Colors.black26)))));
    }

    return Container(
      height: 44.0,
      child: Center(
        child: _getLoadMoreWidget(),
      ),
    );
  }

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
                    this.widget.viewModel.delete${ModelEntryName}(item);
                    Navigator.pop(context);
                  })
            ],
          ),
    );
  }
  
  Widget _getLoadMoreWidget() {
    if (this.widget.viewModel.status == LoadingStatus.loading) {
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
            Hero(
              tag: 'hero',
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 48.0,
                child: Image.asset('assets/images/flower.png'),
              ),
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

                    widget.viewModel.login(context, Login(_userName, _password));
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

  <#if GenerateCustomScrollView>

  Stack buildCustomScrollView() {
    var imagePath = "assets/images/flower2.png";
    return Stack(children: <Widget>[
      <#if FabInAppBar>
      Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        height: _appBarHeight + _fabHalfSize,
        child: Hero(
          tag: 'imagePath',
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
      </#if>
      CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: _appBarHeight<#if FabInAppBar> - _fabHalfSize</#if>,
            pinned: true,
            floating: false,
            snap: false,
            backgroundColor: Colors.transparent,
            <#if (ActionBtnCount > 0)>
            actions: _buildActionButton(),
            </#if>
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Title'),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  <#if !FabInAppBar>
                  Hero(
                      tag: imagePath,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        height: _appBarHeight,
                      )),
                  </#if>
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
          ),
          <#if GenSliverToBoxAdapter>
          SliverToBoxAdapter(
              child: Stack(children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: _fabHalfSize),
                child: Container(
                    color: Theme.of(context).canvasColor,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Card(
                            child: Text(
                                "\n1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20\n21\n22\n1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20\n2"),
                          ),
                        )
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
          ])),
          </#if>
          <#if GenSliverGrid>
          SliverGrid(
            gridDelegate: ${PageName}GridDelegate(),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _ProductItem(
                  product: index,
                  onPressed: () {},
                );
              },
              childCount: 20,
            ),
          ),
          </#if>
          <#if GenSliverFixedExtentList>
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.lightGreen[100 * (index % 9)],
                  child: Text('list item $index'),
                );
              },
              childCount: 15,
            ),
          ),
          </#if>
        ],
      )
    ]);
  }
  </#if>
  <#if GenerateDrawer>
 
  Drawer _buildDrawer() {
    var fontFamily = "Roboto";
    var accountEmail = Text(
        "hay@gmail.com",
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

}
<#if GenerateActionButton>

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

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
<#if GenerateListView>

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
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({Key key, @required this.product, this.onPressed})
      : assert(product != null),
        super(key: key);

  final int product;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Card(
        elevation: 2.0,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration:
                          BoxDecoration(color: Theme.of(context).canvasColor),
                      child: Text("￥12.0")),
                ),
                Container(
                  foregroundDecoration: BoxDecoration(
                      border: Border.all(color: Colors.lightGreen)),
                  height: 144.0,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Hero(
                    tag: "123 $product",
                    child: Image.asset(
                      "assets/products/shirt.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    height: 24.0,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 24.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.asset(
                              "assets/images/flower2.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text("name $product"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(onTap: onPressed),
            ),
          ],
        ),
      ),
    );
  }
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