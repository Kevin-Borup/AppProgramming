import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../data/bloc/events/image_events.dart';
import '../data/bloc/image_bloc.dart';

class GalleryLocalWidget extends StatefulWidget {
  const GalleryLocalWidget({super.key});

  @override
  State<GalleryLocalWidget> createState() => _GalleryLocalWidgetState();
}

class _GalleryLocalWidgetState extends State<GalleryLocalWidget> {
  late List<Image> _localImages;
  late bool _loadingLocalImages = true;

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

      if (!mounted) return;
      setState(() {
        _localImages = tempImages;
        _loadingLocalImages = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getLocalImages();

    return _loadingLocalImages
        ? const Center (child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),)
        : GridView.builder(
            itemCount: _localImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (gridContext, int index) {
              return InkWell(
                onLongPress: () async {
                  List<AssetPathEntity> assetFolders = [];
                  assetFolders = await PhotoManager.getAssetPathList(
                      onlyAll: true, type: RequestType.image);

                  int assetCount = await assetFolders[0].assetCountAsync;

                  if (assetCount > 0) {
                    //Deleting the long pressed image, by acquiring it from this library, to then delete it by creating a 1 list with it.
                    List<AssetEntity> assetImages = await assetFolders[0]
                        .getAssetListRange(start: index, end: 1);
                    final List<String> result = await PhotoManager.editor
                        .deleteWithIds(List.filled(1, assetImages.first.id));

                    setState(() {
                    });
                  }
                },
                child: GridTile(
                  child: Container(
                    child: _localImages[index],
                  ),
                ),
              );
            });
  }
}
