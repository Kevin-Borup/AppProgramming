import 'package:bulletin_board_app/widgets/gallery_local_widgets.dart';
import 'package:bulletin_board_app/widgets/gallery_remote_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  Orientation? _currentOrientation;

  @override
  void didChangeMetrics() {
    _currentOrientation = MediaQuery.of(context).orientation;
    if (kDebugMode) { // kDebugMode means this if is only true whilst debugging
      print('Before Orientation Change: $_currentOrientation');
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { // Fixes a potential issue of MediaQuery not always being updated fast enough
      setState(() {
        _currentOrientation = MediaQuery.of(context).orientation;
      });
      if (kDebugMode) {
        print('After Orientation Change: $_currentOrientation');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentOrientation = MediaQuery.of(context).orientation; //Using the orientation to determine the build

    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: Center(
        child: _currentOrientation == Orientation.portrait
            ? //Portrait MODE
            const Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Icon(Icons.save),
                        Text("  Local Gallery"),
                      ],
                    ),
                  ),
                  Expanded(flex: 6, child: GalleryLocalWidget()),
                  Divider(
                    color: Colors.grey,
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Icon(Icons.cloud_done),
                        Text("  Remote Gallery"),
                      ],
                    ),
                  ),
                  Expanded(flex: 6, child: GalleryRemoteWidget()),
                ],
              )
            : //Landscape MODE
            const Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Icon(Icons.save),
                                Text("  Local Gallery"),
                              ],
                            ),
                          ),
                          Expanded(flex: 6, child: GalleryLocalWidget())
                        ],
                      )),
                  Divider(
                    color: Colors.grey,
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Icon(Icons.cloud_done),
                                Text("  Remote Gallery"),
                              ],
                            ),
                          ),
                          Expanded(flex: 6, child: GalleryRemoteWidget())
                        ],
                      ))
                ],
              ),
      ),
    );
  }
}
