import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scrumboard_app/data/blocs/card_bloc.dart';
import 'package:scrumboard_app/events/card_events.dart';
import 'package:scrumboard_app/models/card_model.dart';

class TextCardFormWidget extends StatefulWidget {
  const TextCardFormWidget({super.key});

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

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                  labelText: "Enter title", hintText: "Type title here..."),
            ),
            TextFormField(
              controller: textController,
              decoration: const InputDecoration(
                  labelText: "Enter text", hintText: "Type text here..."),
            ),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: "Enter date",
                hintText: "Input date here",
              ),
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
              },
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                ElevatedButton(
                    onPressed: () {
                      cardBloc.add(PostCardEvent(CardModel(
                          title: titleController.text,
                          text: textController.text,
                          date: dateController.text)));
                    },
                    child: const Text("Add"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
