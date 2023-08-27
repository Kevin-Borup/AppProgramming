import 'package:bulletin_board_app/data/bloc/events/image_model_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

import '../data/bloc/image_model_bloc.dart';
import '../data/models/image_model.dart';

class ImageWidget extends StatefulWidget {
  ImageWidget(
      {super.key,
      required this.imgMdl,
      required this.img,
      this.position,
      this.size,
      this.ang});

  late ImageModel imgMdl;
  final Image img;
  final Offset? position;
  final Size? size;
  final double? ang;

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  late Image img;
  late Offset _offset;
  late Size size;
  late double angle;

  @override
  void initState() {
    super.initState();
    img = widget.img;
    _offset = widget.position ?? const Offset(0, 0);
    size = widget.size ?? const Size(30, 30);
    angle = widget.ang ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    img.height = img.height * 0.5;

    final ImageModelBloc imageModelBloc =
        BlocProvider.of<ImageModelBloc>(context);
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
    return SizedBox(
      child: MatrixGestureDetector(
      onMatrixUpdate: (m, tm, sm, rm) {
        notifier.value = m;
      },
      child: AnimatedBuilder(
        animation: notifier,
        builder: (ctx, child) {
          return Transform(
            transform: notifier.value,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Container(
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 6),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                    spreadRadius: 0.5,
                  )
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: img,
                ),
              ),
            ),
          );
        },
      ),
      ),
    );
  }
}
