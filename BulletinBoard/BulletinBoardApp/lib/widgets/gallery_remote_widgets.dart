import 'dart:io';
import 'dart:typed_data';

import 'package:bulletin_board_app/data/bloc/states/image_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../data/bloc/events/image_events.dart';
import '../data/bloc/image_bloc.dart';

class GalleryRemoteWidget extends StatefulWidget {
  const GalleryRemoteWidget({super.key});

  @override
  State<GalleryRemoteWidget> createState() => _GalleryRemoteWidgetState();
}

class _GalleryRemoteWidgetState extends State<GalleryRemoteWidget> {
  late bool _remoteLoading = true;

  @override
  void initState() {
    super.initState();
    final ImageBloc imageBloc = BlocProvider.of<ImageBloc>(context);
    imageBloc.add(GetAllImagesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final ImageBloc imageBloc = BlocProvider.of<ImageBloc>(context);
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
                        imageBloc.add(DeleteImageEvent(iBytes));
                        imageBloc.add(GetAllImagesEvent());
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
