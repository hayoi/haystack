import 'package:flutter/material.dart';

class AppTextScaleValue {
  const AppTextScaleValue(this.scale, this.label);

  final double scale;
  final String label;

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;
    final AppTextScaleValue typedOther = other;
    return scale == typedOther.scale && label == typedOther.label;
  }

  @override
  int get hashCode => hashValues(scale, label);

  @override
  String toString() {
    return '$runtimeType($label)';
  }
}

const List<AppTextScaleValue> appTextScaleValues =
    const <AppTextScaleValue>[
  const AppTextScaleValue(null, 'System Default'),
  const AppTextScaleValue(0.8, 'Small'),
  const AppTextScaleValue(1.0, 'Normal'),
  const AppTextScaleValue(1.3, 'Large'),
  const AppTextScaleValue(2.0, 'Huge'),
];
