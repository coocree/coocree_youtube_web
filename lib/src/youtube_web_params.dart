// Copyright 2022 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'platform_view_stub.dart' if (dart.library.html) 'dart:ui' as ui;

/// An implementation of [PlatformWebViewControllerCreationParams] using Flutter
/// for Web API.
@immutable
class YoutubeWebParams
    extends PlatformWebViewControllerCreationParams {
  /// Creates a [YoutubeWebParams] instance based on [PlatformWebViewControllerCreationParams].
  YoutubeWebParams.fromPlatformWebViewControllerCreationParams(
      // Recommended placeholder to prevent being broken by platform interface.
      // ignore: avoid_unused_constructor_parameters
      PlatformWebViewControllerCreationParams params,
      );

  static int _nextIFrameId = 0;

  /// The underlying element used as the WebView.
  @visibleForTesting
  final IFrameElement ytiFrame = IFrameElement()
    ..id = 'youtube-${_nextIFrameId++}'
    ..width = '100%'
    ..height = '100%'
    ..style.border = 'none'
    ..allow = 'autoplay;fullscreen';
}