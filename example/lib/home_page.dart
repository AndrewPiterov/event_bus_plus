import 'dart:async';

import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:flutter/material.dart';

import 'models/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final IEventBus _eventBus = EventBus();

  FollowAppEvent? _followingEvent;
  NewComment? _commentingEvent;

  late StreamSubscription<AppEvent?> _sub;
  AppEvent? _lastEvent;

  late StreamSubscription<List<AppEvent>> _sub2;
  List<AppEvent> _lastEvents = [];

  @override
  void initState() {
    super.initState();

    _sub = _eventBus.last$.listen((event) {
      _lastEvent = event;
      setState(() {});
    });

    _sub2 = _eventBus.inProgress$.listen((events) {
      _lastEvents = events;
      setState(() {});
    });

    // _eventBus.on<FollowAppEvent>().listen((e) {
    //   // TODO: something
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.amberAccent,
                padding: const EdgeInsets.all(30),
                child: _eventBusState(),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(30),
                child: _events(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _events() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'App Events',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Let\'s assume that we have two events in out app:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Following event:'),
                ),
                Center(
                  child: StreamBuilder<bool>(
                    stream: _eventBus.whileInProgress<FollowAppEvent>(),
                    initialData: false,
                    builder: (_, snap) => Spinner(snap.data!),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _startFollowingEvent,
                  child: const Text('Start following'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _completeFollowingEvent,
                  child: const Text('Complete'),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Commenting event:'),
                ),
                Center(
                  child: StreamBuilder<bool>(
                    stream: _eventBus.whileInProgress<NewComment>(),
                    initialData: false,
                    builder: (_, snap) => Spinner(snap.data!),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _startNextEvent,
                  child: const Text('Start commenting'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _completeEvent,
                  child: const Text('Complete'),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Any event is in progress:'),
            ),
            Center(
              child: StreamBuilder<bool>(
                stream: _eventBus.isBusy$,
                initialData: false,
                builder: (_, snap) => Spinner(snap.data!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _eventBusState() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Event Bus State:',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Last event: ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(_lastEvent?.toString() ?? 'none'),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'In progress: ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        _lastEvents.isEmpty ? 'none' : _lastEvents.join(', '),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            Expanded(
              child: SizedBox(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'History:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: _eventBus.history
                            .map((e) => Text(e.toString()))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _startFollowingEvent() {
    final event = FollowAppEvent('@devcraft.ninja', id: '1');
    _eventBus.watch(event);
    _followingEvent = event;
  }

  void _completeFollowingEvent() {
    if (_followingEvent == null) {
      return;
    }
    _eventBus.complete(_followingEvent!);
  }

  void _startNextEvent() {
    final event = NewComment('Awesome package', id: '1');
    _eventBus.watch(event);
    _commentingEvent = event;
  }

  void _completeEvent() {
    if (_commentingEvent == null) {
      return;
    }
    _eventBus.complete(_commentingEvent!);
  }

  @override
  void dispose() {
    _sub.cancel();
    _sub2.cancel();
    super.dispose();
  }
}

class Spinner extends StatelessWidget {
  const Spinner(this.isActive, {Key? key}) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isActive ? 20 : 0,
      width: isActive ? 20 : 0,
      child: const CircularProgressIndicator(),
    );
  }
}
