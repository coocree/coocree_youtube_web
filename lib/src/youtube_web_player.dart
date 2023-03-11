// Copyright 2022 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'platform_view_stub.dart' if (dart.library.html) 'dart:ui' as ui;
import 'youtube_web_controller.dart';
/// Implementação de [PlatformWebViewWidget] usando a API Flutter para Web.
class YoutubeWebPlayer extends PlatformWebViewWidget {

  /// Cria um novo [YoutubeWebPlayer].
  YoutubeWebPlayer(PlatformWebViewWidgetCreationParams params)
      : _controller = params.controller as YoutubeWebController,
        super.implementation(params) {
    // Registra o factory da view do elemento HTML.
    ui.platformViewRegistry.registerViewFactory(
      _controller.creationParams.ytiFrame.id,
          (int viewId) => _controller.creationParams.ytiFrame,
    );
  }

  final YoutubeWebController _controller;

  @override
  Widget build(BuildContext context) {
    // Exibe uma mensagem no console.
    print('YoutubeWebPlayer.build()--->>> DDDDD');

    return HtmlElementView(
      key: params.key,
      viewType: (params.controller as YoutubeWebController).creationParams.ytiFrame.id,
      onPlatformViewCreated: (_) {
        // Registra o canal de comunicação entre o Flutter e a WebView.
        final channelParams = _controller.javaScriptChannelParams;
        window.onMessage.listen(
              (event) {
            if (channelParams.name == 'YoutubePlayer') {
              channelParams.onMessageReceived(
                JavaScriptMessage(message: event.data),
              );
            }
          },
        );
      },
    );
  }
}

