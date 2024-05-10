import 'dart:async';
import 'dart:math';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/scheduler.dart';
import 'package:flutter_widget/pages/event/list_page/action.dart';
import 'QCalHolder.dart';
import 'QCalendarRender.dart';
import 'QCalendarView.dart';
import 'QCalModel.dart';

abstract class DispatchState<T extends StatefulWidget> extends State<T> {
  final Dispatch dispatch;

  DispatchState(this.dispatch);
}
mixin QCalendarWidgetMixin<T extends StatefulWidget> on DispatchState<T>{
  final GlobalKey containerKey = GlobalKey();
  QCalHolder _model;
  ScrollController _scrollController;
  Timer _timer;


  onSelectDate(Date focusDate) {
    print("onSelectDate: $focusDate");
    _model.focusDateTime = focusDate;
    dispatch(ListActionCreator.onFocusDateAction(focusDate.toDateTime()));
    setState(() {});
  }

  /// 横向滑动切换页面时触发。
  focusDateByPage(int page) {
    _model.focusDateTime = _model.getDateTime(page);
    _model.currPage = page;
    dispatch(ListActionCreator.onPageChangedAction(_model.focusDateTime.toDateTime()));
    setState(() {});
  }

  @mustCallSuper
  dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @mustCallSuper
  initState() {
    if (_model == null) _model = QCalHolder(mode: Mode.WEEK);

    /// 初始化获取屏幕尺寸，以计算周/月/月详情视图高度偏移量
    SchedulerBinding.instance.addPostFrameCallback((_) {
      RenderBox box = containerKey.currentContext.findRenderObject();
      // 获取屏幕顶部偏移量
      Offset offset = box.localToGlobal(Offset.zero);
      // 整个日程布局高度。
      final height = box.size.height + MediaQuery.of(context).viewInsets.bottom;
      print("endOfFrame: ${box.size},  $offset, ${box.paintBounds}");
      _model.fullHeight = height;
      _model.minHeight = max(45, height / 3 / WEEK_IN_MONTH);
      _model.centerHeight = _model.minHeight * WEEK_IN_MONTH;
      setState(() {});
      modifyMode();
    });
    super.initState();
  }

  sliverHeader({QCalHolder model, pinned = true, QCalendarRender render}) {
    if (model == null) model = _model;
    this._model = model;
    if (render == null) render = QCalendarRender();
    return SliverPersistentHeader(
      delegate: QCalSliverHeaderDelegate(this, render: render),
      pinned: pinned,
    );
  }

  customScrollView(ScrollController _scrollController, CustomScrollView child) {
    this._scrollController = _scrollController;
    return NotificationListener<OverscrollNotification>(
      // 滑动结束后，检查是否需要切换 年月日视图模式
      onNotification: (OverscrollNotification notification) =>
          checkModifyMode(notification),
      child: NotificationListener<ScrollEndNotification>(
        // 滑动结束后，检查是否需要切换 年月日视图模式
        onNotification: (ScrollEndNotification notification) =>
            checkIfNeedChangeCalViewModel(notification),
        child: Container(
          child: child,
          height: double.infinity,
          key: containerKey,
        ),
      ),
    );
  }

  // 检查是否需要切换视图模式。
  bool checkIfNeedChangeCalViewModel(ScrollEndNotification notification) {
    checkModifyMode(notification);
    modifyMode();
    return false;
  }

  modifyMode() {
    switch (_model.mode) {
      case Mode.MONTH:
        _scroll(_model.fullHeight - _model.centerHeight);
        break;
      case Mode.WEEK:
        _scroll(_model.fullHeight - _model.minHeight);
        break;
      case Mode.DETAIL:
      default:
        _scroll(0.0);
    }
  }

  /// 延时检查 是否发生模式切换
  _scroll(offsetY) {
    var off = (_scrollController.offset - offsetY).abs();
    print("_scroll: $offsetY - ${_scrollController.offset} = $off");
    if (off < 1) return;
    if (_timer != null) _timer.cancel();
    _timer = Timer(Duration(milliseconds: 2), () {
      var duration = 10 + (off / 100.0 * 20).toInt();
      _scrollController.animateTo(offsetY,
          duration: Duration(milliseconds: duration), curve: Curves.linear);
      print(
          "animatedTo:  ${_scrollController.offset} => $offsetY: ,duration: $duration");
    });
  }

  /// 根据当前滑动位置，计算是否需要修改视图模式
  bool checkModifyMode(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    print('------------------------');
    ScrollMetrics metrics = notification.metrics;
    // 当前滑动偏移量，与全屏/半屏/周试图位置比较。获取松手后的视图模式。
    double offset2Top = (_model.fullHeight - metrics.extentBefore).abs();
    double offset2Center =
        (_model.fullHeight - _model.centerHeight - metrics.extentBefore).abs();
    double offset2Detail = (metrics.extentBefore).abs();
    Mode mode;
    if (offset2Top < offset2Center) {
      mode = offset2Top < offset2Detail ? Mode.WEEK : Mode.DETAIL;
    } else {
      mode = offset2Center < offset2Detail ? Mode.MONTH : Mode.DETAIL;
    }
    if (_model.mode != mode) {
      print("modifyMode: ${_model.mode} = $mode");
      // 修改模式通知更新UI。
      _model.mode = mode;
      setState(() {});
    }
    return false;
  }
}

//
class QCalSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  QCalendarRender render;
  QCalendarWidgetMixin container;

  QCalSliverHeaderDelegate(this.container, {this.render}) {
    if (render == null) render = QCalendarRender();
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return PageView.builder(
        itemCount: maxSize,
        controller: PageController(initialPage: offsetMid),
        physics: ClampingScrollPhysics(),
        onPageChanged: (page) => container.focusDateByPage(page),
        itemBuilder: (context, pos) => QCalendarView(
            pos, container._model, render, container.onSelectDate));
  }

  @override
  double get maxExtent => container._model.fullHeight;

  @override
  double get minExtent => container._model.minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
