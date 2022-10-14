import 'dart:developer';

import 'package:clock/clock.dart';
import 'package:rxdart/subjects.dart';

import 'app_event.dart';
import 'history_entry.dart';
import 'subscription.dart';

/// The event bus interface
abstract class IEventBus {
  bool get isBusy;
  Stream<bool> get isBusy$;

  AppEvent? get last;
  Stream<AppEvent?> get last$;

  Stream<List<AppEvent>> get inProgress$;

  Stream<T> on<T extends AppEvent>();
  Stream<bool> whileInProgress<T extends AppEvent>();
  Subscription respond<T>(Responder<T> responder);

  List<EventBusHistoryEntry> get history;

  /// Fire a event
  void fire(AppEvent event);

  /// Fire a event and wait for it to be completed
  void watch(AppEvent event);

  /// Complete a event
  void complete(AppEvent event, {AppEvent? nextEvent});

  bool isInProgress<T>();

  void reset();

  void dispose();

  void clearHistory();
}

/// The event bus implementation
class EventBus implements IEventBus {
  /// Create the event bus
  EventBus({
    this.maxHistoryLength = 100,
    this.map = const {},
  });

  static const _logName = 'EventBus';

  /// The maximum length of history
  final int maxHistoryLength;
  final Map<Type, List<AppEvent Function(AppEvent event)>> map;

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
  List<EventBusHistoryEntry> get history => List.unmodifiable(_history);
  final List<EventBusHistoryEntry> _history = [];

  @override
  void fire(AppEvent event) {
    if (_history.length >= maxHistoryLength) {
      _history.removeAt(0);
    }
    final now = clock.now();
    _history.add(EventBusHistoryEntry(event, now));
    _lastEvent.add(event);
    _map(event);
    log(' ⚡️ [$now] $event', name: _logName);
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
    // complete the event
    if (_isInProgressEvents.any((e) => e == event)) {
      final newArr = _isInProgressEvents.toList()
        ..removeWhere((e) => e == event);
      _inProgress.add(newArr);
      fire(EventCompletionEvent(event));
    }

    // fire next event if any
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
  Stream<bool> whileInProgress<T extends AppEvent>() {
    return _inProgress.map((events) {
      return events.whereType<T>().isNotEmpty;
    });
  }

  void _map(AppEvent? event) {
    if (event == null) {
      return;
    }

    final functions = map[event.runtimeType] ?? [];
    if (functions.isEmpty) {
      return;
    }

    for (final func in functions) {
      final newEvent = func(event);
      if (newEvent.runtimeType == event.runtimeType) {
        log(
          ' 🟠 SKIP EVENT: ${newEvent.runtimeType} => ${event.runtimeType}',
          name: _logName,
        );
        continue;
      }
      fire(newEvent);
    }
  }

  @override
  void clearHistory() {
    _history.clear();
  }

  @override
  void reset() {
    clearHistory();
    _inProgress.add([]);
    _lastEvent.add(EmptyEvent());
  }

  @override
  void dispose() {
    _inProgress.close();
    _lastEvent.close();
  }
}
