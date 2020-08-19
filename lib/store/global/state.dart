import 'package:fish_redux/fish_redux.dart';

abstract class GlobalBaseState {}

class GlobalState implements GlobalBaseState, Cloneable<GlobalState> {
  @override
  GlobalState clone() {
    return GlobalState();
  }
}
