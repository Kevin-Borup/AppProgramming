import 'dart:convert';

import 'package:bulletin_board_app/data/api/http_client_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HttpTokenService{
  HttpTokenService(HttpClientService httpService, String baseUrl){
    _httpService = httpService;
    _baseUrl = baseUrl;
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  late final _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  final String _storageTokenKey = "AnotherSuperSecretKey";

  late final HttpClientService _httpService;
  late final String _baseUrl;


  Future<String> GetAccessToken() async {
    String token = await _readTokenSecureStorage();

    if (token == ""){
      token = await _GetAccessTokenServer();
    }

    return token;
  }

  Future<String> _GetAccessTokenServer() async {
    final login = <String, dynamic>{};
    login.addAll({"username": "TestName"});
    login.addAll({"password": "TestPass"});

    var request = await _httpService.httpClient.postUrl(Uri.parse("$_baseUrl/Authentication/Login"));
    request.add(utf8.encode(json.encode(login)));

    var response = await request.close();
    if (response.statusCode == 200) {
      String responseBody = await response.transform(utf8.decoder).join();
      String token = json.decode(responseBody)['Token'];

      await _writeTokenSecureStorage(token);

      return token;
    }else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          '[ERROR] Failed to get Token - response code: ${response.statusCode}');
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