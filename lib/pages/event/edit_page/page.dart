import 'package:fish_redux/fish_redux.dart';

import '../event_component/state.dart' hide initState;
import 'datetime_picker_component/component.dart';
import 'datetime_picker_component/state.dart' hide initState;
import 'effect.dart';
import 'state.dart';
import 'view.dart';

//组件连接器
class EventTimeComponentConnector
    extends ConnOp<EditState, DatetimePickerState> {
  @override
  DatetimePickerState get(EditState state) {
    return state.componentState;
  }

  @override
  void set(EditState state, DatetimePickerState subState) {
    state.componentState = subState;
  }
}

class EventEditPage extends Page<EditState, EventState> {
  EventEditPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          view: buildView,
          dependencies: Dependencies<EditState>(
              adapter: null,
              slots: <String, Dependent<EditState>>{
                "DateTimePickerComponent":
                    EventTimeComponentConnector() + DatetimePickerComponent()
              }),
          middleware: <Middleware<EditState>>[],
        );
}
