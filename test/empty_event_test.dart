import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:test/test.dart';
import 'models.dart';

void main() {
  final IEventBus _bus = EventBus();

  test('Should fire Empty event', () {
    expect(
      _bus.last$,
      emitsInOrder(
        [
          const SomeEvent(),
          EmptyEvent(),
        ],
      ),
    );
    _bus.fire(const SomeEvent());
  }, timeout: const Timeout(Duration(seconds: 1)));
}
