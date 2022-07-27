import 'package:rxdart/subjects.dart';

import 'app_event.dart';
import 'subscription.dart';

abstract class IEventBus {
  bool get isBusy;
  Stream<bool> get isBusy$;

  AppEvent? get last;
  Stream<AppEvent?> get last$;

  Stream<List<AppEvent>> get inProgress$;

  Stream<T> on<T extends AppEvent>();
  Stream<bool> whileInProgress<T extends AppEvent>();
  Subscription respond<T>(Responder<T> responder);

  // Methods
  void fire(AppEvent event);
  void watch(AppEvent event);
  void complete(AppEvent event, {AppEvent? nextEvent});
  bool isInProgress<T>();

  void reset();

  void dispose();
}

class EventBus implements IEventBus {
  @override
  bool get isBusy => _inProgress.value.isNotEmpty;
  @override
  Stream<bool> get isBusy$ => _inProgress.map((event) => event.isNotEmpty);

  final _lastEvent = BehaviorSubject<AppEvent>();
  @override
  AppEvent? get last => _lastEvent.valueOrNull;
  @override
  Stream<AppEvent?> get last$ => _lastEvent.distinct();

  final _inProgress = BehaviorSubject<List<AppEvent>>.seeded([]);
  List<AppEvent> get _isInProgressEvents => _inProgress.value;
  @override
  Stream<List<AppEvent>> get inProgress$ => _inProgress;

  @override
  void fire(AppEvent event) {
    _lastEvent.add(event);
  }

  @override
  void watch(AppEvent event) {
    fire(event);
    _inProgress.add([
      ..._isInProgressEvents,
      event,
    ]);
  }

  @override
  void complete(AppEvent event, {AppEvent? nextEvent}) {
    final newArr = _isInProgressEvents.toList()..removeWhere((e) => e == event);
    _inProgress.add(newArr);
    if (nextEvent != null) {
      fire(nextEvent);
    }
  }

  @override
  bool isInProgress<T>() {
    return _isInProgressEvents.whereType<T>().isNotEmpty;
  }

  @override
  Stream<T> on<T extends AppEvent>() {
    if (T == dynamic) {
      return _lastEvent.stream as Stream<T>;
    } else {
      return _lastEvent.stream.where((event) => event is T).cast<T>();
    }
  }

  /// Subscribe `EventBus` on a specific type of event, and register responder to it.
  ///
  /// When [T] is not given or given as `dynamic`, it listens to all events regardless of the type.
  /// Returns [Subscription], which can be disposed to cancel all the subscription registered to itself.
  @override
  Subscription respond<T>(Responder<T> responder) =>
      Subscription(_lastEvent).respond<T>(responder);

  @override
  void reset() {
    _inProgress.add([]);
    _lastEvent.add(EmptyEvent());
  }

  @override
  void dispose() {
    _inProgress.close();
    _lastEvent.close();
  }

  @override
  Stream<bool> whileInProgress<T extends AppEvent>() {
    return _inProgress.map((events) {
      return events.whereType<T>().isNotEmpty;
    });
  }
}
