import 'package:popcorn/model/cast.dart';

class CastResponse {
  final List<Cast> cast;
  final String error;

  CastResponse(this.cast, this.error);

  CastResponse.fromJson(Map<String, dynamic> json)
      : cast = (json["casts"] as List)
            .map((e) => new Cast.fromJson(e))
            .toList(),
        error = "";

  CastResponse.withError(String errorValue)
      : cast = List(),
        error = errorValue;
}
