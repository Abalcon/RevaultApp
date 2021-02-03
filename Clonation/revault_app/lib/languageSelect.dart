import 'package:flutter/material.dart';
import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'package:revault_app/common/aux.dart';

class LanguageSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Language Setting"),
      ),
      body: LanguageSelectForm(),
      backgroundColor: backgroundGrey,
    );
  }
}

class LanguageSelectForm extends StatefulWidget {
  @override
  LanguageSelectFormState createState() {
    return LanguageSelectFormState();
  }
}

// 문의 양식
class LanguageSelectFormState extends State<LanguageSelectForm> {
  final _formKey = GlobalKey<FormState>();
  // TODO: 사용자의 설정에서 값을 가져오기
  List<bool> _selections = [true, false];

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        //padding: EdgeInsets.symmetric(horizontal: 10),
        child: CustomToggleButtons(
          direction: Axis.vertical,
          children: [
            selectionBar('한국어', _selections[0], context),
            selectionBar('English', _selections[1], context),
          ],
          isSelected: _selections,
          onPressed: (index) {
            setState(() {
              for (int btnIndex = 0; btnIndex < _selections.length; btnIndex++) {
                if (btnIndex == index)
                  _selections[btnIndex] = true;
                else
                  _selections[btnIndex] = false;
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('언어 $index' + '번 선택')));
          },
          fillColor: Colors.white,
          unselectedFillColor: Colors.white,
          selectedColor: Colors.black,
        )
      ), 
    );
  }
}

Widget selectionBar(String lang, bool selected, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width - 26,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Text(
            lang,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey
            )
          ),
        ),
        Icon(
          Icons.check,
          size: 24,
          color: (selected == true) ? Colors.green : Colors.transparent
        ),
      ],
    )
  );
}