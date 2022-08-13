# EventBus: Events for Dart/Flutter

[![pub package](https://img.shields.io/pub/v/event_bus_plus.svg?label=event_bus_plus&color=blue)](https://pub.dev/packages/event_bus_plus)
[![codecov](https://codecov.io/gh/AndrewPiterov/event_bus_plus/branch/main/graph/badge.svg?token=VM9LTJXGQS)](https://codecov.io/gh/AndrewPiterov/event_bus_plus)
[![Dart](https://github.com/AndrewPiterov/event_bus_plus/actions/workflows/dart.yml/badge.svg)](https://github.com/AndrewPiterov/event_bus_plus/actions/workflows/dart.yml)


**EventBus** is an open-source library for Dart and Flutter using the **publisher/subscriber** pattern for loose coupling. **EventBus** enables central communication to decoupled classes with just a few lines of code – simplifying the code, removing dependencies, and speeding up app development.

<img src="https://raw.githubusercontent.com/andrewpiterov/event_bus_plus/main/doc/pub_sub.webp" alt="event bus publish subscribe" style="width: 100%; height: auto; "/>

## Your benefits using EventBus: It…
- simplifies the communication between components;
- decouples event senders and receivers;
- performs well with UI artifacts (e.g. Widgets, Controllers);
- avoids complex and error-prone dependencies and life cycle issues.


<img src="https://raw.githubusercontent.com/andrewpiterov/event_bus_plus/main/doc/video_presentation.gif" alt="event bus plus" style="width: 100%; height: auto; "/>

### Define app's events

```dart
// Initialize the Service Bus
IAppEventBus eventBus = AppEventBus();

// Define your app events
final event = FollowEvent('@devcraft.ninja');
final event = CommentEvent('Awesome package 😎');
```

### Subscribe

```dart
// listen the latest event
final sub = eventBus.last$
        .listen((AppEvent event) { /*do something*/ });

// Listen particular event
final sub2 = eventBus.on<FollowAppEvent>()
        .listen((e) { /*do something*/ });
```

### Publish

```dart
// fire the event
eventBus.fire(event);
```

### Watch events in progress

```dart
// start watch the event till its completion
eventBus.watch(event);

// and check the progress
eventBus.isInProgress<FollowAppEvent>();

// or listen stream to check the processing
eventBus.inProgress$.map((List<AppEvent> events) =>
        events.whereType<FollowAppEvent>().isNotEmpty);

// complete
_eventBus.complete(event);

// or complete with completion event
_eventBus.complete(event, nextEvent: SomeAnotherEvent);
```

## History

```dart
final events = eventBus.history;
```

## Contributing

We accept the following contributions:

* Improving documentation
* [Reporting issues](https://github.com/AndrewPiterov/event_bus_plus/issues/new)
* Fixing bugs

## Maintainers

* [Andrew Piterov](mailto:contact@andrewpiterov.com?subject=[GitHub]%20Source%20Dart%event_bus_plus)
