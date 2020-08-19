import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class EventListPage extends Page<ListState, Map<String, dynamic>> {
  EventListPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ListState>(
              adapter: null, slots: <String, Dependent<ListState>>{}),
          middleware: <Middleware<ListState>>[],
        );
}
