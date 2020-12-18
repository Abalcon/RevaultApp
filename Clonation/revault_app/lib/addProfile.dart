import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("프로필 사진 설정"),
      ),
      body: AddProfileDetail(),
    );
  }
}

class AddProfileDetail extends StatefulWidget {

  @override
  AddProfileDetailState createState() => AddProfileDetailState();
}

class AddProfileDetailState extends State<AddProfileDetail> {
  File selectedImage;

  Future getImage() async {
    var imagePicker = new ImagePicker();
    var image = await imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      selectedImage = File(image.path);
    });
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
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  '현재 프로필 사진',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              CircleAvatar(
                radius: 80.0,
                backgroundImage: currentImage(),
                backgroundColor: Colors.transparent,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.greenAccent,
                    onPressed: getImage,
                    child: Text(
                      "사진 선택하기",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                )
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.greenAccent,
                    onPressed: (selectedImage == null) ? null
                      : () async {
                        ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('프로필 사진 변경에 성공했습니다')));
                        // TODO: 회원가입 페이지로 저장한 이미지를 보내기
                        Navigator.pop(context, selectedImage);
                    },
                    child: Text(
                      "저장하기",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                )
              ),
            ]
          ),
        )
      )
    );
  }
}