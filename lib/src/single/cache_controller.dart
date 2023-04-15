import 'dart:async';

import 'package:meta/meta.dart';

import '../cache_expire_mixin.dart';
import 'cache_storage.dart';
import 'memory_cache_storage.dart';

typedef RequestCallback<T> = FutureOr<T> Function();

class CacheController<T> with CacheExpireMixin {
  final CacheStorage<T>? storage;
  final RequestCallback<T> request;
  final Duration ttl;

  CacheController({
    required this.request,
    this.ttl = Duration.zero,
    this.storage,
  }) {
    _storage = storage ?? MemoryCacheStorage<T>();
    _initCache();
  }

  StreamController<T>? _controller;
  @protected
  T? _value;
  late CacheStorage<T> _storage;

  Future<void> _initCache() async {
    final value = await _storage.get();

    if (value != null) {
      await update(value);
    } else {
      await reset();
    }
  }

  Future<void> update(T value) async {
    if (_value != value) {
      updateExpire();
      _value = value;
      _controller?.add(value);
      await _storage.update(value);
    }
  }

  Future<void> reset() async => await update(await request());

  Stream<T> get stream {
    _controller ??= StreamController<T>.broadcast();

    return _controller!.stream;
  }

  Future<T> get value async {
    if (isExpired(ttl) || _value == null) {
      await reset();
    }

    return _value as T;
  }

  void dispose() {
    _controller?.close();
    _storage.dispose();
  }
}
