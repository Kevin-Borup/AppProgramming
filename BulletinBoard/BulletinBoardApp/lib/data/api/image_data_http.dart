import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bulletin_board_app/data/api/http_client_service.dart';
import 'package:flutter/material.dart';
import 'package:bulletin_board_app/data/models/image_model.dart';
import 'package:bulletin_board_app/interfaces/i_api_images.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../services/service_locator.dart';
import 'http_token_service.dart';

class ImageDataHttp implements IApiImages {

  // IOS to the PC: http://localhost:port or http://127.0.0.1:port
  // Android to the PC: http://10.0.2.2:port

  late final HttpClientService _httpClientService;
  late final HttpTokenService _httpTokenService;
  late bool _isHttpInitialized = false;

  //Mix these urls to create 2 endpoints, 2 categories for board models, and image list.
  final String _baseURL = 'https://10.0.2.2:32773/api/Bulletin';
  final String _imgMdlEndPoint = '/ImgMdl';
  final String _imgEndPoint = '/Img';

  Future<void> _initializeHttpService() async {
    if (_isHttpInitialized) return;

    _httpClientService = await HttpClientService().init();
    _httpTokenService = HttpTokenService(_httpClientService, _baseURL);
    _isHttpInitialized = true;
  }

  //ImgMdls
  @override
  Future<List<ImageModel>> getAllImageModels() async {
    await _initializeHttpService();
    String token = await _httpTokenService.GetAccessToken();
    final request = await _httpClientService.httpClient.getUrl(Uri.parse(_baseURL + _imgMdlEndPoint));
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
    request.headers.add(HttpHeaders.authorizationHeader, "Bearer $token");

    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      String responseBody = await response.transform(utf8.decoder).join();

      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<ImageModel> imgMdls = (json.decode(responseBody) as List)
          .map((i) => ImageModel.fromJson(i)).toList();

      return imgMdls;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          '[ERROR] Failed to get - response code: ${response.statusCode}');
    }
  }

  @override
  Future<ImageModel> postImageModel(ImageModel imgMdl) async {
    await _initializeHttpService();
    String token = await _httpTokenService.GetAccessToken();
    final request = await _httpClientService.httpClient.postUrl(Uri.parse(_baseURL + _imgMdlEndPoint));
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
    request.headers.add(HttpHeaders.authorizationHeader, "Bearer $token");
    request.add(utf8.encode(imgMdl.toJson()));

    HttpClientResponse response = await request.close();

    if (response.statusCode == 201) {
      String responseBody = await response.transform(utf8.decoder).join();

      // If the server did return a 201 ADDED response.
      ImageModel newImgMdl = ImageModel.fromJson(json.decode(responseBody));

      return newImgMdl;

    } else {
      // If the server did not return a 201 ADDED response,
      // then throw an exception.
      throw Exception(
          "[ERROR] Failed to send - response code: ${response.statusCode}");
    }
  }

  @override
  Future<ImageModel> updateImageModel(ImageModel imgMdl) async {
    await _initializeHttpService();
    String token = await _httpTokenService.GetAccessToken();
    final request = await _httpClientService.httpClient.putUrl(Uri.parse(_baseURL + _imgMdlEndPoint));
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
    request.headers.add(HttpHeaders.authorizationHeader, "Bearer $token");
    request.add(utf8.encode(imgMdl.toJson()));

    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      String responseBody = await response.transform(utf8.decoder).join();

      // If the server did return a 200 OK response.
      //Get updated ImageModel with an ID
      ImageModel updatedImgMdl = ImageModel.fromJson(json.decode(responseBody));

      return updatedImgMdl;

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          "[ERROR] Failed to update - response code: ${response.statusCode}");
    }
  }

  @override
  void deleteImageModel(ImageModel imgMdl) async { //Url parameter to directly specify ID, instead of a Json body
    await _initializeHttpService();
    String token = await _httpTokenService.GetAccessToken();
    final request = await _httpClientService.httpClient.deleteUrl(Uri.parse("$_baseURL$_imgMdlEndPoint/${imgMdl.dbID}"));
    request.headers.add(HttpHeaders.authorizationHeader, "Bearer $token");

    HttpClientResponse response = await request.close();


    if (response.statusCode == 200) {
      // If the server did return a 200 OK response.
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          "[ERROR] Failed to delete - response code: ${response.statusCode}");
    }
  }

  @override
  void deleteAllImageModels() async { //Url extended with all, to lower chance of accidentally calling this endpoint
    await _initializeHttpService();
    String token = await _httpTokenService.GetAccessToken();
    final request = await _httpClientService.httpClient.deleteUrl(Uri.parse("$_baseURL$_imgMdlEndPoint""All"));
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
    request.headers.add(HttpHeaders.authorizationHeader, "Bearer $token");


    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response.
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          "[ERROR] Failed to delete - response code: ${response.statusCode}");
    }
  }

  //Img
  @override
  Future<List<Image>> getAllImages() async {
    await _initializeHttpService();
    String token = await _httpTokenService.GetAccessToken();
    final request = await _httpClientService.httpClient.getUrl(Uri.parse(_baseURL + _imgEndPoint));
    request.headers.add(HttpHeaders.authorizationHeader, "Bearer $token");


    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      String responseBody = await response.transform(utf8.decoder).join();

      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<Image> imgs = (json.decode(responseBody) as List)
          .map((json) => Image.memory(base64.decode(json['image64']))).toList();

      return imgs;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          "[ERROR] Failed to get - response code: ${response.statusCode}");
    }
  }

  @override
  void postImage(Uint8List img) async {
    await _initializeHttpService();
    String token = await _httpTokenService.GetAccessToken();

    final result = <String, dynamic>{};
    result.addAll({'Image64': base64.encode(img)});

    final request = await _httpClientService.httpClient.postUrl(Uri.parse(_baseURL + _imgEndPoint));
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
    request.headers.add(HttpHeaders.authorizationHeader, "Bearer $token");
    request.add(utf8.encode(json.encode(result)));

    HttpClientResponse response = await request.close();

    if (response.statusCode == 201) {
      // If the server did return a 201 ADDED response.
    } else {
      // If the server did not return a 201 ADDED response,
      // then throw an exception.
      throw Exception(
          "[ERROR] Failed to send - response code: ${response.statusCode}");
    }
  }

  @override
  void deleteImage(Uint8List img) async {
    await _initializeHttpService();
    String token = await _httpTokenService.GetAccessToken();
    final request = await _httpClientService.httpClient.deleteUrl(Uri.parse(_baseURL + _imgEndPoint));
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
    request.headers.add(HttpHeaders.authorizationHeader, "Bearer $token");
    request.add(utf8.encode(base64.encode(img)));

    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response.
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          "[ERROR] Failed to send - response code: ${response.statusCode}");
    }
  }

  @override
  void deleteAllImages() async {  //Url extended with all, to lower chance of accidentally calling this endpoint
    await _initializeHttpService();
    String token = await _httpTokenService.GetAccessToken();
    final request = await _httpClientService.httpClient.deleteUrl(Uri.parse("$_baseURL$_imgEndPoint""All"));
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
    request.headers.add(HttpHeaders.authorizationHeader, "Bearer $token");

    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response.
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          "[ERROR] Failed to send - response code: ${response.statusCode}");
    }
  }
}