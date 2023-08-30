import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';

import '../data/models/board_column_model.dart';
import '../data/models/board_note_model.dart';

class ScrumBoardScreen extends StatefulWidget {
  const ScrumBoardScreen({super.key});

  @override
  State<ScrumBoardScreen> createState() => _ScrumBoardScreenState();
}

class _ScrumBoardScreenState extends State<ScrumBoardScreen> {
  final AppFlowyBoardController boardData = AppFlowyBoardController();
  late List<BoardColumnModel> columns;

  @override
  void initState() {
    for (var column in columns) {
      final newColumn = AppFlowyGroupData(
          id: column.id,
          name: column.title,
          items: column.notes
              .map((BoardNoteModel note) => TextItem(note.richedText))
              .toList());

      boardData.addGroup(newColumn);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Expanded(
        child: AppFlowyBoard(
          controller: boardData,
          cardBuilder: (context, column, columnItem) {
            final textItem = columnItem as TextItem;
            return AppFlowyGroupCard(
              key: const ObjectKey(TextItem),
              child: Padding(padding: const EdgeInsets.fromLTRB(7, 2, 7, 2),  child: RichText(text: TextSpan(text: textItem.s))),
            );
          },
        ),
      ),
    );
  }
}

class TextItem extends AppFlowyGroupItem {
  final String s;

  TextItem(this.s);

  @override
  String get id => s;
}
