import 'package:fish_redux/fish_redux.dart';

enum EditAction {
  onCommit,
}

class EditActionCreator {
  static Action onCommitAction() {
    return const Action(EditAction.onCommit);
  }
}
