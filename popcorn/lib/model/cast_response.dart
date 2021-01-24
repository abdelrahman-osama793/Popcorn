import 'package:popcorn/model/cast.dart';

class CastResponse {
  final List<Cast> cast;
  final String error;

  CastResponse(this.cast, this.error);

  CastResponse.fromJson(Map<String, dynamic> json)
      : cast =
            (json["cast"] as List).map((i) => new Cast.fromJson(i)).toList(),
        error = "";

  CastResponse.withError(String errorValue)
      : cast = List(),
        error = errorValue;
}
