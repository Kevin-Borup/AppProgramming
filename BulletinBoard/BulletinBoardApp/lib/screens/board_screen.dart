import 'dart:io';
import 'dart:typed_data';

import 'package:bulletin_board_app/data/bloc/events/image_events.dart';
import 'package:bulletin_board_app/data/bloc/events/image_model_events.dart';
import 'package:bulletin_board_app/data/bloc/image_model_bloc.dart';
import 'package:bulletin_board_app/screens/camera_screen.dart';
import 'package:bulletin_board_app/widgets/gallery_full_widgets.dart';
import 'package:bulletin_board_app/widgets/gallery_remote_widgets.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../data/bloc/image_bloc.dart';
import '../data/bloc/states/image_model_states.dart';
import '../data/bloc/states/image_states.dart';
import '../data/models/image_model.dart';
import '../widgets/image_widget.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  late List<Image> _localImages;
  late bool _loadingLocalImages = true;
  late bool _loadingRemoteImages = true;

  Future<void> _getLocalImages() async {
    // AssetPathEntity is an abstraction of albums and folders
    List<AssetPathEntity> assetFolders = [];
    assetFolders = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.image);

    int assetCount = await assetFolders[0].assetCountAsync;

    if (assetCount > 0) {
      // AssetEntity is an abstraction of pictures, videos and audio. (Requested to Image previously).
      List<AssetEntity> assetImages =
          await assetFolders[0].getAssetListRange(start: 0, end: assetCount);

      List<Image> tempImages = [];
      for (var asset in assetImages) {
        File? tempFile = await asset.file;
        if (tempFile == null) continue;
        tempImages.add(Image.file(tempFile));
      }

      setState(() {
        _localImages = tempImages;
        _loadingLocalImages = false;
      });
    }
  }

  Widget _loadedPictures() {
    List<Image> loadedImgs = [];
    _getLocalImages();

    // Both still loading
    if (_loadingLocalImages & _loadingRemoteImages) {
      return const CircularProgressIndicator();
    }

    if (!_loadingLocalImages) {
      //Local done loading
      loadedImgs = _localImages;
    }

    if (!_loadingRemoteImages) {
      // Remote done loading
      return BlocBuilder<ImageBloc, ImageState>(
        builder: (blocContext, ImageState state) {
          return _buildGrid(state.imgs + loadedImgs);
        },
      );
    }

    // BlocBuilder<ImageBloc, ImageState>(builder: (blocContext, ImageState state) {}
    return _buildGrid(loadedImgs);
  }

  Widget _buildGrid(List<Image> imgs) {
    final ImageModelBloc imageBloc = BlocProvider.of<ImageModelBloc>(context);

    return GridView.builder(
      itemCount: imgs.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (gridContext, int index) {
        return InkWell(
          onLongPress: () {
            Uint8List iByte = File(imgs[index].toString()).readAsBytesSync();
            imageBloc.add(PostImageModelAndGetAllEvent(
                ImageModel(img: imgs[index], bytes: iByte)));
          },
          child: GridTile(
            child: Container(
              child: imgs[index],
            ),
          ),
        );
      },
    );
  }

  void _insertImage() {
    final ImageBloc imageBloc = BlocProvider.of<ImageBloc>(context);
    imageBloc.add(GetAllImagesEvent());

    showDialog(
        context: context,
        builder: (dialogContext) {
          return BlocProvider.value(
            value: imageBloc,
            child: const AlertDialog(
              content: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.7,
                child: Center(child: GalleryFullWidget()),
              ),
            ),
          );
        });

    // showDialog(
    //     context: context,
    //     builder: (dialogContext) {
    //       return StatefulBuilder(builder: (stateBuilder, setState) {
    //         return BlocProvider.value(
    //           value: imageBloc,
    //           child: AlertDialog(
    //             content: FractionallySizedBox(
    //               widthFactor: 0.8,
    //               heightFactor: 0.7,
    //               child: Center(
    //                 child: BlocListener<ImageBloc, ImageState>(
    //                     listener: (blocContext, ImageState state) {
    //                       //Remains in loading until the state emits complete.
    //                       if (state.currentState == ImageStates.complete) {
    //                         setState(() {
    //                           _loadingRemoteImages = false;
    //                         });
    //                       }
    //                     },
    //                     child: _loadedPictures()),
    //               ),
    //             ),
    //           ),
    //         );
    //       });
    //     });
  }

  @override
  Widget build(BuildContext context) {
    final ImageModelBloc imageBloc = BlocProvider.of<ImageModelBloc>(context);
    imageBloc.add(GetAllImageModelsEvent());

    return Scaffold(
      appBar: AppBar(title: const Text('Board')),
      backgroundColor: const Color.fromRGBO(158, 170, 186, 1.0),
      body: SafeArea(
        child: Scaffold(
          body: LimitedBox(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
            child: Column(children: [
              Stack(children: [
                BlocBuilder<ImageModelBloc, ImageModelState>(
                    builder: (blocContext, ImageModelState state) {
                  return Stack(
                      children: state.imgs
                          .map((ImageModel image) => image.toImageWidget())
                          .toList());
                }),
              ]),
            ]),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                imageBloc.add(DeleteAllImageModelsEvent());
              },
              child: const Icon(Icons.remove)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _insertImage();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
