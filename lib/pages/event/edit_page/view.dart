import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import '../../../ui/BaseState.dart';
import '../../../ui/widgets/edit.dart';
import 'action.dart';
import 'state.dart';

inputDec(hintText) => _inputDec(
      hintText,
      EdgeInsets.only(left: 5), //Container()
    );

_inputDec(hintText, contentPadding, [Widget icon]) => InputDecoration(
      hintText: hintText,
      border: InputBorder.none,
      contentPadding: contentPadding,
      icon: icon,
    );

class EventDetailView extends StatefulWidget {
  final EditState state;
  final Dispatch dispatch;
  final ViewService viewService;
  EventDetailView(this.state, this.dispatch, this.viewService, {Key key})
      : super(key: key);

  @override
  _EventDetailViewState createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> with PageApi {
  @override
  Widget build(BuildContext context) {
    Widget dateTimeComponent =
        widget.viewService.buildComponent('DateTimePickerComponent');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.state.isEdit ? "修改" : "新建"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: <Widget>[
          RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: commonText('确定'),
              onPressed: () =>
                  widget.dispatch(EditActionCreator.onCommitAction())),
        ],
      ),
      body: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              commonEditText(
                  EditTextController(
                    controller: widget.state.titleEtCtrl,
                    editTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                    inputDecoration: inputDec("请输入主题"),
                  ),
                  true),
              commonEditText(
                  EditTextController(
                      controller: widget.state.contentEdCtrl,
                      editTextStyle: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 18,
                      ),
                      inputDecoration: inputDec("请输入内容")),
                  true),
              commonSeparator(Color(0xa0333333)),
              Container(
                  height: 90,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: dateTimeComponent),
              commonSeparator(Colors.grey, 0.4),
            ],
          )),
    );
  }
}

Widget buildView(EditState state, Dispatch dispatch, ViewService viewService) {
  return EventDetailView(state, dispatch, viewService);
}
