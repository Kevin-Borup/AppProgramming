import 'dart:convert';

import 'package:appflowy_board/appflowy_board.dart';

class CardModel extends AppFlowyGroupItem {
  late String? _id;
  final String title;
  final String text;
  final String date;

  @override
  String get id => _id ?? "";

  CardModel({required this.title, required this.text, required this.date});

  factory CardModel.fromJson(Map<String, dynamic> json){
    return CardModel(title: json['title'], text: json['text'], date: json['date']);
  }

  String toJson() => json.encode((toMap()));

  Map<String, dynamic> toMap() {
    final mapped = <String, dynamic>{};

    if (_id != null) mapped.addAll({'_id': _id});
    mapped.addAll({'title': title});
    mapped.addAll({'text': text});
    mapped.addAll({'date': date});

    return mapped;
  }
}
