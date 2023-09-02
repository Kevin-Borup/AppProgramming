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
      child: Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(
                      widget.card.title,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.start,
                    ))
                    ,
                    IconButton(
                        onPressed: () {
                          cardBloc.add(DeleteCardEvent(widget.card));
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 5, bottom: 2.5),
                child: Text(widget.card.text,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center),
              ),
              Container(
                padding: const EdgeInsets.only(top: 2.5),
                child: Text(
                  widget.card.date,
                  style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.end,
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
