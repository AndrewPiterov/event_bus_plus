import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:test/test.dart';

import 'models.dart';

void main() {
  late IEventBus _bus;

  before(() {
    _bus = EventBus();
  });

  test('emit Follower Events', () {
    expect(
        _bus.on(),
        emitsInOrder([
          FollowAppEvent('username'),
          FollowAppEvent('username3'),
          FollowAppEvent('username2'),
        ]));

    _bus.fire(FollowAppEvent('username'));
    _bus.fire(FollowAppEvent('username3'));
    _bus.fire(FollowAppEvent('username2'));
  });

  test('start watch but not complete', () {
    expect(
        _bus.on(),
        emitsInOrder([
          FollowAppEvent('username'),
        ]));

    _bus.watch(FollowAppEvent('username'));
  });

  test('start watch and complete', () {
    final watchable = FollowAppEvent('username3');
    expect(
        _bus.on(),
        emitsInOrder([
          watchable,
          FollowSuccessfullyEvent(watchable),
        ]));

    _bus.watch(watchable);
    _bus.complete(watchable, nextEvent: FollowSuccessfullyEvent(watchable));
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
