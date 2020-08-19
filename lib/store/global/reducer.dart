import "package:fish_redux/fish_redux.dart";
import 'state.dart';

Reducer<GlobalState> buildReducer() {
  return asReducer(<Object, Reducer<GlobalState>>{});
}
