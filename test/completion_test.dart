import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'models.dart';
import 'package:test/test.dart';

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
          EmptyEvent(),
          const FollowAppEvent('username3'),
          EmptyEvent(),
          const FollowAppEvent('username2'),
          EmptyEvent(),
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
          EmptyEvent(),
          const EventCompletionEvent(watchable),
          EmptyEvent(),
          const FollowSuccessfullyEvent(watchable),
          EmptyEvent(),
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
