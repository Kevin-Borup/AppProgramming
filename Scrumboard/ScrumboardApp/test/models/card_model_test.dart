import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrumboard_app/models/card_model.dart';

void main() {
  group("Testing Card Model", () {
    test('Testing to Map', () async {
      CardModel cardMdl = CardModel(title: "UI", text: "UX improvement", date: "23/04-23");
      cardMdl.columnId = "1ToDo";
      cardMdl.assignedName = "Kevin";
      var cardMap = cardMdl.toMap();

      expect(cardMap, isNotNull);
      expect(cardMap['_id'], null); // cardMdl.id should be null, until received from DB.
      expect(cardMap['title'], isA<String>());
      expect(cardMap['columnId'], "1ToDo");
      expect(cardMap['date'], isA<String>());
    });
  });
}