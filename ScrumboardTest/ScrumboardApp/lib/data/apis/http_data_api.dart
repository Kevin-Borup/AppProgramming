import 'dart:convert';
import 'dart:io';

import 'package:scrumboard_app/models/card_model.dart';

import 'http_client_service.dart';
import 'http_token_service.dart';

class HttpDataApi {
  // IOS to the PC: http://localhost:port or http://127.0.0.1:port
  // Android to the PC: http://10.0.2.2:port

  late final HttpClientService _httpClientService;
  late final HttpTokenService _httpTokenService;
  late bool _isHttpInitialized = false;

  //Mix these urls to create 2 endpoints, 2 categories for board models, and image list.
  final String _baseURL = 'https://10.0.2.2:32773/api/Scrumboard';
  final String _cardMdlEndPoint = '/CardMdl';

  Future<void> _initializeHttpService() async {
    if (_isHttpInitialized) return;

    _httpClientService = await HttpClientService().init();
    _httpTokenService = HttpTokenService(_httpClientService, _baseURL);
    _isHttpInitialized = true;
  }

  Future<List<CardModel>> getAllCardModels() async {
    await _initializeHttpService();
    String token = await _httpTokenService.GetAccessToken();
    final request = await _httpClientService.httpClient.getUrl(Uri.parse(_baseURL + _cardMdlEndPoint));
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
    request.headers.add(HttpHeaders.authorizationHeader, "Bearer $token");

    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      String responseBody = await response.transform(utf8.decoder).join();

      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<CardModel> cardMdls = (json.decode(responseBody) as List)
          .map((i) => CardModel.fromJson(i)).toList();

      return cardMdls;

    } else {
      throw Exception('[ERROR] Failed to get - response code: ${response.statusCode}');
    }
  }

}