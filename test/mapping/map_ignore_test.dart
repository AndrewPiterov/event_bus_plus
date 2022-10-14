import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:test/test.dart';

import '../models.dart';

void main() {
  late IEventBus bus;

  before(
    () {
      bus = EventBus(
        map: {
          SomeEvent: [
            (e) => e,
            (e) => const SomeAnotherEvent(),
          ],
        },
      );
    },
  );

  test('does not emit the same event', () {
    expect(
      bus.last$,
      emitsInOrder(
        [
          const SomeEvent(),
          const SomeAnotherEvent(),
        ],
      ),
    );
    bus.fire(const SomeEvent());
  }, timeout: const Timeout(Duration(seconds: 1)));
}
