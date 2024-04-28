import 'dart:async';

import 'package:cache_controller/cache_controller.dart';
import 'package:test/test.dart';

void main() {
  group('CacheController', () {
    late CacheController<int> cacheController;
    late CacheStorage<int> mockStorage;

    setUp(() {
      mockStorage = MemoryCacheStorage();
      cacheController = CacheController<int>(
        storage: mockStorage,
        ttl: const Duration(milliseconds: 40),
        onCacheRequest: () async => 42,
      );
    });

    test('Initial value is fetched correctly', () async {
      final value = await cacheController.value;
      expect(value, equals(42));
    });

    test('Cached value is returned without calling onCacheRequest', () async {
      final value1 = await cacheController.value;
      final value2 = await cacheController.value;
      expect(value1, equals(value2));
    });

    test('Cached value is updated after TTL', () async {
      await cacheController.update(100);
      final value1 = await cacheController.value;
      await Future.delayed(
        const Duration(milliseconds: 50),
        () => null,
      ); // Wait for TTL to expire
      final value2 = await cacheController.value;
      expect(value1, isNot(equals(value2)));
    });

    test('Cache update works correctly', () async {
      await cacheController.update(100);
      final value = await cacheController.value;
      expect(value, equals(100));
    });

    tearDown(() {
      cacheController.dispose();
      mockStorage.update(0);
    });
  });
}
