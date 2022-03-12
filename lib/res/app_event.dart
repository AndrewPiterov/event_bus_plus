import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  AppEvent({String? id}) {
    final date = DateTime.now();
    this.id = id ?? date.microsecondsSinceEpoch.toString();
    this.date = date;
  }

  late String id;
  late DateTime date;

  @override
  List<Object?> get props => [id, date];
}

class EmptyEvent extends AppEvent {}
