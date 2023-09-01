import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrumboard_app/data/blocs/card_bloc.dart';
import 'package:scrumboard_app/data/blocs/states/card_states.dart';
import 'package:scrumboard_app/models/card_model.dart';
import 'package:scrumboard_app/widgets/text_card_form_widget.dart';
import 'package:scrumboard_app/widgets/text_card_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScrumBoardScreen extends StatefulWidget {
  const ScrumBoardScreen({super.key});

  @override
  State<ScrumBoardScreen> createState() => _ScrumBoardScreenState();
}

class _ScrumBoardScreenState extends State<ScrumBoardScreen> {
  late final SharedPreferences prefs;

  late final AppFlowyBoardController boardController;
  late AppFlowyBoardScrollController boardScrollController;
  final AppFlowyBoardConfig boardConfig = const AppFlowyBoardConfig(
    groupBackgroundColor: Color.fromRGBO(242, 242, 242, 0.8),
    stretchGroupHeight: true,
  );

  void _confirmationDialog(
      String fromGroupId, int fromIndex, String toGroupId, int toIndex) async {
    // The group receiving a note is found by searching for the first one occurring with the same id.
    var toGroup =
        boardController.groupDatas.firstWhere((group) => group.id == toGroupId);

    var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Move'),
          content: Text(
              'Do you wish to move the card back to ${toGroup.headerData.groupName}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            const SizedBox(
              width: 70,
              height: 20,
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (result is bool) {
      if (!result) {
        //since controller.onMoveGroupItemToGroup is protected and not working as intended, this had to be configured
        // The note in question is found by selecting the item on the index.
        var note = toGroup.items[toIndex];

        // The note is then removed
        boardController.removeGroupItem(toGroupId, note.id);

        // The note is added back to the previous column
        boardController.addGroupItem(fromGroupId, note);

        // The note is then moved to the previous index, it'll currently be at the end, therefore length-1 gets its index, then transferred to the previous one.
        boardController.moveGroupItem(
            fromGroupId,
            boardController.groupDatas
                    .firstWhere((group) => group.id == fromGroupId)
                    .items
                    .length -
                1,
            fromIndex);
      }
    }
  }

  @override
  void initState() {
    boardController = AppFlowyBoardController(onMoveGroupItemToGroup:
        (String fromGroupId, int fromIndex, String toGroupId, int toIndex) {
      int fromGroupNum = int.parse(fromGroupId.characters.first);
      int toGroupNum = int.parse(toGroupId.characters.first);

      if (fromGroupNum > toGroupNum) {
        _confirmationDialog(fromGroupId, fromIndex, toGroupId, toIndex);
      }
    });

    boardScrollController = AppFlowyBoardScrollController();

    final groupBckLg = AppFlowyGroupData(
      id: "0Backlog",
      name: "Backlog",
    );

    final groupToDo = AppFlowyGroupData(
      id: "1ToDo",
      name: "To Do",
    );

    final groupInProgress = AppFlowyGroupData(
      id: "2InProgress",
      name: "In Progress",
    );

    final groupDone = AppFlowyGroupData(
      id: "3Done",
      name: "Done",
    );

    groupBckLg.draggable = false;
    groupToDo.draggable = false;
    groupInProgress.draggable = false;
    groupDone.draggable = false;

    boardController.addGroup(groupBckLg);
    boardController.addGroup(groupToDo);
    boardController.addGroup(groupInProgress);
    boardController.addGroup(groupDone);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CardBloc cardBloc = BlocProvider.of<CardBloc>(context);
    late double columnWidth = (MediaQuery.of(context).size.width / 1.3);
    if (columnWidth > 400) columnWidth = 400;

    return ShaderMask(
      shaderCallback: (Rect rect) {
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.purple,
            Colors.transparent,
            Colors.transparent,
            Colors.purple
          ],
          stops: [
            0.0,
            0.1,
            0.9,
            1.0
          ], // 10% purple, 80% transparent, 10% purple
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: BlocBuilder<CardBloc, CardState>(
          builder: (blocContext, CardState state) {
            state.cards.map((CardModel card) =>
                boardController.addGroupItem(card.columnId, card));

            return AppFlowyBoard(
                controller: boardController,
                //Header
                headerBuilder: (context, columnData) {
                  return AppFlowyGroupHeader(
                    title: Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            columnData.headerData.groupName,textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),

                          ),
                          Divider(height: 2, color: Colors.grey.withOpacity(0.9),)
                        ],
                      )
                    ),
                    height: 50,
                    margin: boardConfig.groupItemPadding,
                  );
                },
                //Body
                cardBuilder: (context, group, groupItem) {
                  final card = groupItem as CardModel;
                  return BlocProvider.value(
                    value: cardBloc,
                    child: AppFlowyGroupCard(
                      key: ValueKey(groupItem.id),
                      child: TextCardWidget(card: card),
                    ),
                  );
                },
                //Footer
                footerBuilder: (context, columnData) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: AppFlowyGroupFooter(
                      icon: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                      title: const Text(
                        'New',
                        style: TextStyle(fontSize: 20),
                      ),
                      height: 50,
                      margin: boardConfig.groupItemPadding,
                      onAddButtonClick: () {
                        showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return BlocProvider.value(
                                value: cardBloc,
                                child: TextCardFormWidget(
                                  columnId: columnData.id,
                                ),
                              );
                            });

                        boardScrollController.scrollToBottom(columnData.id);
                      },
                    ),
                  );
                },
                boardScrollController: boardScrollController,
                groupConstraints: BoxConstraints.tightFor(
                    width: columnWidth),
                config: boardConfig);
          },
        ),
      ),
    );
  }
}
