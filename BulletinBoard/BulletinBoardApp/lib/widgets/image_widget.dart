
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/bloc/events/image_model_events.dart';
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
  late Image _img;
  late Offset _position;
  late Size _size;
  late double _angle;

  late Offset _startingFocalPoint;
  late Offset _previousOffset = const Offset(0, 0);

  double _scaleFactor = 0.5;
  double _baseScaleFactor = 0.5;

  @override
  void initState() {
    super.initState();
    _img = widget.img;
    _position = widget.position ?? const Offset(0, 0);
    _size = widget.size ?? const Size(30, 30);
    _angle = widget.ang ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final ImageModelBloc imageModelBloc = BlocProvider.of<ImageModelBloc>(context);

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: Transform.rotate(
        angle: _angle,
        child: SizedBox(
          height: _size.height,
          width: _size.width,
          child: Center(
            child: GestureDetector(
              //Scale contains details of paning with focalPoint, rotation and scale.
              onScaleStart: (details) {
                setState(() {
                  _startingFocalPoint = details.focalPoint;
                  _previousOffset = _position;
                  _baseScaleFactor = _scaleFactor;
                });
              },

              onScaleUpdate: (details) {
                setState(() {
                  if (details.pointerCount == 2){ //2 fingers
                    _scaleFactor = _baseScaleFactor * details.scale;
                    _size = _size * _scaleFactor;
                    _angle = details.rotation;
                  } else if (details.pointerCount == 1){ //1 finger
                    //Normalizing movement, to fix relativity movement.
                    final Offset normalizedOffset = _startingFocalPoint - _previousOffset;
                    _position = details.focalPoint - normalizedOffset;
                  }
                });
              },
              onScaleEnd: (scaleDetails)  {
                // //Updates their properties in the DB, to save it for next session.
                // //Disabled for now
                // widget.imgMdl.updateOffsetSizeAngle(_position, _size, _angle);
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
                  child: _img,

              ) ,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
