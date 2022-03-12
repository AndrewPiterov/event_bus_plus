# events_bus

```dart
IAppEventBus eventBus = AppEventBus();
final event = FollowAppEvent('andrei');

// listen last event
eventBus.last$.listen((AppEvent event) { /*do something*/ });

// start watch
eventBus.watch(event);

// and check the progress
eventBus.isInProgress<FollowAppEvent>();

// or listen stream
eventBus.inProgress$.map((List<AppEvent> events) =>
        events.whereType<FollowAppEvent>().isNotEmpty)

// complete
_eventBus.complete(event);

// or complete with completion event
_eventBus.complete(event, nextEvent: SomeAnotherEvent);

```

## Contributing

We accept the following contributions:

* Improving documentation
* [Reporting issues](https://github.com/AndrewPiterov/events_bus/issues/new)
* Fixing bugs

## Maintainers

* [Andrew Piterov](mailto:contact@andrewpiterov.com?subject=[GitHub]%20Source%20Dart%events_bus)
