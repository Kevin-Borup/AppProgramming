import 'dart:io';
import 'dart:typed_data';

import 'package:bulletin_board_app/data/bloc/events/image_model_events.dart';
import 'package:bulletin_board_app/data/bloc/image_model_bloc.dart';
import 'package:bulletin_board_app/data/bloc/states/image_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../data/bloc/events/image_events.dart';
import '../data/bloc/image_bloc.dart';
import '../data/models/image_model.dart';

class GalleryFullWidget extends StatefulWidget {
  const GalleryFullWidget({super.key});

  @override
  State<GalleryFullWidget> createState() => _GalleryFullWidgetState();
}

class _GalleryFullWidgetState extends State<GalleryFullWidget> {
  late bool _remoteLoading = true;

  @override
  void initState() {
    super.initState();
    final ImageBloc imageBloc = BlocProvider.of<ImageBloc>(context);
    imageBloc.add(GetAllImagesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final ImageModelBloc imageModelBloc =
        BlocProvider.of<ImageModelBloc>(context);
    return Scaffold(
        body: BlocListener<ImageBloc, ImageState>(
      listener: (listenContext, ImageState state) {
        if (state.currentState == ImageStates.complete) {
          setState(() {
            _remoteLoading = false;
          });
        }
      },
      child: _remoteLoading
          ? const CircularProgressIndicator()
          : BlocBuilder<ImageBloc, ImageState>(
              builder: (blocContext, ImageState state) {
                return GridView.builder(
                  itemCount: state.imgs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (gridContext, int index) {
                    return InkWell(
                      onLongPress: () async {
                        Uint8List iBytes =
                            (state.imgs[index].image as MemoryImage).bytes;
                        Image image = Image.memory(iBytes);

                        Size newSize = Size(60, 60);
                        Offset newPos = Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2);
                        //Fractional measure of position would be a better way to track position.
                        //Meaning device changes would move them proportionally to their size.
                        //Would've developed that for production, settling for this in this project.

                        imageModelBloc.add(PostImageModelAndGetAllEvent(
                            ImageModel(img: image, bytes: iBytes, position: newPos, size: newSize)));

                      },
                      child: GridTile(
                        child: Container(
                          child: state.imgs[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    ));
  }
}
