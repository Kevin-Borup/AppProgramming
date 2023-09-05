import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrumboard_app/events/card_events.dart';
import 'package:scrumboard_app/widgets/text_card_form_widget.dart';

import '../data/blocs/card_bloc.dart';
import '../models/card_model.dart';

class TextCardWidget extends StatefulWidget {
  final CardModel card;

  const TextCardWidget({
    required this.card,
    Key? key,
  }) : super(key: key);

  @override
  State<TextCardWidget> createState() => _RichTextCardState();
}

class _RichTextCardState extends State<TextCardWidget> {
  @override
  Widget build(BuildContext context) {
    final CardBloc cardBloc = BlocProvider.of<CardBloc>(context);

    return GestureDetector(
      onDoubleTap: () {
        showDialog(
            context: context,
            builder: (dialogContext) {
              return BlocProvider.value(
                value: cardBloc,
                child: TextCardFormWidget(columnId: "", card: widget.card),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 2, 2, 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                    widget.card.title,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.start,
                  )),
                  IconButton(
                      onPressed: () {
                        cardBloc.add(DeleteCardEvent(widget.card));
                      },
                      icon: const Icon(Icons.delete))
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 2.5),
              child: Text(widget.card.text,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center),
            ),
            Container(
              padding: const EdgeInsets.only(top: 2.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.card.date,
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic),
                      textAlign: TextAlign.start,
                    ),),
                  Expanded(
                      child: Text(
                        widget.card.assignedName,
                        style: const TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.end,
                      ),),
                  IconButton(
                      onPressed: () {
                        setState(() { // Quick test of button
                          if(widget.card.assignedName == ""){
                            widget.card.assignedName = "Kevin";
                          }
                          else
                          {
                            widget.card.assignedName = "";
                          }
                        });
                      },
                      padding: const EdgeInsets.only(left: 2),
                      icon: const Icon(Icons.account_circle_rounded))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
