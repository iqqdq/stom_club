import 'dart:convert';

class RefreshRequest {
  RefreshRequest({
    required this.refresh,
  });

  String refresh;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
      };
}
