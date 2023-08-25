import 'package:flutter/material.dart';

class GalleryWidget extends StatefulWidget {
  GalleryWidget({super.key, required this.images});

  final List<Image> images;
  late bool isSelectionMode = false;
  late List<bool> selectedList = List.filled(images.length, false);

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  void _toggle(int index) {
    if (widget.isSelectionMode) {
      setState(() {
        widget.selectedList[index] = !widget.selectedList[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: widget.selectedList.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (_, int index) {
          return InkWell(
            onTap: () => _toggle(index),
            onLongPress: () {
              if (!widget.isSelectionMode) {
                setState(() {
                  widget.selectedList[index] = true;
                });
                widget.isSelectionMode = true;
              }
            },
            child: GridTile(
              child: Container(
                child: widget.isSelectionMode
                    ? Checkbox(
                        onChanged: (bool? checked) => _toggle(index),
                        value: widget.selectedList[index])
                    : widget.images[index],
              ),
            ),
          );
        });
  }
}
