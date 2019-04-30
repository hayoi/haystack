Haystack is an AS/Intellij IDEA plugin to rapid construct a Flutter app architecture. It consists of the follow features.
  - Using Redux to manage state and update UI.
  - json to dart entities class, support int, bool, String, double, Datetime.
  - Generate restful api base on your json entities
  - Generate database module.
  - Generate some widgets with BottomNavigatorBar, Draw, AppBar TopTabBar, ListView(bind model entry from restful api or Database), Login, if you want.
  - Generate CustomScrollView widgets with FixedExtentLit, Grid, BoxAdapter as you wish.

## Usage
1. Install the plugin.
2. Create a Flutter project with AS or Intellij IEDA.
3. Right tap the lib folder in AS project structure, select "New" -> "Generate App Template".
4. Click the "Init project" to init the project(Just init project once only).
5. Enter the information of your page and tap "OK".  
![step 5](https://raw.githubusercontent.com/hayoi/haystack/master/image/init_page.jpg)
6. Configure class field and generate.  
![step 6](https://raw.githubusercontent.com/hayoi/haystack/master/image/model.png)
7. the plugin will generate code  
![code](https://raw.githubusercontent.com/hayoi/haystack/master/image/structure.png)
8. Add your page to the routes in the main.dart  
```
  Map<String, WidgetBuilder> _routes() {
    return <String, WidgetBuilder>{
      "/settings": (_) => SettingsOptionsPage(
            options: _options,
            onOptionsChanged: _handleOptionsChanged,
          ),
      "/": (_) => new HomeView(),
    };
  }
```
You can run the project  
![app](https://raw.githubusercontent.com/hayoi/haystack/master/image/app.png)

[example](https://github.com/hayoi/redux_example)
