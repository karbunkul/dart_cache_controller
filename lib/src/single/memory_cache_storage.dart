import 'cache_storage.dart';

class MemoryCacheStorage<T> extends CacheStorage<T> {
  T? _value;

  MemoryCacheStorage();

  @override
  Future<T?> get() async => _value;

  @override
  Future<void> update(T value) async => _value = value;
}
