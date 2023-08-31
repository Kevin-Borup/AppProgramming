import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:scrumboard_app/models/card_model.dart';
import 'package:scrumboard_app/widgets/text_card_widget.dart';

class ScrumBoardScreen extends StatefulWidget {
  const ScrumBoardScreen({super.key});

  @override
  State<ScrumBoardScreen> createState() => _ScrumBoardScreenState();
}

class _ScrumBoardScreenState extends State<ScrumBoardScreen> {
  final AppFlowyBoardController controller = AppFlowyBoardController(
    onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move item from $fromIndex to $toIndex');
    },
    onMoveGroupItem: (groupId, fromIndex, toIndex) {
      debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
    },
    onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
    },
  );

  late AppFlowyBoardScrollController boardController;
  late ScrollController scrollController;

  @override
  void initState() {
    boardController = AppFlowyBoardScrollController();
    scrollController = ScrollController();

    final groupBckLg = AppFlowyGroupData(id: "BackLog", name: "BackLog", items: [
      CardModel(title: 'Test', text: "unit testing", date: 'jan 2, 2013, 1:40pm')
    ]);
    final groupToDo = AppFlowyGroupData(id: "To Do", name: "To Do", items: [
      CardModel(title: "UI", text: 'Improve UX', date: 'Aug 1, 2020 4:05 PM'),
      CardModel(title: "SQL", text: "Finish stored procedures",  date: 'Aug 1, 2020 4:05 PM'),
      CardModel(title: "API", text: "setup certificates", date: 'Aug 1, 2020 4:05 PM'),
    ]);

    final groupInProgress = AppFlowyGroupData(
      id: "In Progress",
      name: "In Progress",
      items: <AppFlowyGroupItem>[
        CardModel(title: "Users", text: "setup user system", date: 'Aug 1, 2020 4:05 PM'),
      ],
    );

    final groupDone = AppFlowyGroupData(
        id: "Done", name: "Done", items: <AppFlowyGroupItem>[]);

    groupBckLg.draggable = false;
    groupToDo.draggable = false;
    groupInProgress.draggable = false;
    groupDone.draggable = false;

    controller.addGroup(groupBckLg);
    controller.addGroup(groupToDo);
    controller.addGroup(groupInProgress);
    controller.addGroup(groupDone);


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppFlowyBoardConfig(
      groupBackgroundColor: Colors.cyan.shade300,
      stretchGroupHeight: true,

    );
    return AppFlowyBoard(
        controller: controller,
        cardBuilder: (context, group, groupItem) {
          final card = groupItem as CardModel;
          return AppFlowyGroupCard(
            key: ValueKey(groupItem.id),
            child: TextCardWidget(item: card),
          );
        },
        scrollController: scrollController,
        boardScrollController: boardController,

        footerBuilder: (context, columnData) {
          return AppFlowyGroupFooter(
            icon: const Icon(Icons.add, size: 20),
            title: const Text('New'),
            height: 50,
            margin: config.groupItemPadding,
            onAddButtonClick: () {
              boardController.scrollToBottom(columnData.id);
            },
          );
        },
        headerBuilder: (context, columnData) {
          return AppFlowyGroupHeader(
            title: Expanded(child: Text(
              columnData.headerData.groupName,
              style: const TextStyle(fontWeight: FontWeight.bold),),),
            height: 50,
            margin: config.groupItemPadding,
          );
        },
        groupConstraints: const BoxConstraints.tightFor(width: 300),
        config: config);
  }
}



