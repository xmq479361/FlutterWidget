import 'package:flutter/material.dart';

typedef InputDecoration EditInputDecoration();
typedef Widget TextBuilder(InputDecoration inputDec, TextStyle textStyle);

class EditTextController {
  TextEditingController controller;
  TextStyle editTextStyle;
  InputDecoration inputDecoration;
  TextBuilder textBuilder;

  EditTextController(
      {text = "",
      this.controller,
      this.editTextStyle,
      this.inputDecoration,
      this.textBuilder});

  getEditTextStyle() {
    if (editTextStyle != null) {
      return editTextStyle;
    }
    return TextStyle();
  }

  fetchInputDecoration() {
    if (inputDecoration != null) {
      return inputDecoration;
    }
    return InputDecoration(
      border: InputBorder.none,
    );
  }

  EditTextController.instance({this.textBuilder});
}

class EditText extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditTextState();
  }

  final EditTextController editController;
  final String hintText;
  final bool autofocus;
  final double height;
  final EdgeInsetsGeometry padding;

  EditText({
    this.hintText = "",
    this.autofocus = false,
    this.height,
    this.padding,
    @required this.editController,
  });
}

class _EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    EditTextController editController = widget.editController;
    Widget textWidget = TextField(
      controller: editController.controller,
      decoration: editController.fetchInputDecoration(),
      style: editController.getEditTextStyle(),
      cursorColor: Colors.black26,
      autofocus: widget.autofocus,
    );
    if (editController.textBuilder != null) {
      textWidget = editController.textBuilder(
          editController.fetchInputDecoration(),
          editController.getEditTextStyle());
    }
    return Container(
        height: widget.height,
        padding: widget.padding,
        color: Colors.white,
        child: Row(children: <Widget>[
          Expanded(child: textWidget),
        ]));
  }
}
