import 'board_note_model.dart';

class BoardColumnModel {
  BoardColumnModel(this.title, this.id);

  final String title;
  final String id;
  late List<BoardNoteModel> notes;


}