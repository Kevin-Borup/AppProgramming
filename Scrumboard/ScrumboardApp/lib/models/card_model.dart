import 'dart:convert';

import 'package:appflowy_board/appflowy_board.dart';
import 'package:uuid/uuid.dart';

class CardModel extends AppFlowyGroupItem {
  late String? _id = null;
  final String tempId = const Uuid().v4();
  late String columnId;
  late String title;
  late String text;
  late String date;
  late String assignedName = "";

  @override
  String get id => _id ?? tempId; //temp id for AppFlowy

  CardModel({required this.title, required this.text, required this.date});

  void updateColumnId(String newColumnId){
    columnId = newColumnId;
  }

  factory CardModel.fromJson(Map<String, dynamic> json){
    var newCard = CardModel(title: json['title'], text: json['text'], date: json['date']);
    newCard._id = json['id'];
    newCard.columnId = json['columnId'];
    return newCard;
  }

  String toJson() => json.encode((toMap()));

  Map<String, dynamic> toMap() {
    final mapped = <String, dynamic>{};

    if (_id != null) mapped.addAll({'_id': _id});
    mapped.addAll({'columnId': columnId});
    mapped.addAll({'title': title});
    mapped.addAll({'text': text});
    mapped.addAll({'date': date});

    return mapped;
  }
}
