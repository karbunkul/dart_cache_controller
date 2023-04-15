import 'dart:async';

abstract class CacheStorage<T> {
  Future<T?> get();
  Future<void> update(T value);

  void dispose() {}
}
