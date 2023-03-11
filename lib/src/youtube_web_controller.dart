// Copyright 2022 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'youtube_web_params.dart';

/// An implementation of [PlatformWebViewController] using Flutter for Web API.
class YoutubeWebController extends PlatformWebViewController {
  /// Constructs a [YoutubeWebController].
  YoutubeWebController(
    PlatformWebViewControllerCreationParams params,
  ) : super.implementation(
          params is YoutubeWebParams
              ? params
              : YoutubeWebParams.fromPlatformWebViewControllerCreationParams(params),
        );

  YoutubeWebParams get creationParams {
    return params as YoutubeWebParams;
  }

  late final JavaScriptChannelParams javaScriptChannelParams;

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) {
    creationParams.ytiFrame.srcdoc = html;

    // Fallback for browser that doesn't support srcdoc.
    creationParams.ytiFrame.src = Uri.dataFromString(
      html,
      mimeType: 'text/html',
      encoding: utf8,
    ).toString();

    return SynchronousFuture(null);
  }

  @override
  Future<void> runJavaScript(String javaScript) {
    final function = javaScript.replaceAll('"', '<<quote>>');
    creationParams.ytiFrame.contentWindow?.postMessage(
      '{"key": null, "function": "$function"}',
      '*',
    );

    return SynchronousFuture(null);
  }

  @override
  Future<String> runJavaScriptReturningResult(String javaScript) async {
    final contentWindow = creationParams.ytiFrame.contentWindow;
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    final function = javaScript.replaceAll('"', '<<quote>>');

    final completer = Completer<String>();
    final subscription = window.onMessage.listen(
      (event) {
        final data = jsonDecode(event.data);

        if (data is Map && data.containsKey(key)) {
          completer.complete(data[key].toString());
        }
      },
    );

    contentWindow?.postMessage(
      '{"key": "$key", "function": "$function"}',
      '*',
    );

    final result = await completer.future;
    subscription.cancel();

    return result;
  }

  @override
  Future<void> addJavaScriptChannel(
    JavaScriptChannelParams params,
  ) async {
    javaScriptChannelParams = params;
  }

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {
    // no-op
  }

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {
    // no-op
  }

  @override
  Future<void> setUserAgent(String? userAgent) async {
    // no-op
  }

  @override
  Future<void> enableZoom(bool enabled) async {
    // no-op
  }

  @override
  Future<void> setBackgroundColor(Color color) async {
    // no-op
  }
}
