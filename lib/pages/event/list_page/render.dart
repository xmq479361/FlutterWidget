import 'package:flutter/material.dart';
import 'calendar_list/QCalHolder.dart';
import 'calendar_list/QCalModel.dart';
import 'calendar_list/QCalendarRender.dart';
import '../event_component/state.dart';
import 'state.dart';

/// 自定义日程View渲染处理
class EventQCalendarRender extends QCalendarRender {
  ListState eventState;
  EventQCalendarRender(this.eventState);

  final TextPainter descPainter = TextPainter()
    ..textDirection = TextDirection.ltr;
  /**
   * 日期对应视图渲染
   */
  void renderDate(Canvas canvas, Size fullSize, Size weekSize, Size size,
      QCalHolder model, Date date) {
    // print("")
    // 被选中的日期
    if (model.focusDateTime.isEquals(date)) {
      final double cirSize = circleSize(size);
      dateTextPainter.text = createTextSpan(date, model, isFocus: true);
      dateTextPainter.layout();
      canvas.drawOval(
          Rect.fromCenter(
              width: cirSize,
              height: cirSize,
              center:
                  Offset(size.width / 2, topMargin() + dateTextPainter.height)),
          focusCirclePaint());
      dateTextPainter.paint(
          canvas,
          Offset((size.width - dateTextPainter.width) / 2,
              topMargin() + dateTextPainter.height / 2));
    } else if (date.isToday()) {
      // 当天
      final double cirSize = circleSize(size);
      dateTextPainter.text = createTextSpan(date, model, isToday: true);
      dateTextPainter.layout();
      canvas.drawOval(
          Rect.fromCenter(
              width: cirSize,
              height: cirSize,
              center:
                  Offset(size.width / 2, topMargin() + dateTextPainter.height)),
          todayCirclePaint());
      dateTextPainter.paint(
          canvas,
          Offset((size.width - dateTextPainter.width) / 2,
              topMargin() + dateTextPainter.height / 2));
    } else {
      dateTextPainter.text = createTextSpan(date, model);
      dateTextPainter.layout();
      dateTextPainter.paint(
          canvas,
          Offset((size.width - dateTextPainter.width) / 2,
              topMargin() + dateTextPainter.height / 2));
    }
    List<EventState> dateEvents = eventState.dateEvents(date);
    if (dateEvents.isEmpty) return;
    if (model.mode == Mode.DETAIL && fullSize.height >= model.fullHeight) {
      // print("当天数据$date(${dateEvents.length}), $dateEvents");
      final double cirSize = circleSize(size);
      var margin = 4.0, offsetY = cirSize, width = size.width - margin * 2;
      for (EventState event in dateEvents) {
        offsetY += margin;
        var text = event.title;
        descPainter.text = TextSpan(text: text, style: normalTextStyle());
        descPainter.layout();
        while (descPainter.width > width) {
          text = text.substring(0, text.length - 2);
          descPainter.text =
              TextSpan(text: "$text..", style: normalTextStyle());
          descPainter.layout();
        }
        if (size.height < offsetY + descPainter.height) break;
        canvas.drawRect(
            Rect.fromLTWH(margin / 2, offsetY + descPainter.height / 2,
                width - margin / 2, descPainter.height),
            focusCirclePaint());
        descPainter.paint(
            canvas,
            Offset((width - descPainter.width + margin) / 2,
                offsetY + descPainter.height / 2));
        offsetY += descPainter.height;
      }
    } else {
      final double cirSize = circleSize(size);
      canvas.drawOval(
          Rect.fromCenter(
              width: 4.0,
              height: 4.0,
              center: Offset(size.width / 2, topMargin() * 2 + 2 + cirSize)),
          dateHasEventPointPaint);
    }
  }

  final Paint dateHasEventPointPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill
    ..strokeWidth = 1
    ..isAntiAlias = true;
}
