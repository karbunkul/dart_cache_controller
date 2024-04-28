import 'dart:async';

import 'package:cache_controller/src/single/cache_state.dart';
import 'package:cache_controller/src/single/cache_storage.dart';

/// Callback function for cache data request
typedef CacheRequestCallback<T extends Object> = Future<T> Function();

/// Cache controller for managing data and its updates.
class CacheController<T extends Object> {
  // Internal state of the controller

  /// Creates a new instance of [CacheController].
  ///
  /// [storage] - cache storage.
  /// [ttl] - cache time-to-live.
  /// [onCacheRequest] - Callback function for data request in case of
  /// cache expiration.
  CacheController({
    required CacheStorage<T> storage,
    required this.ttl,
    required this.onCacheRequest,
  }) : _state = CacheState(storage: storage);

  /// Time-to-live for cache
  final Duration ttl;

  /// Callback function for data request
  final CacheRequestCallback<T> onCacheRequest;
  final CacheState<T> _state;

  /// Stream of cache data.
  ///
  /// Example:
  ///
  /// ```dart
  /// final controller = CacheController<int>(...);
  ///
  /// controller.stream.listen((data) {
  ///   print('Received data: $data');
  /// });
  /// ```
  Stream<T> get stream => _state.stream;

  /// Gets the current value of cache, updating it if necessary.
  ///
  /// If the current value is not initialized, it tries to fetch from storage.
  /// If TTL has expired, it fetches a new value using [onCacheRequest].
  ///
  /// Example:
  ///
  /// ```dart
  /// final controller = CacheController<int>(...);
  ///
  /// final data = await controller.value;
  /// print('Cached data: $data');
  /// ```
  Future<T> get value async {
    if (_state.currentValue == null) {
      final savedValue = await _state.fetch();
      if (savedValue != null) {
        // ignore: unawaited_futures
        _state.update(savedValue);
        return savedValue;
      }
    }

    if (_state.hasExpired(ttl)) {
      final value = await onCacheRequest();
      await update(value);
      return value;
    }

    return _state.currentValue!;
  }

  /// Updates the cache value.
  ///
  /// Example:
  ///
  /// ```dart
  /// final controller = CacheController<int>(...);
  ///
  /// await controller.update(42);
  /// ```
  Future<void> update(T value) async {
    await _state.update(value);
  }

  /// Disposes the cache controller.
  ///
  /// Example:
  ///
  /// ```dart
  /// final controller = CacheController<int>(...);
  ///
  /// controller.dispose();
  /// ```
  void dispose() {
    return _state.dispose();
  }
}
