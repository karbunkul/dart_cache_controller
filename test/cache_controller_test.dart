import 'dart:math';

import 'package:cache_controller/cache_controller.dart';
import 'package:cache_controller/src/single/memory_cache_storage.dart';
import 'package:test/test.dart';

void main() {
  group('cache_controller library tests', () {
    group('cache-controller tests', () {
      test('ttl', () async {
        final initialData = 10;
        final duration = Duration(milliseconds: 20);
        // create controller
        final controller = CacheController<int>(
          request: () => initialData,
          ttl: Duration(milliseconds: 20),
        );
        // update value
        final updated = 5;
        await controller.update(updated);
        expect(await controller.value == updated, isTrue);
        // wait until expired cache
        await Future.delayed(duration);
        // after cache expired, value is initial (request called)
        expect(await controller.value == initialData, isTrue);
      });
      test('value', () async {
        final storage = MemoryCacheStorage<int>();
        final initialData = 10;
        final controller = CacheController<int>(
          request: () => initialData,
          storage: storage,
        );
        expect(await controller.value == initialData, isTrue);
        final expected = 5;
        await controller.update(expected);
        expect(await controller.value == expected, isTrue);
        expect(await storage.get() == expected, isTrue);
      });

      test('memory-storage', () async {
        // create storage instance
        final storage = MemoryCacheStorage<int>();
        // storage is null
        expect(await storage.get() == null, isTrue);
        // update storage random number
        final randomNumber = Random().nextInt(100);
        storage.update(randomNumber);
        // storage value is randomNumber
        expect(await storage.get() == randomNumber, isTrue);
      });
    });
  });
}
