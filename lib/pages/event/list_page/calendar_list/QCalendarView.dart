import 'package:flutter/material.dart';

import 'QCalHolder.dart';
import 'QCalModel.dart';
import 'QCalculator.dart';
import 'QCalendarPainter.dart';
import 'QCalendarRender.dart';

/// 触发重新布局方法。
typedef RebuildView = void Function();
typedef OnSelectDate = void Function(Date);

/// 日历
class QCalendarView extends StatefulWidget {
  final QCalHolder mModel;
  final int pos;
  final QCalendarRender render;
  OnSelectDate onSelectDate;

  QCalendarView(this.pos, this.mModel, this.render, this.onSelectDate);

  @override
  _QCalendarViewState createState() => _QCalendarViewState();
}

class _QCalendarViewState extends State<QCalendarView> {
  GlobalKey containerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapUp: _selectDate,
      child: Container(
        height: double.infinity,
        key: containerKey,
        child: CustomPaint(
          painter: QCalendarPainter(
              context, widget.pos, widget.mModel, widget.render),
        ),
      ),
    );
  }

  void _selectDate(TapUpDetails details) {
    Offset offset = details.localPosition;
    print("  >>>onTapUp ${containerKey.currentContext.size}. $offset");
    Date focusDate = QCalculator.calcFocusDateByOffset(
        offset,
        containerKey.currentContext.size,
        widget.mModel,
        QCalculator.generate(widget.mModel.getDateTime(widget.pos)));
    if (widget.mModel.focusDateTime.isEquals(focusDate)) return;
    widget.onSelectDate(focusDate);
  }
}
