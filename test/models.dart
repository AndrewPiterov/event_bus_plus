import 'package:event_bus_plus/event_bus_plus.dart';

class FollowAppEvent extends AppEvent {
  const FollowAppEvent(this.username);

  final String username;

  @override
  List<Object?> get props => [username];
}

class FollowSuccessfullyEvent extends AppEvent {
  const FollowSuccessfullyEvent(this.starting);

  final FollowAppEvent starting;

  @override
  List<Object?> get props => [starting];
}

class NewCommentEvent extends AppEvent {
  const NewCommentEvent(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}
