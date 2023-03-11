// Copyright 2022 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:coocree_youtube_web/src/youtube_web_controller.dart';
import 'package:coocree_youtube_web/src/youtube_web_player.dart';

/// An implementation of [WebViewPlatform] using Flutter for Web API.
class YoutubeWebPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return YoutubeWebController(params);
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return YoutubeWebPlayer(params);
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    return WebNavigationDelegate(params);
  }

  /// Gets called when the plugin is registered.
  static void registerWith(Registrar registrar) {
    WebViewPlatform.instance = YoutubeWebPlatform();
  }
}

/// An implementation of [PlatformNavigationDelegate] using Flutter for Web API.
class WebNavigationDelegate extends PlatformNavigationDelegate {
  /// Creates a new [WebNavigationDelegate] instance.
  WebNavigationDelegate(PlatformNavigationDelegateCreationParams params) : super.implementation(params);

  @override
  Future<void> setOnNavigationRequest(
    NavigationRequestCallback onNavigationRequest,
  ) async {}

  @override
  Future<void> setOnWebResourceError(
    WebResourceErrorCallback onWebResourceError,
  ) async {}
}
