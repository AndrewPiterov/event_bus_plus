// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'models.dart';

void main() {
  late IEventBus bus;

  before(() {
    bus = EventBus();
  });

  test('emit Some Event', () {
    final ctrl = StreamController();

    final sub = bus.respond<NewCommentEvent>((event) {
      log('new comment');
      ctrl.add(2);
    }).respond<FollowAppEvent>((event) {
      log('new follower');
      ctrl.add(1);
    });

    expect(ctrl.stream, emitsInOrder([1, 2]));

    bus.fire(FollowAppEvent('username'));
    bus.fire(NewCommentEvent('comment #1'));
  });

  test('emit Some Events', () {
    final ctrl = StreamController();

    final sub = bus.respond<NewCommentEvent>((event) {
      log('new comment');
      ctrl.add(2);
    }).respond<FollowAppEvent>((event) {
      log('new follower');
      ctrl.add(1);
    });

    expect(ctrl.stream, emitsInOrder([1, 2, 1]));

    bus.fire(FollowAppEvent('username'));
    bus.fire(NewCommentEvent('comment #1'));
    bus.fire(FollowAppEvent('username2'));
  });

  test('emit all Event', () {
    final ctrl = StreamController();

    final sub = bus.respond<NewCommentEvent>((event) {
      log('new comment');
      ctrl.add(2);
    }).respond<FollowAppEvent>((event) {
      log('new follower');
      ctrl.add(1);
    }).respond((event) {
      log('event $event');
      ctrl.add(3);
    });

    expect(ctrl.stream, emitsInOrder([1, 3, 3, 2, 3, 3]));

    bus.fire(FollowAppEvent('username'));
    bus.fire(NewCommentEvent('comment #1'));
  });
}
