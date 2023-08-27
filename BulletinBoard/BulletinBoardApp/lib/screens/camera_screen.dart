// A screen that allows users to take a picture using a given camera.
import 'dart:io';

import 'package:bulletin_board_app/data/bloc/image_bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';

import '../data/bloc/events/image_events.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  late bool _rearCamera = true;

  Future _setupCamera(CameraDescription cameraDescription) async {
    // To display the current output from the Camera,
    // get a CameraController.
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);

    try {
      // Saving the initialize, to use in futurebuilder
      _initializeControllerFuture = _cameraController.initialize();
      if (!mounted) return;
      setState(() {});
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  void _takePicture() async {
    final ImageBloc imageBloc = BlocProvider.of<ImageBloc>(context);

    try {
      // Checking if ressources on controller is available
      if (!_cameraController.value.isInitialized) return;
      if (_cameraController.value.isTakingPicture) return;
      final xImage = await _cameraController.takePicture();

      final File fImage = File(xImage.path);
      final bytes = fImage.readAsBytesSync();

      if (!mounted) return;

      // Create a temporary location, this avoids the need to prompt for permission.
      // Comparable to AppData
      final dir = await getTemporaryDirectory();
      String fileName = fImage.path.split('/').last;
      String fullPath = "${dir.path}/$fileName";

      var file = File(fullPath);
      await file.writeAsBytes(bytes);

      // Prompt user to save
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      // Only save if the prompt ends with a finalpath value.
      if (finalPath != null) {
        imageBloc.add(PostImageEvent(bytes));
      }

      // Shows a message, informing the user of a picture having been saved.
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Picture saved")));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _flipCamera() {
    setState(() => _rearCamera = !_rearCamera);
    _setupCamera(widget.cameras[_rearCamera ? 0 : 1]);
  }

  @override
  void initState() {
    super.initState();
    _setupCamera(widget.cameras[0]);//Initial setup on rear camera
  }

  @override
  void dispose() {
    // Disposal of camera to free resources
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Camera')),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                body: Scaffold(
                  body: CameraPreview(_cameraController),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.startFloat,
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      _flipCamera();
                    },
                    child: Icon(_rearCamera
                        ? CupertinoIcons.switch_camera_solid
                        : CupertinoIcons.switch_camera),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    await _initializeControllerFuture;
                    _takePicture();
                  },
                  child: const Icon(Icons.camera_alt),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
