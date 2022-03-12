import 'dart:async';
import 'dart:developer';

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

  test('emit Some Event', () {
    final ctrl = StreamController();

    final sub = _bus.respond<NewComment>((event) {
      log('new comment');
      ctrl.add(2);
    }).respond<FollowAppEvent>((event) {
      log('new follower');
      ctrl.add(1);
    });

    expect(ctrl.stream, emitsInOrder([1, 2]));

    _bus.fire(FollowAppEvent('username', id: '1'));
    _bus.fire(NewComment('comment #1', id: '2'));
  });

  test('emit Some Events', () {
    final ctrl = StreamController();

    final sub = _bus.respond<NewComment>((event) {
      log('new comment');
      ctrl.add(2);
    }).respond<FollowAppEvent>((event) {
      log('new follower');
      ctrl.add(1);
    });

    expect(ctrl.stream, emitsInOrder([1, 2, 1]));

    _bus.fire(FollowAppEvent('username', id: '1'));
    _bus.fire(NewComment('comment #1', id: '2'));
    _bus.fire(FollowAppEvent('username2', id: '11'));
  });

  test('emit all Event', () {
    final ctrl = StreamController();

    final sub = _bus.respond<NewComment>((event) {
      log('new comment');
      ctrl.add(2);
    }).respond<FollowAppEvent>((event) {
      log('new follower');
      ctrl.add(1);
    }).respond((event) {
      log('event $event');
      ctrl.add(3);
    });

    expect(ctrl.stream, emitsInOrder([1, 3, 2, 3]));

    _bus.fire(FollowAppEvent('username', id: '1'));
    _bus.fire(NewComment('comment #1', id: '2'));
  });
}
