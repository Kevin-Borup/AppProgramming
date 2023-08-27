import 'package:bulletin_board_app/data/bloc/events/image_events.dart';
import 'package:bulletin_board_app/data/bloc/events/image_model_events.dart';
import 'package:bulletin_board_app/data/bloc/image_model_bloc.dart';
import 'package:bulletin_board_app/widgets/gallery_full_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/bloc/image_bloc.dart';
import '../data/bloc/states/image_model_states.dart';
import '../data/models/image_model.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  void _insertImage() {
    final ImageBloc imageBloc = BlocProvider.of<ImageBloc>(context);
    final ImageModelBloc imageModelBloc =
        BlocProvider.of<ImageModelBloc>(context);
    imageBloc.add(GetAllImagesEvent());

    showDialog(
        context: context,
        builder: (dialogContext) {
          return BlocProvider.value(
              value: imageBloc,
              child: BlocProvider.value(
                value: imageModelBloc,
                child: const AlertDialog(
                  content: FractionallySizedBox(
                    widthFactor: 0.8,
                    heightFactor: 0.7,
                    child: Center(child: GalleryFullWidget()),
                  ),
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final ImageModelBloc imageBloc = BlocProvider.of<ImageModelBloc>(context);
    imageBloc.add(GetAllImageModelsEvent());

    return Scaffold(
      appBar: AppBar(title: const Text('Board')),
      body: SafeArea(
        child: Scaffold(
          body: BlocBuilder<ImageModelBloc, ImageModelState>(
              builder: (blocContext, ImageModelState state) {
            return Stack(
              alignment: Alignment.center,
                children: state.imgs
                    .map((ImageModel image) => image.toImageWidget())
                    .toList());
          }),
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
