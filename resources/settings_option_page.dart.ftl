import 'package:flutter/material.dart';
import 'package:${ProjectName}/features/settings/settings_option.dart';
import 'package:${ProjectName}/features/settings/text_scale.dart';
import 'package:${ProjectName}/features/settings/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double _kItemHeight = 48.0;

class _OptionsItem extends StatelessWidget {
  const _OptionsItem({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);

    return MergeSemantics(
      child: Container(
        constraints: BoxConstraints(minHeight: _kItemHeight * textScaleFactor),
        alignment: AlignmentDirectional.centerStart,
        child: DefaultTextStyle(
          style: DefaultTextStyle.of(context).style,
          maxLines: 2,
          overflow: TextOverflow.fade,
          child: IconTheme(
            data: Theme.of(context).primaryIconTheme,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _BooleanItem extends StatelessWidget {
  const _BooleanItem(this.title, this.value, this.onChanged, this.iconData);

  final IconData iconData;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return new _OptionsItem(
      child: new Row(
        children: <Widget>[
          new Icon(iconData, color: Theme.of(context).textTheme.body1.color),
          new Expanded(child: new Text(title)),
          new Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF39CEFD),
            activeTrackColor: isDark ? Colors.white30 : Colors.black26,
          ),
        ],
      ),
    );
  }
}

class _ThemeItem extends StatelessWidget {
  const _ThemeItem(this.options, this.onOptionsChanged);

  final SettingsOptions options;
  final ValueChanged<SettingsOptions> onOptionsChanged;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return new _BooleanItem('Dark Theme', isDark, (bool value) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool("isDark", value);
      });
      if (value) {
        AppTheme.configure(ThemeName.DARK);
      } else {
        AppTheme.configure(ThemeName.LIGHT);
      }
      onOptionsChanged(
        options.copyWith(
          theme: AppTheme().appTheme,
        ),
      );
    }, Icons.brightness_3);
  }
}

class _TextScaleFactorItem extends StatelessWidget {
  const _TextScaleFactorItem(this.options, this.onOptionsChanged);

  final SettingsOptions options;
  final ValueChanged<SettingsOptions> onOptionsChanged;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return new _OptionsItem(
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Icon(
                  Icons.text_format,
                  color: Theme.of(context).textTheme.body1.color,
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Text size'),
                    new Text(options.textScaleFactor.label),
                  ],
                ),
              ])),
          new PopupMenuButton<AppTextScaleValue>(
            padding: const EdgeInsetsDirectional.only(end: 16.0),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
            itemBuilder: (BuildContext context) {
              return appTextScaleValues.map((AppTextScaleValue scaleValue) {
                return new PopupMenuItem<AppTextScaleValue>(
                  value: scaleValue,
                  child: new Text(scaleValue.label),
                );
              }).toList();
            },
            onSelected: (AppTextScaleValue scaleValue) {
              onOptionsChanged(
                options.copyWith(textScaleFactor: scaleValue),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PlatformItem extends StatelessWidget {
  const _PlatformItem(this.options, this.onOptionsChanged);

  final SettingsOptions options;
  final ValueChanged<SettingsOptions> onOptionsChanged;

  String _platformLabel(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
        return 'Mountain View';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
      case TargetPlatform.iOS:
        return 'Cupertino';
    }
    assert(false);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new _OptionsItem(
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Icon(
                  Icons.widgets,
                  color: Theme.of(context).textTheme.body1.color,
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Platform mechanics'),
                    new Text(
                      _platformLabel(options.platform),
                      style: Theme.of(context).primaryTextTheme.body1,
                    ),
                  ],
                ),
              ])),
          new PopupMenuButton<TargetPlatform>(
            padding: const EdgeInsetsDirectional.only(end: 16.0),
            icon: const Icon(Icons.arrow_drop_down),
            itemBuilder: (BuildContext context) {
              return TargetPlatform.values.map((TargetPlatform platform) {
                return new PopupMenuItem<TargetPlatform>(
                  value: platform,
                  child: new Text(_platformLabel(platform)),
                );
              }).toList();
            },
            onSelected: (TargetPlatform platform) {
              onOptionsChanged(
                options.copyWith(platform: platform),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SettingsOptionsPage extends StatelessWidget {
  const SettingsOptionsPage({
    Key key,
    this.options,
    this.onOptionsChanged,
  }) : super(key: key);

  final SettingsOptions options;
  final ValueChanged<SettingsOptions> onOptionsChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: new ListView(
          padding: const EdgeInsets.only(bottom: 124.0),
          children: <Widget>[
            new _ThemeItem(options, onOptionsChanged),
            const Divider(),
            new _TextScaleFactorItem(options, onOptionsChanged),
            const Divider(),
            new _PlatformItem(options, onOptionsChanged),
          ],
        ),
      ),
    );
  }
}