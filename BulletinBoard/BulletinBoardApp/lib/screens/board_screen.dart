import 'package:bulletin_board_app/data/bloc/events/image_model_events.dart';
import 'package:bulletin_board_app/data/bloc/image_model_bloc.dart';
import 'package:bulletin_board_app/screens/camera_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/bloc/states/image_model_states.dart';
import '../data/models/image_model.dart';
import '../widgets/image_widget.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  List<ImageWidget> imgs = [];

  @override
  Widget build(BuildContext context) {
    final ImageModelBloc imageBloc = BlocProvider.of<ImageModelBloc>(context);
    imageBloc.add(GetAllImageModelsEvent());

    return Scaffold(
      appBar: AppBar(title: const Text('Board')),
      body: SafeArea(
        child: LimitedBox(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width,
          child: BlocBuilder<ImageModelBloc, ImageModelState>(
              builder: (blocContext, ImageModelState state) {
            return Stack(
                children: state.imgs
                    .map((ImageModel image) => image.toImageWidget())
                    .toList());
          }),
        ),
      ),
    );
  }
}
