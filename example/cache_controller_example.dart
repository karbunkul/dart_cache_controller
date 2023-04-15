import 'package:cache_controller/cache_controller.dart';

class IncrementController extends CacheController<int> {
  IncrementController({required super.request});

  Future<void> inc() async {
    final newValue = (await value) + 1;
    update(newValue);
  }
}

void main() async {
  final controller = IncrementController(request: () => 0);

  await controller.inc();
  await controller.inc();

  // ignore: unused_local_variable
  final value = await controller.value;

  /// value output 2
}
