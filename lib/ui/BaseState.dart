import 'package:flutter/material.dart';
import 'widgets/Separator.dart';
import 'widgets/edit.dart';

typedef Widget TextBuilder(InputDecoration inputDec, TextStyle textStyle);

class VerticalDivider extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const VerticalDivider({this.color, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: color,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }
}

mixin PageApi {
  commonEditText(EditTextController editCtlr, [bool autofocus = false]) =>
      EditText(
        autofocus: autofocus,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 12),
        editController: editCtlr,
      );

  commonSeparator([Color color = Colors.grey, double height = 1.0]) => Divider(
        height: height,
        indent: 0.0,
        color: color,
      );

  commonSeparatorVertical(double height,
          [Color color = Colors.grey, double width = 0.5]) =>
      VerticalDivider(
        width: width,
        height: height,
        color: color,
      );

//  commonSeparatorVertical([Color color= Colors.grey, double width= 5.0])=>VerticalDivider();
  commonMashSeparator([Color color = Colors.grey]) =>
      BaseSeparator(color: color);

  commonTextItem(TextBuilder textBuilder, [EditTextController editCtrl]) {
    if (editCtrl == null) {
      editCtrl = EditTextController();
    }
    editCtrl.textBuilder = textBuilder;
    return EditText(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 12),
        editController: editCtrl);
  }

  commonText(String text, [TextStyle style]) => Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: style,
      );

  commonTextEdit(String text, EditTextController editCtlr) => EditText(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 12),
      editController: editCtlr
        ..textBuilder = (InputDecoration inputDec, TextStyle textStyle) => Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ));

  commonExpendedColumn(List<Widget> widgets) => Expanded(
          child: Column(
        children: widgets,
        mainAxisAlignment: MainAxisAlignment.center,
      ));

  commonIcon(String src, [double size = 16]) => ImageIcon(
        AssetImage(src),
        size: size,
        color: Colors.black54,
      );

  Widget commonSpaceView(double height) => Container(
        color: Color(0x10333333),
        height: height,
      );
}

abstract class BaseWidget extends StatelessWidget with PageApi {}

abstract class BaseStateWidget<T extends StatefulWidget> extends State<T>
    with PageApi {}
