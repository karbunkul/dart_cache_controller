import 'dart:async';

import 'package:cache_controller/src/single/cache_storage.dart';

/// A cache storage implementation that stores data in memory.
final class MemoryCacheStorage<T extends Object> extends CacheStorage<T> {
  T? _value; // Cached value stored in memory

  /// Fetches the cached value from memory.
  ///
  /// Returns the cached value if available, or null if not found.
  ///
  /// Example:
  ///
  /// ```dart
  /// final memoryCache = MemoryCacheStorage<int>();
  ///
  /// final cachedData = await memoryCache.fetch();
  /// print('Cached data: $cachedData'); // Output: Cached data: null
  /// ```
  @override
  FutureOr<T?> fetch() => _value;

  /// Updates the cache value stored in memory.
  ///
  /// [value] - the value to be stored in the cache memory.
  ///
  /// Example:
  ///
  /// ```dart
  /// final memoryCache = MemoryCacheStorage<int>();
  ///
  /// await memoryCache.update(42);
  /// print('Updated cache with value: 42');
  /// ```
  @override
  FutureOr<void> update(T value) => _value = value;
}
