import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:flutter/material.dart';

import 'app.dart';

// Initialize the Service Bus
IEventBus eventBus = EventBus();

void main() {
  eventBus.on().listen((event) {
    print('$DateTime.now()} Event: ${event}');
  });

  runApp(const MyApp());
}
