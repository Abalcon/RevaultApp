import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'common/aux.dart';

class AddProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "프로필 사진 설정",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0,
          ),
        ),
      ),
      body: AddProfileDetail(),
      backgroundColor: Colors.white,
    );
  }
}

class AddProfileDetail extends StatefulWidget {

  @override
  AddProfileDetailState createState() => AddProfileDetailState();
}

class AddProfileDetailState extends State<AddProfileDetail> {
  File selectedImage;

  Future _getImageFromCamera() async {
    var imagePicker = new ImagePicker();
    var image = await imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      selectedImage = File(image.path);
    });
  }

  Future _getImageFromGallery() async {
    var imagePicker = new ImagePicker();
    var image = await imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(image.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Photo Library'),
                  onTap: () {
                    _getImageFromGallery();
                    Navigator.of(context).pop();
                  }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _getImageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  ImageProvider<Object> currentImage() {
    if (selectedImage != null) {
      List<int> imageBytes = selectedImage.readAsBytesSync();
      String base64 = base64Encode(imageBytes);
      Uint8List bytes = base64Decode(base64);
      return MemoryImage(bytes);
    }

    return NetworkImage(
      'https://revault.co.kr/web/upload/NNEditor/20201210/94b9ab77d43e7672ba4d14e021235d0e.jpg'
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 80, 15, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 80.0,
              backgroundImage: currentImage(),
              backgroundColor: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                '현재 프로필 사진',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: SizedBox(
                width: double.infinity,
                child: FlatButton(
                  shape: inputBorder,
                  color: Colors.white,
                  textColor: revaultBlack,
                  disabledColor: Colors.grey,
                  disabledTextColor: revaultBlack,
                  padding: EdgeInsets.all(18.0),
                  splashColor: Colors.greenAccent,
                  onPressed: () {
                    _showPicker(context);
                  },
                  child: Text(
                    "사진 선택하기",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                    ),
                  ),
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: FlatButton(
                  shape: Border(),
                  color: revaultBlack,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.white,
                  padding: EdgeInsets.all(18.0),
                  splashColor: Colors.greenAccent,
                  onPressed: (selectedImage == null) ? null
                    : () async {
                      ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('프로필 사진 변경에 성공했습니다')));
                      Navigator.pop(context, selectedImage);
                  },
                  child: Text(
                    "저장하기",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}