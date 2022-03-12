import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:test/scaffolding.dart';
import 'package:shouldly/shouldly.dart';

import 'models.dart';

void main() {
  late IEventBus _bus;

  before(() {
    _bus = EventBus();
  });

  test('Empty event bus', () {
    _bus.isBusy.should.beFalse();
  });

  when('start some event', () {
    final event = FollowAppEvent('username');
    // const eventId = '1';

    before(() {
      _bus.watch(event);
    });

    then('should be busy', () {
      _bus.isBusy.should.beTrue();
    });

    then('should be in progress', () {
      _bus.isInProgress<FollowAppEvent>().should.beTrue();
    });

    and('complete the event', () {
      before(() {
        _bus.complete(event);
      });

      then('should not be busy', () {
        _bus.isBusy.should.beFalse();
      });

      then('should not be in progress', () {
        _bus.isInProgress<FollowAppEvent>().should.not.beTrue();
      });
    });
  });

  group('compare equality', () {
    test('compare two equal events - should not be equal', () {
      final event = FollowAppEvent('username');
      final event2 = FollowAppEvent('username');
      event.should.not.be(event2);
    });

    test('compare two equal events - should be equal', () {
      final event = FollowAppEvent('username', id: '1');
      final event2 = FollowAppEvent('username', id: '1');
      event.should.be(event2);
    });
  });
}
