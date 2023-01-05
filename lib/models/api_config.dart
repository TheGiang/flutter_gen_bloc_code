import 'dart:convert';

ApiConfig apiConfigFromJson(String str) => ApiConfig.fromJson(json.decode(str));

String apiConfigToJson(ApiConfig data) => json.encode(data.toJson());

class ApiConfig {
  ApiConfig({
    required this.blocName,
    required this.apis,
  });

  final String blocName;
  final List<Api> apis;

  ApiConfig copyWith({
    String? blocName,
    List<Api>? apis,
  }) =>
      ApiConfig(
        blocName: blocName ?? this.blocName,
        apis: apis ?? this.apis,
      );

  factory ApiConfig.fromJson(Map<String, dynamic> json) => ApiConfig(
        blocName: json["blocName"],
        apis: List<Api>.from(json["apis"].map((x) => Api.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "blocName": blocName,
        "apis": List<dynamic>.from(apis.map((x) => x.toJson())),
      };
}

class Api {
  Api({
    required this.name,
    required this.evenParams,
    required this.stateParams,
  });

  final String name;
  final List<Param> evenParams;
  final List<Param> stateParams;

  Api copyWith({
    String? name,
    List<Param>? evenParams,
    List<Param>? stateParams,
  }) =>
      Api(
        name: name ?? this.name,
        evenParams: evenParams ?? this.evenParams,
        stateParams: stateParams ?? this.stateParams,
      );

  factory Api.fromJson(Map<String, dynamic> json) => Api(
        name: json["name"],
        evenParams:
            List<Param>.from(json["evenParams"].map((x) => Param.fromJson(x))),
        stateParams:
            List<Param>.from(json["stateParams"].map((x) => Param.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "evenParams": List<dynamic>.from(evenParams.map((x) => x.toJson())),
        "stateParams": List<dynamic>.from(stateParams.map((x) => x.toJson())),
      };
}

class Param {
  Param({
    required this.type,
    required this.name,
  });

  final String type;
  final String name;

  Param copyWith({
    String? type,
    String? name,
  }) =>
      Param(
        type: type ?? this.type,
        name: name ?? this.name,
      );

  factory Param.fromJson(Map<String, dynamic> json) => Param(
        type: json["type"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "name": name,
      };
}
