// Copyright 2022 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'platform_view_stub.dart' if (dart.library.html) 'dart:ui' as ui;
import 'youtube_web_controller.dart';

/// An implementation of [PlatformWebViewWidget] using Flutter the for Web API.
class YoutubeWebPlayer extends PlatformWebViewWidget {
  /// Constructs a [YoutubeWebPlayer].
  YoutubeWebPlayer(PlatformWebViewWidgetCreationParams params)
      : _controller = params.controller as YoutubeWebController,
        super.implementation(params) {
    ui.platformViewRegistry.registerViewFactory(
      _controller.creationParams.ytiFrame.id,
      (int viewId) => _controller.creationParams.ytiFrame,
    );
  }

  final YoutubeWebController _controller;

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      key: params.key,
      viewType: (params.controller as YoutubeWebController).creationParams.ytiFrame.id,
      onPlatformViewCreated: (_) {
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
