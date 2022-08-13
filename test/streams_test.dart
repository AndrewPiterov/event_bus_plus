import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:test/test.dart';
import 'models.dart';

void main() {
  late IEventBus bus;

  before(() {
    bus = EventBus();
  });

  test('description', () {
    bus.inProgress$.map((List<AppEvent> events) =>
        events.whereType<FollowAppEvent>().isNotEmpty);
  }, skip: 'should skip');

  test('emit Follower Event', () {
    const id = 'id';
    expect(bus.on(), emitsInAnyOrder([const FollowAppEvent('username')]));
    bus.fire(const FollowAppEvent('username'));
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

  test('emit New Comment Event', () {
    expect(
        bus.on<NewCommentEvent>(),
        emitsInOrder([
          const NewCommentEvent('comment #1'),
          const NewCommentEvent('comment #2'),
        ]));

    bus.fire(const FollowAppEvent('username3'));
    bus.fire(const FollowAppEvent('username3'));
    bus.fire(const NewCommentEvent('comment #1'));
    bus.fire(const FollowAppEvent('username3'));
    bus.fire(const NewCommentEvent('comment #2'));
    bus.fire(const FollowAppEvent('username3'));
  });
}
