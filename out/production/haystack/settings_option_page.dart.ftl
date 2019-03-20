import 'package:flutter/material.dart';
import 'package:${ProjectName}/features/settings/settings_option.dart';
import 'package:${ProjectName}/features/settings/text_scale.dart';
import 'package:${ProjectName}/features/settings/theme.dart';

const double _kItemHeight = 48.0;
const EdgeInsetsDirectional _kItemPadding = const EdgeInsetsDirectional.only(start: 56.0);

class _OptionsItem extends StatelessWidget {
  const _OptionsItem({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);

    return MergeSemantics(
      child: Container(
        constraints: BoxConstraints(minHeight: _kItemHeight * textScaleFactor),
        padding: _kItemPadding,
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
  const _BooleanItem(this.title, this.value, this.onChanged);

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return new _OptionsItem(
      child: new Row(
        children: <Widget>[
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

class _ActionItem extends StatelessWidget {
  const _ActionItem(this.text, this.onTap);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return new _OptionsItem(
      child: new _FlatButton(
        onPressed: onTap,
        child: new Text(text),
      ),
    );
  }
}

class _FlatButton extends StatelessWidget {
  const _FlatButton({Key key, this.onPressed, this.child}) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: new DefaultTextStyle(
        style: Theme.of(context).primaryTextTheme.subhead,
        child: child,
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new _OptionsItem(
      child: new DefaultTextStyle(
        style: theme.textTheme.body1.copyWith(
          fontFamily: 'GoogleSans',
          color: theme.accentColor,
        ),
        child: new Semantics(
          child: new Text(text),
          header: true,
        ),
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
    return new _BooleanItem(
      'Dark Theme',
      isDark,
      (bool value) {
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
      },
    );
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
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Text size'),
                new Text(
                  '${r"${options.textScaleFactor.label}"}',
                ),
              ],
            ),
          ),
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

class _TextDirectionItem extends StatelessWidget {
  const _TextDirectionItem(this.options, this.onOptionsChanged);

  final SettingsOptions options;
  final ValueChanged<SettingsOptions> onOptionsChanged;

  @override
  Widget build(BuildContext context) {
    return new _BooleanItem(
      'Force RTL',
      options.textDirection == TextDirection.rtl,
      (bool value) {
        onOptionsChanged(
          options.copyWith(
            textDirection: value ? TextDirection.rtl : TextDirection.ltr,
          ),
        );
      },
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
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Platform mechanics'),
                new Text(
                  '${r"${_platformLabel(options.platform)}"}',
                  style: Theme.of(context).primaryTextTheme.body1,
                ),
              ],
            ),
          ),
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
      body: new ListView(
        padding: const EdgeInsets.only(bottom: 124.0),
        children: <Widget>[
          const _Heading('Display'),
          new _ThemeItem(options, onOptionsChanged),
          new _TextScaleFactorItem(options, onOptionsChanged),
          new _TextDirectionItem(options, onOptionsChanged),
          const Divider(),
          const _Heading('Platform mechanics'),
          new _PlatformItem(options, onOptionsChanged),
        ]..addAll(
            <Widget>[
              const Divider(),
              const _Heading('Flutter gallery'),
              new _ActionItem('About Flutter Gallery', () {
//              showGalleryAboutDialog(context);
              }),
            ],
          ),
      ),
    );
  }
}
