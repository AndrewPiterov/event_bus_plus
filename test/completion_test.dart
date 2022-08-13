import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:test/test.dart';

import 'models.dart';

void main() {
  late IEventBus bus;

  before(() {
    bus = EventBus();
  });

  test('emit Follower Events', () {
    expect(
        bus.on(),
        emitsInOrder([
          const FollowAppEvent('username'),
          const FollowAppEvent('username3'),
          const FollowAppEvent('username2'),
        ]));

    bus.fire(const FollowAppEvent('username'));
    bus.fire(const FollowAppEvent('username3'));
    bus.fire(const FollowAppEvent('username2'));
  });

  test('start watch but not complete', () {
    expect(
        bus.on(),
        emitsInOrder([
          const FollowAppEvent('username'),
        ]));

    bus.watch(const FollowAppEvent('username'));
  });

  test('start watch and complete', () {
    const watchable = FollowAppEvent('username3');
    expect(
        bus.on(),
        emitsInOrder([
          watchable,
          const EventCompletionEvent(watchable),
          const FollowSuccessfullyEvent(watchable),
        ]));

    bus.watch(watchable);
    bus.complete(watchable,
        nextEvent: const FollowSuccessfullyEvent(watchable));
  });

  // test('emit Follower Events', () {
  //   final watchable = FollowAppEvent('username3', id: '3');
  //   expect(
  //       _bus.on(),
  //       emitsInAnyOrder([
  //         FollowAppEvent('username3', id: '3'),
  //         FollowSuccessfullyAppEvent(watchable),
  //       ]));

  //   _bus.watch(watchable);
  //   _bus.complete(watchable, withh: FollowSuccessfullyAppEvent(watchable));
  // });
}
