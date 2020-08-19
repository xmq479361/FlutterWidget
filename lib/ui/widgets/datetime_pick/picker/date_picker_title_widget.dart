import 'package:flutter/material.dart';

import 'date_picker_constants.dart';
import 'date_picker_theme.dart';

/// DatePicker's title widget.
///
/// @author dylan wu
/// @since 2019-05-16
class DatePickerTitleWidget extends StatelessWidget {
  DatePickerTitleWidget({
    Key key,
    this.pickerTheme,
    @required this.onCancel,
    @required this.onConfirm,
  }) : super(key: key);

  final DateTimePickerTheme pickerTheme;
  final DateVoidCallback onCancel, onConfirm;

  @override
  Widget build(BuildContext context) {
    if (pickerTheme.title != null) {
      return pickerTheme.title;
    }
    return Container(
      height: pickerTheme.titleHeight,
      decoration: BoxDecoration(color: pickerTheme.backgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: pickerTheme.titleHeight,
            child: FlatButton(
                child: _renderCancelWidget(context),
                onPressed: () => this.onCancel()),
          ),
          Container(
            height: pickerTheme.titleHeight,
            child: FlatButton(
                child: _renderConfirmWidget(context),
                onPressed: () => this.onConfirm()),
          ),
        ],
      ),
    );
  }

  /// render cancel button widget
  Widget _renderCancelWidget(BuildContext context) {
    Widget cancelWidget = pickerTheme.cancel;
    if (cancelWidget == null) {
      TextStyle textStyle = pickerTheme.cancelTextStyle ??
          TextStyle(
              color: Theme.of(context).unselectedWidgetColor, fontSize: 16.0);
      cancelWidget = Text("取消", style: textStyle);
    }
    return cancelWidget;
  }

  /// render confirm button widget
  Widget _renderConfirmWidget(BuildContext context) {
    Widget confirmWidget = pickerTheme.confirm;
    if (confirmWidget == null) {
      TextStyle textStyle = pickerTheme.confirmTextStyle ??
          TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0);
      confirmWidget = Text("确定", style: textStyle);
    }
    return confirmWidget;
  }
}
