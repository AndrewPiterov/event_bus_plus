import 'package:event_bus_plus/event_bus_plus.dart';

class FollowAppEvent extends AppEvent {
  FollowAppEvent(this.username, {String? id}) : super(id: id);

  final String username;

  @override
  List<Object?> get props => [
        id,
        username,
      ];
}

class FollowSuccessfullyAppEvent extends AppEvent {
  final FollowAppEvent starting;

  FollowSuccessfullyAppEvent(this.starting);

  @override
  List<Object?> get props => [starting];
}

class NewComment extends AppEvent {
  NewComment(this.text, {String? id}) : super(id: id);

  final String text;

  @override
  List<Object?> get props => [
        id,
        text,
      ];
}
