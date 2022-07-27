import 'package:clock/clock.dart';
import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

import 'models.dart';

void main() {
  late IEventBus bus;

  before(() {
    bus = EventBus(maxHistoryLength: 3);
  });

  test('Keep history', () {
    final date = DateTime(2022, 9, 1);
    withClock(Clock.fixed(date), () {
      bus.fire(const SomeEvent());
      bus.fire(const SomeAnotherEvent());
      bus.fire(const FollowAppEvent('@username'));

      bus.history.should.be([
        EventBusHistoryEntry(const SomeEvent(), date),
        EventBusHistoryEntry(const SomeAnotherEvent(), date),
        EventBusHistoryEntry(const FollowAppEvent('@username'), date),
      ]);
    });
  });

  test('Keep full history without debounce', () {
    final date = DateTime(2022, 9, 1, 4, 59, 55);
    withClock(Clock.fixed(date), () {
      bus.fire(const SomeEvent());
      bus.fire(const SomeEvent());
      bus.fire(const SomeAnotherEvent());

      bus.history.should.be([
        EventBusHistoryEntry(const SomeEvent(), date),
        EventBusHistoryEntry(const SomeEvent(), date),
        EventBusHistoryEntry(const SomeAnotherEvent(), date),
      ]);
    });
  });

  test('Clear history', () {
    bus.fire(const SomeEvent());
    bus.fire(const SomeAnotherEvent());

    bus.clearHistory();

    bus.history.should.beEmpty();
  });

  group('History length', () {
    test('Add more than max', () {
      final date = DateTime(2022, 9, 1, 4, 59, 55);

      withClock(Clock.fixed(date), () {
        bus.fire(const SomeEvent());
        bus.fire(const SomeAnotherEvent());
        bus.fire(const FollowAppEvent('@username'));
        bus.fire(const NewCommentEvent('text'));

        bus.history.length.should.be(3);

        bus.history.should.be([
          EventBusHistoryEntry(const SomeAnotherEvent(), date),
          EventBusHistoryEntry(const FollowAppEvent('@username'), date),
          EventBusHistoryEntry(const NewCommentEvent('text'), date),
        ]);
      });
    });
  });
}
