import 'package:clock/clock.dart';
import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';
import 'dart:developer' as dev;

import 'models.dart';

void main() {
  late IEventBus bus;

  before(() {
    bus = EventBus(maxHistoryLength: 3);
  });

  test('right timestamp', () {
    final date = DateTime(2022, 9, 1);
    withClock(Clock.fixed(date), () {
      bus.fire(const SomeEvent());
      bus.fire(const SomeAnotherEvent());
      bus.fire(const FollowAppEvent('@username'));

      for (final e in bus.history) {
        e.timestamp.should.be(date);
        dev.log(e.toString());
      }

      bus.history.should.be([
        EventBusHistoryEntry(const SomeEvent(), date),
        EventBusHistoryEntry(const SomeAnotherEvent(), date),
        EventBusHistoryEntry(const FollowAppEvent('@username'), date),
      ]);
    });
  });
}
