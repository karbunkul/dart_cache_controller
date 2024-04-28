import 'package:cache_controller/cache_controller.dart';
// ignore_for_file: avoid_print

void main() async {
  // Create a cache controller with a TTL of 1 hour
  final cacheController = CacheController<int>(
    // Example storage, use your own implementation
    storage: MemoryCacheStorage(),
    ttl: const Duration(hours: 1),
    // Simulate fetching data from a remote source
    onCacheRequest: () async => 42,
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
