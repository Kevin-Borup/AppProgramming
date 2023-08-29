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

class ImageDataHttp implements IApiImages {

  // IOS to the PC: http://localhost:port or http://127.0.0.1:port
  // Android to the PC: http://10.0.2.2:port

  late HttpClient? _httpClient = null;
  HttpClient? get httpClient => _httpClient;

  bool _certificateCheck(truststore, String host, int port){
    return false;
  }

  Future<void> _initializeHttpClient() async {
    // ByteData data = await rootBundle.load('assets/certificates/localhost+3.p12');
    // ByteData serverCert = await rootBundle.load('assets/certificates/localhost+3.pem');
    ByteData pfxData = await rootBundle.load('assets/certificates/localhost+3.pem');
    // ByteData keystore = await rootBundle.load('assets/certificates/localhost+3-key.pem');
    // List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    List<int> pfxBytes = pfxData.buffer.asUint8List();

    // var fullChain = Platform.script.resolve('assets/certificates/localhost+3.p12').toFilePath();
    // var fullChain = Platform.script.resolve('C:\\ZBC Data-Kommunikation\\H3\\AppProgrammering\\BulletinBoard\\BulletinBoardApp\assets\certificates/localhost+3.p12').toFilePath();

    SecurityContext sContext = SecurityContext(withTrustedRoots: false);
    // sContext.useCertificateChainBytes(clientCert.buffer.asUint8List());
    // sContext.usePrivateKeyBytes(keystore.buffer.asUint8List(), password: "localhostKode1234!");
    // sContext.useCertificateChain(fullChain);
    // sContext.setTrustedCertificatesBytes(data.buffer.asUint8List(), password: "localhostKode1234!");
    // sContext.setTrustedCertificatesBytes(serverCert.buffer.asUint8List(), password: "localhostKode1234!");
    sContext.useCertificateChainBytes(pfxBytes, password: "localhostKode1234!");
    sContext.usePrivateKeyBytes(pfxBytes, password: "localhostKode1234!");
    // sContext.setClientAuthoritiesBytes(data.buffer.asUint8List(), password: "localhostKode1234!");
    _httpClient = HttpClient(context: sContext)..badCertificateCallback = (_certificateCheck);
  }

  //Mix these urls to create 2 endpoints, 2 categories for board models, and image list.
  final String _baseURL = 'https://10.0.2.2:32773/api/Bulletin';
  final String _imgMdlEndPoint = '/ImgMdl';
  final String _imgEndPoint = '/Img';

  //ImgMdls
  @override
  Future<List<ImageModel>> getAllImageModels() async {
    if(httpClient == null){
      await _initializeHttpClient();
    }

    final request = await httpClient!.getUrl(Uri.parse(_baseURL + _imgMdlEndPoint));

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
    if(httpClient == null){
      await _initializeHttpClient();
    }
    final request = await httpClient!.postUrl(Uri.parse(_baseURL + _imgMdlEndPoint));
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
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
    if(httpClient == null){
      await _initializeHttpClient();
    }

    final request = await httpClient!.putUrl(Uri.parse(_baseURL + _imgMdlEndPoint));
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
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
    if(httpClient == null){
      await _initializeHttpClient();
    }
    final request = await httpClient!.deleteUrl(Uri.parse("$_baseURL$_imgMdlEndPoint/${imgMdl.dbID}"));

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
    if(httpClient == null){
      await _initializeHttpClient();
    }
    final request = await httpClient!.deleteUrl(Uri.parse("$_baseURL$_imgMdlEndPoint""All"));
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');

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
    if(httpClient == null){
      await _initializeHttpClient();
    }
    final request = await httpClient!.getUrl(Uri.parse(_baseURL + _imgEndPoint));

    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      String responseBody = await response.transform(utf8.decoder).join();

      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<Image> imgs = (json.decode(responseBody) as List)
          .map((json) => Image.memory(base64.decode(json['Image64']))).toList();

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
    final result = <String, dynamic>{};
    result.addAll({'Image64': base64.encode(img)});

    if(httpClient == null){
      await _initializeHttpClient();
    }
    final request = await httpClient!.postUrl(Uri.parse(_baseURL + _imgEndPoint));
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
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
    if(httpClient == null){
      await _initializeHttpClient();
    }
    final request = await httpClient!.deleteUrl(Uri.parse(_baseURL + _imgEndPoint));
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
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
    if(httpClient == null){
      await _initializeHttpClient();
    }
    final request = await httpClient!.deleteUrl(Uri.parse("$_baseURL$_imgEndPoint""All"));
    request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');

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