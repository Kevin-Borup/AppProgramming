import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:bulletin_board_app/data/models/image_model.dart';
import 'package:bulletin_board_app/interfaces/i_api_images.dart';
import 'package:http/http.dart' as http;

class ImageDataHttp implements IApiImages {
  // IOS to the PC: http://localhost:port or http://127.0.0.1:port
  // Android to the PC: http://10.0.2.2:port

  //Mix these urls to create 2 endpoints, 2 categories for board models, and image list.
  final String _baseURL = 'http://10.0.2.2:32772/api/Bulletin';
  final String _imgMdlEndPoint = '/ImgMdl';
  final String _imgEndPoint = '/Img';

  //ImgMdls
  @override
  Future<List<ImageModel>> getAllImageModels() async {
    final response = await http.get(Uri.parse(_baseURL + _imgMdlEndPoint));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<ImageModel> imgMdls = (json.decode(response.body) as List)
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
    final response = await http.post(Uri.parse(_baseURL + _imgMdlEndPoint),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: imgMdl.toJson());

    if (response.statusCode == 201) {
      // If the server did return a 201 ADDED response.
      //Get updated ImageModel with an ID
      ImageModel updatedImgMdl = ImageModel.fromJson(json.decode(response.body));

      return updatedImgMdl;

    } else {
      // If the server did not return a 201 ADDED response,
      // then throw an exception.
      throw Exception(
          "[ERROR] Failed to send - response code: ${response.statusCode}");
    }
  }

  @override
  void updateImageModel(ImageModel imgMdl) async {
    final response = await http.put(Uri.parse(_baseURL + _imgMdlEndPoint),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: imgMdl.toJson());

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response.
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          "[ERROR] Failed to update - response code: ${response.statusCode}");
    }
  }

  @override
  void deleteImageModel(ImageModel imgMdl) async { //Url parameter to directly specify ID, instead of a Json body
    final response = await http.delete(Uri.parse("$_baseURL$_imgMdlEndPoint/${imgMdl.dbID}"),
        headers: <String, String>{'Content-Type': 'application/json'});

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
    final response = await http.delete(Uri.parse("$_baseURL$_imgMdlEndPoint""All"),
        headers: <String, String>{'Content-Type': 'application/json'});

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
    final response = await http.get(Uri.parse(_baseURL + _imgEndPoint));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<Image> imgs = (json.decode(response.body) as List)
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

    final response = await http.post(Uri.parse(_baseURL + _imgEndPoint),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(result));

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
    final response = await http.delete(Uri.parse(_baseURL + _imgEndPoint),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: base64.encode(img));

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
    final response = await http.delete(Uri.parse("$_baseURL$_imgEndPoint""All"),
        headers: <String, String>{'Content-Type': 'application/json'});

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