import 'package:flutter_sandbox/api/api_manager/user_credentials.dart';
import 'package:json_annotation/json_annotation.dart';

part 'local_user_credentials.g.dart';

@JsonSerializable(explicitToJson: true)
class LocalUserCredentials {
  @JsonKey(name: "access_token")
  final String accessToken;

  @JsonKey(name: "refresh_token")
  final String refreshToken;

  @JsonKey(name: "expires_in")
  final DateTime expiryDateTime;

  @JsonKey(name: "refresh_expires_in")
  final DateTime refreshExpiryDateTime;

  LocalUserCredentials(
      {required this.accessToken,
      required this.refreshToken,
      required this.expiryDateTime,
      required this.refreshExpiryDateTime});

  factory LocalUserCredentials.fromJson(Map<String, dynamic> json) => _$LocalUserCredentialsFromJson(json);
}
