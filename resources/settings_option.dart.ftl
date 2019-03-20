import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:${ProjectName}/features/settings/text_scale.dart';

class SettingsOptions {
  SettingsOptions({
    this.theme,
    this.textScaleFactor,
    this.textDirection = TextDirection.ltr,
    this.platform,
  });

  final ThemeData theme;
  final AppTextScaleValue textScaleFactor;
  final TextDirection textDirection;
  final TargetPlatform platform;

  SettingsOptions copyWith({
    ThemeData theme,
    AppTextScaleValue textScaleFactor,
    TextDirection textDirection,
    TargetPlatform platform,
  }) {
    return new SettingsOptions(
      theme: theme ?? this.theme,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      textDirection: textDirection ?? this.textDirection,
      platform: platform ?? this.platform,
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;
    final SettingsOptions typedOther = other;
    return theme == typedOther.theme &&
        textScaleFactor == typedOther.textScaleFactor &&
        textDirection == typedOther.textDirection &&
        platform == typedOther.platform;
  }

  @override
  int get hashCode => hashValues(
        theme,
        textScaleFactor,
        textDirection,
        platform,
      );

  @override
  String toString() {
    return '$runtimeType($theme)';
  }
}
