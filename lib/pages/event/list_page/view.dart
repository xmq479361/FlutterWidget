import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_widget/utils/TimeFormatter.dart';

import 'calendar_list/QCalendarWidget.dart';
import '../event_component/action.dart';
import 'render.dart';
import 'state.dart';
import '../event_component/state.dart';

class EventListScreen extends StatefulWidget {
  final ListState viewState;
  final Dispatch dispatch;
  final ViewService viewService;

  EventListScreen(this.viewState, this.dispatch, this.viewService, {Key key})
      : super(key: key);

  @override
  _EventListScreenState createState() => _EventListScreenState(dispatch);
}

const ITEM_HEIGHT = 85.0;

class _EventListScreenState extends DispatchState<EventListScreen>
    with QCalendarWidgetMixin<EventListScreen> {
  _EventListScreenState(Dispatch dispatch) : super(dispatch);

  @override
  Widget build(BuildContext context) {
    final List<EventState> events = widget.viewState.curDateEvents;
    return customScrollView(
      widget.viewState.scrollCtrl,
      CustomScrollView(
        physics: ClampingScrollPhysics(),
        key: widget.viewState.scrollViewKey,
        controller: widget.viewState.scrollCtrl,
        slivers: <Widget>[
          /// 顶部可伸缩日历视图
          sliverHeader(
              model: widget.viewState.model,
              render: EventQCalendarRender(widget.viewState)),

          /// 选中日期内 日程事件列表
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              EventState event = events[index];
              return GestureDetector(
                  onTapUp: (details) =>
                      widget.dispatch(EventActionCreator.onEditAction(event)),
                  child: Container(
                      height: ITEM_HEIGHT,
                      alignment: Alignment.center,
                      color: Colors.lightBlue[100 * ((index % 9) + 1)],
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(' ${formatDate(event.startTime, FORMAT_HM)}'),
                            Expanded(
                                child: Text('${event.title}',
                                    textAlign: TextAlign.center)),
                          ])));
            }, childCount: events.length),
          ),

          /// 底部填充View。无数据时显示为无数据
          bottomFillWidget(events)
        ],
      ),
    );
  }

  Widget bottomFillWidget(events) {
    final offset = widget.viewState.model.fullHeight -
        widget.viewState.model.minHeight -
        events.length * ITEM_HEIGHT;
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Container(
        color: Colors.blue[100],
        height: offset > 0 ? offset : 0,
        alignment: Alignment.center,
        child: events.isNotEmpty
            ? Center()
            : Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Icon(Icons.sentiment_very_satisfied,
                        size: ITEM_HEIGHT, color: Colors.blue[900]),
                    Text("无数据")
                  ]),
      ),
    );
  }
}

Widget buildView(ListState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: AppBar(
          title:
              Container(child: Text(formatDate(state.selectDate, FORMAT_YMD))),
          centerTitle: false),
      backgroundColor: Colors.cyan,
      body: SafeArea(
          child: Container(
        child: EventListScreen(state, dispatch, viewService),
      )),

      /// 浮动添加日程按钮
      floatingActionButton: FloatingActionButton(
        onPressed: () => dispatch(EventActionCreator.onEditAction(
            EventState(startTime: state.selectDate))),
        tooltip: 'Theme',
        child: const Icon(Icons.add),
      ));
}
