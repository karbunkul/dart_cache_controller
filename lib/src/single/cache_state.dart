import 'dart:async';

import 'package:cache_controller/src/lazy_stream_controller.dart';
import 'package:cache_controller/src/single/cache_storage.dart';
import 'package:meta/meta.dart';

/// Internal state of the cache controller.
@internal
class CacheState<T extends Object> {
  // Time of last cache update

  /// Creates a new instance of [CacheState].
  ///
  /// [storage] - cache storage.
  CacheState({required CacheStorage<T> storage}) : _storage = storage;
  final CacheStorage<T> _storage; // Cache storage
  final _controller = LazyStreamController<T>();
  T? _currentValue; // Current cache value
  DateTime? _lastUpdated;

  /// Updates the cache value.
  ///
  /// [value] - the new value to update the cache with.
  Future<void> update(T value) async {
    _currentValue = value;
    _lastUpdated = DateTime.now();
    _controller.add(value);
    await _storage.update(value);
  }

  /// Stream of cache data.
  ///
  /// Example:
  ///
  /// ```dart
  /// final state = CacheState<int>(...);
  ///
  /// state.stream.listen((data) {
  ///   print('Received data: $data');
  /// });
  /// ```
  Stream<T> get stream => _controller.stream;

  /// Fetches the cache value from the storage.
  ///
  /// Example:
  ///
  /// ```dart
  /// final state = CacheState<int>(...);
  ///
  /// final data = await state.fetch();
  /// ```
  FutureOr<T?> fetch() {
    try {
      return _storage.fetch();
    } on Object {
      return null;
    }
  }

  /// Checks if the cache has expired.
  ///
  /// [ttl] - the time-to-live duration for the cache.
  ///
  /// Example:
  ///
  /// ```dart
  /// final state = CacheState<int>(...);
  ///
  /// final expired = state.hasExpired(Duration(minutes: 5));
  /// ```
  bool hasExpired(Duration ttl) {
    if (_lastUpdated == null) {
      return true; // If cache is not initialized, consider it expired
    }
    return DateTime.now().difference(_lastUpdated!) > ttl;
  }

  /// Returns the current cache value.
  ///
  /// Example:
  ///
  /// ```dart
  /// final state = CacheState<int>(...);
  ///
  /// final value = state.currentValue;
  /// ```
  T? get currentValue => _currentValue;

  /// Closes the stream controller.
  ///
  /// Example:
  ///
  /// ```dart
  /// final state = CacheState<int>(...);
  ///
  /// state.dispose();
  /// ```
  void dispose() {
    _controller.close();
  }
}
