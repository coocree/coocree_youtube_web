// Copyright 2022 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:coocree_youtube_web/src/youtube_web_controller.dart';
import 'package:coocree_youtube_web/src/youtube_web_player.dart';

/// Implementação de [WebViewPlatform] usando a API Flutter para Web.
class YoutubeWebPlatform extends WebViewPlatform {

  /// Cria um novo [PlatformWebViewController].
  @override
  PlatformWebViewController createPlatformWebViewController(
      PlatformWebViewControllerCreationParams params,
      ) {
    return YoutubeWebController(params);
  }

  /// Cria um novo [PlatformWebViewWidget].
  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
      PlatformWebViewWidgetCreationParams params,
      ) {
    return YoutubeWebPlayer(params);
  }

  /// Cria um novo [PlatformNavigationDelegate].
  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
      PlatformNavigationDelegateCreationParams params,
      ) {
    return WebNavigationDelegate(params);
  }

  /// Chamado quando o plugin é registrado.
  static void registerWith(Registrar registrar) {
    // Registra a instância da plataforma WebView.
    WebViewPlatform.instance = YoutubeWebPlatform();
  }
}

/// Implementação de [PlatformNavigationDelegate] usando a API Flutter para Web.
class WebNavigationDelegate extends PlatformNavigationDelegate {

  /// Cria uma nova instância de [WebNavigationDelegate].
  WebNavigationDelegate(PlatformNavigationDelegateCreationParams params) : super.implementation(params);

  /// Define o callback de requisição de navegação.
  @override
  Future<void> setOnNavigationRequest(
      NavigationRequestCallback onNavigationRequest,
      ) async {}

  /// Define o callback de erro de recursos da web.
  @override
  Future<void> setOnWebResourceError(
      WebResourceErrorCallback onWebResourceError,
      ) async {}
}

