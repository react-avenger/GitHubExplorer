import 'package:github_explorer/listener/state_listener.dart';

enum ObserverState { INIT, SAVE_REPOSITORY, UN_SAVE_REPOSITORY }

class StateProvider {
  List<StateListener> observers;

  static final StateProvider _instance = new StateProvider.internal();

  factory StateProvider() => _instance;

  StateProvider.internal() {
    observers = new List<StateListener>();
    initState();
  }

  void initState() async {
    notify(ObserverState.INIT);
  }

  void subscribe(StateListener listener) {
    observers.add(listener);
  }

  void notify(dynamic state) {
    observers.forEach((StateListener obj) => obj.onStateChanged(state));
  }

  void dispose(StateListener thisObserver) {
    for (var obj in observers) {
      if (obj == thisObserver) {
        observers.remove(obj);
      }
    }
  }
}
