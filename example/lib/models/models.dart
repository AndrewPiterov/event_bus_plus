import 'package:event_bus_plus/event_bus_plus.dart';

class FollowAppEvent extends AppEvent {
  FollowAppEvent(this.username, {String? id});

  final String username;

  @override
  List<Object?> get props => [
        username,
      ];
}

class NewComment extends AppEvent {
  NewComment(this.text, {String? id});

  final String text;

  @override
  List<Object?> get props => [
        text,
      ];
}
