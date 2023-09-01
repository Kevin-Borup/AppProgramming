import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scrumboard_app/data/blocs/card_bloc.dart';
import 'package:scrumboard_app/events/card_events.dart';
import 'package:scrumboard_app/models/card_model.dart';

class TextCardFormWidget extends StatefulWidget {
  const TextCardFormWidget(
      {super.key, required this.columnId, this.card = null});

  final String columnId;
  final CardModel? card;

  @override
  State<TextCardFormWidget> createState() => _TextCardFormWidgetState();
}

class _TextCardFormWidgetState extends State<TextCardFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final textController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CardBloc cardBloc = BlocProvider.of<CardBloc>(context);

    if (widget.card != null) {
      CardModel cardToEdit = widget.card!;
      titleController.text = cardToEdit.title;
      textController.text = cardToEdit.text;
      dateController.text = cardToEdit.date;
    }

    return AlertDialog(
      title: const Text("Create card"),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return "A title is required";
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: "Enter title", hintText: "Type title here..."),
            ),
            TextFormField(
              expands: false,
              maxLines: 3,
              controller: textController,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return "text is required";
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelText: "Enter text", hintText: "Type text here..."),
            ),
            TextField(
                controller: dateController,
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), labelText: "Enter Date"),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    dateController.text =
                        DateFormat('h:mm a - MMM d, y').format(pickedDate);
                  }
                })
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (widget.card == null) {
                  var newCard = CardModel(
                      title: titleController.text,
                      text: textController.text,
                      date: dateController.text);

                  newCard.updateColumnId(widget.columnId);
                  cardBloc.add(PostCardEvent(newCard));
                  Navigator.pop(context);
                } else {
                  var cardToUpdate = widget.card!;

                  cardToUpdate.title = titleController.text;
                  cardToUpdate.text = textController.text;
                  cardToUpdate.text = dateController.text;
                  cardBloc.add(UpdateCardEvent(cardToUpdate));
                  Navigator.pop(context);
                }
              }
            },
            child: const Text("Add"))
      ],
    );
  }
}
