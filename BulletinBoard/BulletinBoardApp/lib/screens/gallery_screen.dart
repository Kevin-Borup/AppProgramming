import 'dart:async';
import 'dart:io';

import 'package:bulletin_board_app/data/bloc/image_model_bloc.dart';
import 'package:bulletin_board_app/data/bloc/states/image_model_states.dart';
import 'package:bulletin_board_app/widgets/gallery_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../data/models/image_model.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
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
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocalImages();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Text("Local Gallery"),
          _loadingLocalImages
              ? const CircularProgressIndicator()
              : GalleryWidget(images: _localImages),
          const Text("Remote Gallery"),
          BlocListener<ImageModelBloc, ImageModelState>(
            listener: (blocContext, ImageModelState state) {
              //Remains in loading until the state emits complete.
              _loadingRemoteImages =
              (state.currentState == ImageModelStates.complete);
            },
            child: _loadingRemoteImages ? const CircularProgressIndicator()
                : BlocBuilder<ImageModelBloc, ImageModelState>(
                builder: (blocContext, ImageModelState state) {
                  return GalleryWidget(images: state.imgs
                      .map((ImageModel image) => image.img)
                      .toList());
                }
            ),
          )
        ],
      ),
    );
  }
}
