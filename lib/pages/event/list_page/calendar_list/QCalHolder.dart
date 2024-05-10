import 'dart:ui';

import 'QCalModel.dart';
import 'QCalculator.dart';

enum Mode { WEEK, MONTH, DETAIL }

/// 最大左右可滑动页码数。
const int maxSize = 200;

/// 当前默认页码位置id
const int offsetMid = maxSize >> 1;

/// 内存缓存记录类
class QCalHolder {
  Mode mode;
  int currPage = offsetMid;
  double fullHeight = 0, centerHeight = 0, minHeight = 50.0;
  Date focusDateTime = Date.from(DateTime.now());

  QCalHolder({this.mode = Mode.WEEK}) {
    fullHeight = window.physicalSize.height / window.devicePixelRatio;
  }

  Date getDateTime(int offs) {
    switch (mode) {
      case Mode.WEEK:
        return QCalculator.offsetWeekTo(focusDateTime, offs - currPage);
      default:
        return QCalculator.offsetMonthTo(focusDateTime, offs - currPage);
    }
  }
}
