# events_bus_plus

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
