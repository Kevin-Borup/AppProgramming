import 'package:appflowy_board/appflowy_board.dart';

class CardModel extends AppFlowyGroupItem {
  final String title;
  final String text;
  final String date;

  CardModel({required this.title, required this.text, required this.date});

  @override
  String get id => title;

  factory CardModel.fromJson(Map<String, dynamic> json){
    return CardModel(title: json['title'], text: json['text'], date: json['date']);
  }
}
