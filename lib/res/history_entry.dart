import 'package:equatable/equatable.dart';

import 'app_event.dart';

class EventBusHistoryEntry extends Equatable {
  const EventBusHistoryEntry(this.event, this.timestamp);

  final AppEvent event;
  final DateTime timestamp;

  @override
  List<Object?> get props => [event, timestamp];
}
