import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class DatetimePickerComponent extends Component<DatetimePickerState> {
  DatetimePickerComponent()
      : super(
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<DatetimePickerState>(
              adapter: null, slots: <String, Dependent<DatetimePickerState>>{}),
        );
}
