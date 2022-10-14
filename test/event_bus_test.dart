import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/scaffolding.dart';

import 'models.dart';

void main() {
  late IEventBus bus;

  before(() {
    bus = EventBus();
  });

  test('Empty event bus', () {
    bus.isBusy.should.beFalse();
  });

  when('start some event', () {
    const event = FollowAppEvent('username');
    // const eventId = '1';

    before(() {
      bus.watch(event);
    });

    then('should be busy', () {
      bus.isBusy.should.beTrue();
    });

    then('should be in progress', () {
      bus.isInProgress<FollowAppEvent>().should.beTrue();
    });

    and('complete the event', () {
      before(() {
        bus.complete(event);
      });

      then('should not be busy', () {
        bus.isBusy.should.beFalse();
      });

      then('should not be in progress', () {
        bus.isInProgress<FollowAppEvent>().should.not.beTrue();
      });
    });
  });

  group('compare equality', () {
    // test('compare two equal events - should not be equal', () {
    //   final event = FollowAppEvent('username');
    //   final event2 = FollowAppEvent('username');
    //   event.should.not.be(event2);
    // });

    test('compare two equal events - should be equal', () {
      const event = FollowAppEvent('username');
      const event2 = FollowAppEvent('username');
      event.should.be(event2);
    });
  });
}
