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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text('Following:'),
                  Center(
                    child: StreamBuilder<bool>(
                      stream: _eventBus.whileInProgress<FollowAppEvent>(),
                      builder: (_, snap) {
                        return snap.data == true
                            ? const CircularProgressIndicator()
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text('Commeting:'),
                  Center(
                    child: StreamBuilder<bool>(
                      stream: _eventBus.whileInProgress<NewComment>(),
                      builder: (_, snap) {
                        return snap.data == true
                            ? const CircularProgressIndicator()
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text('Anything:'),
                  Center(
                    child: StreamBuilder<bool>(
                      stream: _eventBus.isBusy$,
                      builder: (_, snap) {
                        return snap.data == true
                            ? const CircularProgressIndicator()
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _startFollowingEvent,
                    child: const Text('Start following'),
                  ),
                  ElevatedButton(
                    onPressed: _completeFollowingEvent,
                    child: const Text('Complete'),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _startNextEvent,
                    child: const Text('Start commenting'),
                  ),
                  ElevatedButton(
                    onPressed: _completeEvent,
                    child: const Text('Complete'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startFollowingEvent() {
    final event = FollowAppEvent('text', id: '1');
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
    final event = NewComment('text', id: '1');
    _eventBus.watch(event);
    _commentingEvent = event;
  }

  void _completeEvent() {
    if (_commentingEvent == null) {
      return;
    }
    _eventBus.complete(_commentingEvent!);
  }
}
