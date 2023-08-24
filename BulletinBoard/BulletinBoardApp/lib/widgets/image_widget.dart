import 'package:flutter/material.dart';

class ImageWidget extends StatefulWidget {
  const ImageWidget ({super.key, required this.img, this.position, this.size, this.ang});
  final Image img;
  final Offset? position;
  final Size? size;
  final double? ang;

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  late Image img;
  late Offset position;
  late Size size;
  late double ang;

  @override
  void initState() {
    super.initState();
    img = widget.img;
    position = widget.position ?? const Offset(0, 0);
    size = widget.size ?? const Size(30, 30);
    ang = widget.ang ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Positioned(
        left: position.dx,
        top: position.dy,
        child:  Transform.rotate(
            angle: ang,
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: Center(
                child: GestureDetector(
                  onPanStart: (dragDetails) => {},
                  onPanUpdate: (dragDetails) => {},
                  onPanEnd: (dragDetails) => {},

                  onScaleStart: (scaleDetails) => {},
                  onScaleUpdate: (scaleDetails) => {},
                  onScaleEnd: (scaleDetails) => {},

                  child: img,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
