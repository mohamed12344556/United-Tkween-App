import 'package:united_formation_app/core/api/dio_services.dart';

class DeepLinkManager {
  static const _key = "pending_deeplink_id";

  static Future<void> setPendingChallenge(String id) async {
    await Prefs.setData(key: _key, value: id);
    print("✅ Saved pending ID: $id");
  }

  static String? consumePendingChallenge() {
    final id = Prefs.getData(key: _key) as String?;
    if (id != null) {
      Prefs.removeData(key: _key);
    }
    print("📦 Consumed pending ID: $id");
    return id;
  }
}
