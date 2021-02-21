import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraController cameraController;
  List cameras;
  String imgPath;

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController.dispose();
    }
    cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);

    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    if (cameraController.value.hasError) {
      print("Camera Error ${cameraController.value.errorDescription}");
    }
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print(e);
    }
  }

  Widget cameraPreviewWidget() {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return AspectRatio(
      aspectRatio: cameraController.value.aspectRatio,
      child: CameraPreview(cameraController),
    );
  }

  void _onCapturePressed(context) async {
    try {
      final path =
          join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
      print(path);
      await cameraController.takePicture(path);
    } catch (e) {
      print(e);
    }
  }

  void startCamera() async {
    await availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        _initCameraController(cameras[0]).then((void value) {});
      } else {
        print("No camera");
      }
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Counterfeit Currency Detector",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 23,
          ),
        ),
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: cameraPreviewWidget(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          print(i);
        },
        items: [
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                PopupMenuButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.offline_bolt,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Item2"),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.offline_bolt,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Item2"),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.offline_bolt,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Item2"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            label: '',
          ),
          // BottomNavigationBarItem(
          //   icon: IconButton(
          //     icon: Icon(
          //       Icons.menu,
          //     ),
          //     onPressed: () {
          //       print("Menu");
          //     },
          //   ),
          //   label: '',
          // ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.camera,
              ),
              onPressed: () {
                _onCapturePressed(context);
              },
            ),
            label: 'Click',
          ),
        ],
      ),
    );
  }
}
