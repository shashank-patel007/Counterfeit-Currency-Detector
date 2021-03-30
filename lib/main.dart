import 'dart:io';

import 'package:currency_detector_app/scanner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  int flag = -1;
  File file;

  clearAll() {
    setState(() {
      file = null;
      flag = -1;
    });
  }

  handleTakePhoto(flag, context) async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = file;
      this.flag = flag;
    });
   
  }

  handleChooseFromGallery(flag, context) async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.file = file;
      this.flag = flag;
    });
    
  }

  selectImage(flag, context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Choose Image'),
            children: <Widget>[
              SimpleDialogOption(
                  child: Text("Photo with Camera"),
                  onPressed: () {
                    handleTakePhoto(flag, context);
                  }),
              SimpleDialogOption(
                  child: Text("Image from Gallery"),
                  onPressed: () {
                    handleChooseFromGallery(flag, context);
                  }),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  Future<dynamic> showMessage(context, {bool isDimissible = true}) {
    return showModalBottomSheet(
        isDismissible: isDimissible,
        context: context,
        elevation: 12,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
              height: 130,
              decoration: BoxDecoration(
                color: Color(0xff1e1e23),
                borderRadius: BorderRadius.circular(20.0),
              ),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      selectImage(1, context);
                      // Navigator.pop(context);
                      // setState() {
                      //   flag = 0;
                      // }

                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Scanner(1,file)));
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          '₹ 500',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectImage(0, context);
                      // Navigator.pop(context);
                      // setState() {
                      //   flag = 1;
                      // }
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          '₹ 2000',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w500),
                        )),
                  )
                ],
              )));
        });
  }

  int currentTab = 0;
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return file != null
        ? Scanner(flag, file, clearAll)
        : Scaffold(
            backgroundColor: Color(0xff1e1e23),
            appBar: AppBar(
              titleSpacing: 0,
              elevation: 0,
              backgroundColor: Color(0xff885566),
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
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('assets/front-2000.jpg'),
                  Image.asset('assets/back-2000.jpg')
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.crop_free),
              backgroundColor: Color(0xffBB86FC),
              onPressed: () {
                return showModalBottomSheet(
                    isDismissible: true,
                    context: context,
                    elevation: 12,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext bc) {
                      return Container(
                          height: 130,
                          decoration: BoxDecoration(
                            color: Color(0xff1e1e23),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(bc);
                                  selectImage(1, context);
                                  // setState() {
                                  //   flag = 0;
                                  // }

                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Text(
                                      '₹ 500',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(bc);
                                  selectImage(0, context);
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Text(
                                      '₹ 2000',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    )),
                              )
                            ],
                          )));
                    });
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              color: Color(0xff121212),
              notchMargin: 10,
              child: Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          minWidth: 70,
                          onPressed: () {
                            setState(() {
                              currentTab = 0;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.menu_rounded,
                                size: 33,
                                color:
                                    currentTab == 0 ? Colors.blue : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Right Tab bar icons

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              currentTab = 3;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.help_outline_outlined,
                                size: 33,
                                color:
                                    currentTab == 3 ? Colors.blue : Colors.grey,
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
