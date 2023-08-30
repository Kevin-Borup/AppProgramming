import 'package:flutter/material.dart';

class BoardNoteModel {
  late String _richedText;
  String get richedText => _richedText;

  void UpdateText(String newRichedText){
    _richedText = newRichedText;
  }
}