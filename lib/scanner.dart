import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Scanner extends StatefulWidget {
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
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
      return Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
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

  @override
  void initState() {
    // implement initState
    super.initState();
    availableCameras().then((availableCameras) {
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
            icon: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                size: 33,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.camera,
              ),
              onPressed: () {
                _onCapturePressed(context);
              },
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                size: 33,
                color: Colors.transparent,
              ),
              onPressed: () {
                print("Menu");
              },
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
