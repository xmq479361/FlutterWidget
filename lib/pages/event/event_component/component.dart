import 'package:fish_redux/fish_redux.dart';

import 'state.dart';
import 'view.dart';

class EventComponent extends Component<EventState> {
  EventComponent()
      : super(
          view: buildView,
          dependencies: Dependencies<EventState>(
              adapter: null, slots: <String, Dependent<EventState>>{}),
        );
}
