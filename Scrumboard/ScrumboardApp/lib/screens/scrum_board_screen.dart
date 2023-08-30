import 'package:flutter/material.dart';
import 'package:scrum_board_app/widgets/board_column_widget.dart';

class ScrumBoardScreen extends StatefulWidget {
  const ScrumBoardScreen({super.key});

  @override
  State<ScrumBoardScreen> createState() => _ScrumBoardScreenState();
}

class _ScrumBoardScreenState extends State<ScrumBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Row(
        children: [
          BoardColumnWidget()
        ],
      ),
    );
  }
}
