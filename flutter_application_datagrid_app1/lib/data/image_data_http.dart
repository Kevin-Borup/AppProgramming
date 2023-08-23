import 'dart:convert';

import 'package:flutter_application_datagrid_app1/models/models.dart';
import 'package:http/http.dart' as http;

class ImageDataHttp {
  Future<List<PictureContainer>> fetchPictureContainers() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

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
        Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
        body: picCon);

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
