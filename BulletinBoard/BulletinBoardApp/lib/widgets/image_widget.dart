
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/bloc/image_model_bloc.dart';
import '../data/models/image_model.dart';

class ImageWidget extends StatefulWidget {
   ImageWidget(
      {super.key, required this.imgMdl, required this.img, this.position, this.size, this.ang});

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

  late Offset _startingFocalPoint;
  late Offset _previousOffset = const Offset(0, 0);

  double _scaleFactor = 0.5;
  double _baseScaleFactor = 0.5;

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
    final ImageModelBloc imageModelBloc = BlocProvider.of<ImageModelBloc>(context);

    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: Transform.rotate(
        angle: angle,
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Center(
            child: GestureDetector(
              //Scale contains details of paning with focalPoint, rotation and scale.
              onScaleStart: (details) {
                setState(() {
                  _startingFocalPoint = details.focalPoint;
                  _previousOffset = _offset;
                  _baseScaleFactor = _scaleFactor;
                });
              },

              onScaleUpdate: (details) {
                setState(() {
                  if (details.pointerCount == 2){ //2 fingers
                    _scaleFactor = _baseScaleFactor * details.scale;
                    size = size * _scaleFactor;
                    angle = details.rotation;
                  } else if (details.pointerCount == 1){ //1 finger
                    //Normalizing movement, to fix relativity movement.
                    final Offset normalizedOffset = _startingFocalPoint - _previousOffset;
                    _offset = details.focalPoint - normalizedOffset;
                  }
                });
              },
              onScaleEnd: (scaleDetails)  {
                // //Updates their properties in the DB, to save it for next session.
                // //Disabled for now
                // widget.imgMdl.updateOffsetSizeAngle(position, size, angle);
                // imageModelBloc.add(UpdateImageModelEvent(widget.imgMdl));
              },

              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 6),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                      spreadRadius: 0.5,
                    )
                  ]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: img,

              ) ,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
