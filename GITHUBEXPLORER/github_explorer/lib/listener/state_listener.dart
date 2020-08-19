import 'package:github_explorer/observer/repository_observer.dart';

abstract class StateListener {
  void onStateChanged(ObserverState state);
}
