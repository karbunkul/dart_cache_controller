import 'dart:async';

/// Abstract base class for cache storage.
abstract base class CacheStorage<T extends Object> {
  /// Abstract base class for cache storage.
  const CacheStorage();

  /// Fetches the cached value from the storage.
  ///
  /// Returns the cached value if available, or null if not found.
  ///
  /// Example:
  ///
  /// ```dart
  /// final storage = MyCacheStorage();
  ///
  /// final data = await storage.fetch();
  /// ```
  FutureOr<T?> fetch();

  /// Updates the cache storage with the provided value.
  ///
  /// [value] - the value to be stored in the cache.
  ///
  /// Example:
  ///
  /// ```dart
  /// final storage = MyCacheStorage();
  ///
  /// await storage.update(42);
  /// ```
  FutureOr<void> update(T value);
}
