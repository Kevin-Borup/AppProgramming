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
  late List<BoardColumnModel> columns;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: const Expanded(
        child: Placeholder()
      ),
    );
  }
}