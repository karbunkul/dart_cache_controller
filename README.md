# cache_controller

cache_controller is a Dart package for managing cached data with expiration control.

## Usage

To use this package, add `cache_controller` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  cache_controller: ^0.9.7-pre
```

or use dart cli

```shell
dart pub add cache_controller
```

Then import the package into your Dart code:

```dart
import 'package:cache_controller/cache_controller.dart';
```

### CacheController

`CacheController` is the main class provided by this package. It allows you to manage cached data with expiration control.

Here's a simple example of how to use `CacheController`:

```dart
import 'package:cache_controller/cache_controller.dart';

void main() async {
  // Create a cache controller with a TTL of 1 hour
  final cacheController = CacheController<int>(
    storage:
    MemoryCacheStorage(), // Example storage, use your own implementation
    ttl: const Duration(hours: 1),
    onCacheRequest: () async {
      // Simulate fetching data from a remote source
      return 42;
    },
  );
  // Retrieve the cached value, or fetch it if it's expired or not available
  final value = await cacheController.value;
  print('Cached value: $value');

  // Update the cache value
  await cacheController.update(100);
  print('Updated cache value');

  // Dispose of the cache controller when no longer needed
  cacheController.dispose();
}
```

In this example, `CacheController` is used to manage an integer value in the cache. It fetches the value from a remote source using the `onCacheRequest` callback if it's expired or not available. The TTL (time-to-live) determines how long the cached value remains valid.

### CacheStorage

`CacheStorage` is an abstract class representing the storage mechanism for cached data. You can implement your own storage mechanism by extending this class. This package provides some built-in implementations:

- `MemoryCacheStorage`: Stores cached data in memory.

### Features and bugs

Please file feature requests and bugs at the [issue tracker](https://github.com/karbunkul/dart_cache_controller/issues).
