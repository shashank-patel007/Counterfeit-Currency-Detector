import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';

class Scanner extends StatefulWidget {
  int flag;
  File file;
  Function back;
  Scanner(this.flag, this.file, this.back);
  @override
  _ScannerState createState() => _ScannerState(this.flag);
}

class _ScannerState extends State<Scanner> {
  int flag;
  _ScannerState(this.flag);
  File file;
  String result;
  void _choose() async {
    // final file = await ImagePicker.pickImage(source: ImageSource.camera);
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _upload() async {
    if (file == null) return;
    var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = file.length();
    var uri = Uri.parse("http://192.168.1.3/home");
    var request = http.MultipartRequest("POST", uri);
    var multipartfile = http.MultipartFile('file', stream, await length,
        filename: basename(file.path));
    request.files.add(multipartfile);
    request.fields.addAll({"flag": widget.flag.toString()});
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) async {
      print(value);
      var result = await jsonDecode(value)['prediction'];
      setState(() {
        this.result = result;
      });
    });
  }

  Widget displayResult(String result) {
    if (result == null) {
      return Text('');
    } else if (result == '1') {
      return Text(
        'REAL IMAGE',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      );
    } else {
      return Text(
        'FAKE IMAGE',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.back();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: widget.back),
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Color(0xff885566),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     RaisedButton(
            //       onPressed: _choose,
            //       child: Text('Choose Image'),
            //     ),
            //     SizedBox(width: 10.0),
            //     RaisedButton(
            //       onPressed: _upload,
            //       child: Text('Upload Image'),
            //     )
            //   ],
            // ),
            SizedBox(
              height: 10,
            ),
            // file == null ? Text('No Image Selected') :
            Image.file(widget.file),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: _upload,
              child: Text('Upload Image'),
            ),
            displayResult(this.result)
          ],
        ),
      ),
    );
  }
}
