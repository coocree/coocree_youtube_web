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


/// Implementação de [PlatformWebViewController] usando a API Flutter para Web.
class YoutubeWebController extends PlatformWebViewController {
  /// Construtor para a classe [YoutubeWebController].
  YoutubeWebController(
    PlatformWebViewControllerCreationParams params,
  ) : super.implementation(
          params is YoutubeWebParams
              ? params
              : YoutubeWebParams.fromPlatformWebViewControllerCreationParams(params),
        );

  /// Retorna os parâmetros de criação para o [YoutubeWebController].
  YoutubeWebParams get creationParams {
    return params as YoutubeWebParams;
  }

  /// Parâmetros para o canal de JavaScript.
  late final JavaScriptChannelParams javaScriptChannelParams;

  /// Carrega uma string HTML no WebView do [YoutubeWebController].
  ///
  /// Caso o navegador não suporte srcdoc, uma string codificada em URI será usada como fallback.
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

  /// Executa código JavaScript na WebView do [YoutubeWebController].
  ///
  /// Usa o canal de JavaScript para enviar uma mensagem para a WebView com o código JavaScript.
  @override
  Future<void> runJavaScript(String javaScript) {
    final function = javaScript.replaceAll('"', '<<quote>>');
    creationParams.ytiFrame.contentWindow?.postMessage(
      '{"key": null, "function": "$function"}',
      '*',
    );

    return SynchronousFuture(null);
  }

  /// Executa código JavaScript na WebView do [YoutubeWebController] e retorna o resultado.
  ///
  /// Usa o canal de JavaScript para enviar uma mensagem para a WebView com o código JavaScript e espera por uma resposta com o resultado.
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


  /// /// Adiciona um canal de JavaScript ao [YoutubeWebController].
  @override
  Future<void> addJavaScriptChannel(
    JavaScriptChannelParams params,
  ) async {
    javaScriptChannelParams = params;
  }

  /// Define o modo de JavaScript para o [YoutubeWebController].
  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {
    // no-op
  }

  /// Define o delegado de navegação de plataforma para o [YoutubeWebController].
  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {
    // no-op
  }

  /// Define o agente do usuário para o [YoutubeWebController].
  @override
  Future<void> setUserAgent(String? userAgent) async {
    // no-op
  }

  /// Habilita/desabilita o zoom para o [YoutubeWebController].
  @override
  Future<void> enableZoom(bool enabled) async {
    // no-op
  }

  /// Define a cor de fundo para o [YoutubeWebController].
  @override
  Future<void> setBackgroundColor(Color color) async {
    // no-op
  }
}
