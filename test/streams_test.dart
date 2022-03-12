import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'models.dart';

void main() {
  late IAppEventBus _bus;

  before(() {
    _bus = AppEventBus();
  });

  test('description', () {
    _bus.inProgress$.map((List<AppEvent> events) =>
        events.whereType<FollowAppEvent>().isNotEmpty);
  }, skip: 'should skip');

  test('emit Follower Event', () {
    const id = 'id';
    expect(_bus.on(), emitsInAnyOrder([FollowAppEvent('username', id: id)]));
    _bus.fire(FollowAppEvent('username', id: id));
  });

  test('emit Follower Events', () {
    expect(
        _bus.on(),
        emitsInAnyOrder([
          FollowAppEvent('username', id: '1'),
          FollowAppEvent('username3', id: '3'),
          FollowAppEvent('username2', id: '2'),
        ]));

    _bus.fire(FollowAppEvent('username3', id: '3'));
    _bus.fire(FollowAppEvent('username', id: '1'));
    _bus.fire(FollowAppEvent('username2', id: '2'));
  });

  test('emit New Comment Event', () {
    expect(
        _bus.on<NewComment>(),
        emitsInAnyOrder([
          NewComment('comment #1', id: '3'),
          NewComment('comment #2', id: '2'),
        ]));

    _bus.fire(FollowAppEvent('username3', id: '3234234'));
    _bus.fire(FollowAppEvent('username3', id: '3111'));
    _bus.fire(NewComment('comment #1', id: '3'));
    _bus.fire(FollowAppEvent('username3', id: '333'));
    _bus.fire(NewComment('comment #2', id: '2'));
    _bus.fire(FollowAppEvent('username3', id: '31234'));
  });
}
