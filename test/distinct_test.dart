import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'models.dart';

void main() {
  late IEventBus bus;

  before(() {
    bus = EventBus();
  });

  test('Call once', () {
    expectLater(
        bus.last$,
        emitsInOrder([
          const SomeEvent(),
          EmptyEvent(),
          const SomeAnotherEvent(),
          EmptyEvent(),
        ]));
    bus.fire(const SomeEvent());
    bus.fire(const SomeAnotherEvent());
  });

  // test('Call twice', () {
  //   const event = SomeEvent();
  //   expectLater(
  //       bus.last$,
  //       emitsInOrder([
  //         const SomeEvent(),
  //         EmptyEvent(),
  //         const SomeAnotherEvent(),
  //         EmptyEvent(),
  //       ]));
  //   bus.fire(event);
  //   bus.fire(event);
  //   bus.fire(const SomeAnotherEvent());
  // });

  // test('Call three times', () {
  //   const event = SomeEvent();
  //   expectLater(
  //       bus.last$,
  //       emitsInOrder([
  //         const SomeEvent(),
  //         EmptyEvent(),
  //         const SomeAnotherEvent(),
  //         EmptyEvent(),
  //       ]));
  //   bus.fire(event);
  //   bus.fire(event);
  //   bus.fire(event);
  //   bus.fire(const SomeAnotherEvent());
  // });
}
