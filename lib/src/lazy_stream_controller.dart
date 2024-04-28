import 'dart:async';

import 'package:meta/meta.dart';

/// A class representing a lazy-initialized [StreamController].
///
/// This class allows lazy initialization of a [StreamController],
/// meaning the [StreamController] is created only when needed, rather
/// than being instantiated preemptively.
@internal
class LazyStreamController<T> {
  LazyStreamController({bool broadcast = true}) : _broadcast = broadcast;

  final bool _broadcast;
  StreamController<T>? _controller;

  /// Returns the [StreamController], creating it if it doesn't exist.
  ///
  /// If the [StreamController] doesn't exist, it will be created on the
  /// first access and then cached for subsequent accesses.
  ///
  /// Example:
  ///
  /// ```dart
  /// final lazyController = LazyStreamController<int>();
  ///
  /// lazyController.controller.add(1);
  /// lazyController.controller.add(2);
  ///
  /// lazyController.stream.listen((data) {
  ///   print(data);
  /// });
  /// ```
  StreamController<T> get controller {
    _controller ??= _init();
    return _controller!;
  }

  StreamController<T> _init() {
    return _broadcast ? StreamController<T>.broadcast() : StreamController<T>();
  }

  /// Returns the [Stream] associated with the [StreamController].
  ///
  /// Example:
  ///
  /// ```dart
  /// final lazyController = LazyStreamController<int>();
  ///
  /// lazyController.controller.add(1);
  /// lazyController.controller.add(2);
  ///
  /// lazyController.stream.listen((data) {
  ///   print(data);
  /// });
  /// ```
  Stream<T> get stream => controller.stream;

  /// Adds [data] to the [StreamController].
  ///
  /// Example:
  ///
  /// ```dart
  /// final lazyController = LazyStreamController<int>();
  ///
  /// lazyController.add(1);
  /// lazyController.add(2);
  /// ```
  void add(T data) => controller.add(data);

  /// Closes the [StreamController].
  ///
  /// Example:
  ///
  /// ```dart
  /// final lazyController = LazyStreamController<int>();
  ///
  /// lazyController.close();
  /// ```
  void close() {
    _controller?.close();
    _controller = null;
  }
}
