import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';

class BoardColumnWidget extends StatefulWidget {
  const BoardColumnWidget({super.key});

  @override
  State<BoardColumnWidget> createState() => _BoardColumnWidgetState();
}

class _BoardColumnWidgetState extends State<BoardColumnWidget> {
  final AppFlowyBoardController boardData = AppFlowyBoardController();

  @override
  void initState() {
    final columnToDo = AppFlowyGroupData(id: "todo", name: "To-Do", items: [
      TextItem("make UI"),
      TextItem("normalize SQL"),
      TextItem("verify certificates")
    ]);
    final columnInProgress = AppFlowyGroupData(id: "progress", name: "In Progress", items: [
      TextItem("logic"),
      TextItem("create users")
    ]);


    boardData.addGroup(columnToDo);
    boardData.addGroup(columnInProgress);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppFlowyBoard(
      controller: boardData,
      cardBuilder: (context, column, columnItem) {
        return _RowWidget(
            item: columnItem as TextItem, key: ObjectKey(columnItem));
      },
    );
  }
}

class _RowWidget extends StatelessWidget {
  final TextItem item;

  const _RowWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ObjectKey(item),
      height: 60,
      color: Colors.green,
      child: Center(child: Text(item.s)),
    );
  }
}

class TextItem extends AppFlowyGroupItem {
  final String s;

  TextItem(this.s);

  @override
  String get id => s;
}
