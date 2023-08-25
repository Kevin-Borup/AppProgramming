import 'dart:convert';
import 'package:bulletin_board_app/data/models/image_model.dart';
import 'package:bulletin_board_app/interfaces/i_api_images.dart';
import 'package:http/http.dart' as http;

class ImageDataHttp implements IApiImages {
  // IOS to the PC: http://localhost:port or http://127.0.0.1:port
  // Android to the PC: http://10.0.2.2:port

  final String _baseURL = 'http://10.0.2.2:32772/api/Bulletin';

  @override
  Future<List<ImageModel>> getAllImages() async {
    final response = await http.get(Uri.parse(_baseURL));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<ImageModel> imgMdls = (json.decode(response.body) as List)
          .map((i) => ImageModel.fromJson(i))
          .toList();

      return imgMdls;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          '[ERROR] Failed to get - response code: ${response.statusCode}');
    }
  }



  @override
  void postImage(ImageModel imgMdl) async {
    final response = await http.post(Uri.parse(_baseURL),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: imgMdl.toJson());

    if (response.statusCode == 201) {
      var data = json.decode(response.body);
      // If the server did return a 200 OK response,
      // then parse the JSON.
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          "[ERROR] Failed to send - response code: ${response.statusCode}");
    }
  }

  @override
  void updateImage(ImageModel imgMdl) async {
    final response = await http.put(Uri.parse("$_baseURL/Update"),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: imgMdl.toJson());

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          "[ERROR] Failed to send - response code: ${response.statusCode}");
    }
  }
}