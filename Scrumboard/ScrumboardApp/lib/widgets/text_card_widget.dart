import 'package:flutter/material.dart';

import '../models/card_model.dart';

class TextCardWidget extends StatefulWidget {
  final CardModel item;

  const TextCardWidget({
    required this.item,
    Key? key,
  }) : super(key: key);

  @override
  State<TextCardWidget> createState() => _RichTextCardState();
}

class _RichTextCardState extends State<TextCardWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.title,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Text(widget.item.text,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center),
            const SizedBox(height: 5),
            Text(
              widget.item.date,
              style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.end,
            )
          ],
        ),
      ),
    );
  }
}
