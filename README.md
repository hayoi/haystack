Haystack is an AS/Intellij IDEA plugin to rapid construct a Flutter app architecture. It consists of the follow feature.
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
![step 5](https://upload-images.jianshu.io/upload_images/2398000-d3a7f7fa10168edb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
6. Configure class field and generate.  
![step 6](https://upload-images.jianshu.io/upload_images/2398000-164b83c02dfe6b33.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
7. the plugin will generate code  
![code](https://upload-images.jianshu.io/upload_images/2398000-1c8823d07584233f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
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
![app](https://upload-images.jianshu.io/upload_images/2398000-86558a04dfee614e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
