# events_bus

<img src="https://raw.githubusercontent.com/andrewpiterov/event_bus_plus/main/doc/video_presentation.gif" alt="event bus plus" style="width: 100%; height: auto; "/>

```dart

// Initialize the Service Bus
IAppEventBus eventBus = AppEventBus();

// Define your app event
final event = FollowEvent('@devcraft.ninja');
final event = CommentEvent('Awesome package 😎');

// listen the latest event
final sub = eventBus.last$.listen((AppEvent event) { /*do something*/ });

// fire the event
eventBus.fire(event);

// start watch the event till its completion
eventBus.watch(event);

// and check the progress
eventBus.isInProgress<FollowAppEvent>();

// or listen stream to check the processing
eventBus.inProgress$.map((List<AppEvent> events) =>
        events.whereType<FollowAppEvent>().isNotEmpty);

// Listen particular event
eventBus.on<FollowAppEvent>().listen((e) {
                // TODO: something
        });

// complete
_eventBus.complete(event);

// or complete with completion event
_eventBus.complete(event, nextEvent: SomeAnotherEvent);
```

## Contributing

We accept the following contributions:

* Improving documentation
* [Reporting issues](https://github.com/AndrewPiterov/event_bus_plus/issues/new)
* Fixing bugs

## Maintainers

* [Andrew Piterov](mailto:contact@andrewpiterov.com?subject=[GitHub]%20Source%20Dart%event_bus_plus)
