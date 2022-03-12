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
          FollowAppEvent('username', id: '1'),
          FollowAppEvent('username3', id: '3'),
          FollowAppEvent('username2', id: '2'),
        ]));

    _bus.fire(FollowAppEvent('username', id: '1'));
    _bus.fire(FollowAppEvent('username3', id: '3'));
    _bus.fire(FollowAppEvent('username2', id: '2'));
  });

  test('start watch but not complete', () {
    expect(
        _bus.on(),
        emitsInOrder([
          FollowAppEvent('username', id: '1'),
        ]));

    _bus.watch(FollowAppEvent('username', id: '1'));
  });

  test('start watch and complete', () {
    final watchable = FollowAppEvent('username3', id: '3');
    expect(
        _bus.on(),
        emitsInOrder([
          watchable,
          FollowSuccessfullyAppEvent(watchable),
        ]));

    _bus.watch(watchable);
    _bus.complete(watchable, nextEvent: FollowSuccessfullyAppEvent(watchable));
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
