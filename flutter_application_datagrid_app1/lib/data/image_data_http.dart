import 'dart:convert';
import 'package:flutter_application_datagrid_app1/models/models.dart';
import 'package:http/http.dart' as http;

class ImageDataHttp {
  // IOS to the PC: http://localhost:port or http://127.0.0.1:port
  // Android to the PC: http://10.0.2.2:port

  final String _baseURL = 'http://10.0.2.2:32769/api/FlutDatagrid';

  Future<List<PictureContainer>> getPicCons() async {
    final response = await http.get(Uri.parse('$_baseURL/GetImages'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Iterable l = json.decode(response.body);
      List<PictureContainer> picCons = List<PictureContainer>.from(
          l.map((model) => PictureContainer.fromJson(model)));
      return picCons;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load images');
    }
  }

  void postPictureContainer(PictureContainer picCon) async {
    final response = await http.post(
                Uri.parse('$_baseURL/PostImage'),
                headers: <String, String>{ 'Content-Type': 'application/json; charset=UTF-8'},
                body: picCon.toJson());

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to send image');
    }
  }
}
