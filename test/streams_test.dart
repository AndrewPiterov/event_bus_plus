import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:test/test.dart';
import 'models.dart';

void main() {
  late IEventBus _bus;

  before(() {
    _bus = EventBus();
  });

  test('description', () {
    _bus.inProgress$.map((List<AppEvent> events) =>
        events.whereType<FollowAppEvent>().isNotEmpty);
  }, skip: 'should skip');

  test('emit Follower Event', () {
    const id = 'id';
    expect(_bus.on(), emitsInAnyOrder([FollowAppEvent('username')]));
    _bus.fire(FollowAppEvent('username'));
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

  test('emit New Comment Event', () {
    expect(
        _bus.on<NewCommentEvent>(),
        emitsInOrder([
          NewCommentEvent('comment #1'),
          NewCommentEvent('comment #2'),
        ]));

    _bus.fire(FollowAppEvent('username3'));
    _bus.fire(FollowAppEvent('username3'));
    _bus.fire(NewCommentEvent('comment #1'));
    _bus.fire(FollowAppEvent('username3'));
    _bus.fire(NewCommentEvent('comment #2'));
    _bus.fire(FollowAppEvent('username3'));
  });
}
