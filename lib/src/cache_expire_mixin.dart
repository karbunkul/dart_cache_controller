import 'package:meta/meta.dart';

mixin CacheExpireMixin {
  DateTime? _lastUpdate;

  @protected
  void updateExpire() {
    _lastUpdate = DateTime.now();
  }

  @protected
  bool isExpired(Duration ttl) {
    if (_lastUpdate == null) {
      updateExpire();
    }

    if (ttl == Duration.zero) {
      return false;
    }

    return _lastUpdate!.add(ttl).isBefore(DateTime.now());
  }
}
