import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'http_client_service.dart';

class HttpTokenService{
  HttpTokenService(HttpClientService httpService, String baseUrl){
    _httpService = httpService;
    _baseUrl = baseUrl;
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  late final _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  final String _storageTokenKey = "tokenKey";

  late final HttpClientService _httpService;
  late final String _baseUrl;


  Future<String> GetAccessToken() async {
    String token = await _readTokenSecureStorage();

    if (token == ""){
      token = await _getAccessTokenServer();
    }

    return token;
  }

  Future<String> _getAccessTokenServer() async {
    final login = <String, dynamic>{};
    login.addAll({"username": "TestName"});
    login.addAll({"password": "TestPass"});

    var request = await _httpService.httpClient.postUrl(Uri.parse("$_baseUrl/Authentication/Login"));
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
    request.add(utf8.encode(json.encode(login)));

    var response = await request.close();
    if (response.statusCode == 200) {
      String responseBody = await response.transform(utf8.decoder).join();
      String token = json.decode(responseBody)['fullToken'];

      _writeTokenSecureStorage(token);

      return token;
    }else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      String error = '[ERROR] Failed to get Token - response code: ${response.statusCode}';
      if (kDebugMode) {
        print(error);
      }
      throw Exception(error);
    }
  }

  Future<void> _writeTokenSecureStorage(String token) async {
    await _storage.delete(key: _storageTokenKey);
    await _storage.write(key: _storageTokenKey, value: token);
  }

  Future<String> _readTokenSecureStorage() async {
    return await _storage.read(key: _storageTokenKey) ?? "";
  }
}