import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget/utils/TimeFormatter.dart';
import 'package:quicklibs/quicklibs.dart';

import 'calendar_list/QCalendarWidget.dart';
import 'calendar_list/QCalNotification.dart';
import '../event_component/action.dart';
import 'action.dart';
import 'render.dart';
import 'state.dart';
import '../event_component/state.dart';

class EventListView extends StatefulWidget {
  final ListState viewState;
  final Dispatch dispatch;
  final ViewService viewService;
  EventListView(this.viewState, this.dispatch, this.viewService, {Key key})
      : super(key: key);

  @override
  _EventListViewState createState() => _EventListViewState();
}

const ITEM_HEIGHT = 85.0;

class _EventListViewState extends State<EventListView>
    with QCalendarWidgetMixin<EventListView> {
  @override
  Widget build(BuildContext context) {
    // final List<EventState> events = widget.viewState.events;
    final List<EventState> events = widget.viewState.curDateEvents;
    final offset = widget.viewState.model.fullHeight -
        widget.viewState.model.minHeight -
        events.length * ITEM_HEIGHT;
    return customScrollView(
      widget.viewState.scrollCtrl,
      CustomScrollView(
        physics: ClampingScrollPhysics(),
        key: widget.viewState.scrollViewKey,
        controller: widget.viewState.scrollCtrl,
        slivers: <Widget>[
          sliverHeader(
              model: widget.viewState.model,
              render: EventQCalendarRender(widget.viewState)),
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
                      // color: Colors.lightBlue[100],
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
          SliverFillRemaining(
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
                          ])),
          )
        ],
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
              child: NotificationListener<QCalNotification>(
                  onNotification: (notify) {
                    dispatch(ListActionCreator.onFocusDateAction(
                        notify.model.focusDateTime.toDateTime()));
                    return true;
                  },
                  child: EventListView(state, dispatch, viewService)))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => dispatch(EventActionCreator.onEditAction(
            EventState(startTime: state.selectDate))),
        tooltip: 'Theme',
        child: const Icon(Icons.add),
      ));
}
