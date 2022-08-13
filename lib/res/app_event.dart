import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class EventCompletionEvent extends AppEvent {
  const EventCompletionEvent(this.event);

  final AppEvent event;

  @override
  List<Object> get props => [event];
}

class EmptyEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}
