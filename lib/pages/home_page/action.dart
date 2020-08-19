import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum HomeAction { event }

class HomeActionCreator {
  static Action enterEventAction() {
    return const Action(HomeAction.event);
  }
}
