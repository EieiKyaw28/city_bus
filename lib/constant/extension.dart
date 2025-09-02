import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension Size on BuildContext {
  get getWidth => MediaQuery.of(this).size.width;
  get getHeight => MediaQuery.of(this).size.height;
}

extension Gap on num {
  SizedBox get vGap => SizedBox(height: toDouble());
  SizedBox get hGap => SizedBox(width: toDouble());
}

bool get isMobile {
  return defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;
}

bool get isDesktop {
  return defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS;
}
