import 'package:flutter_sandbox/api/api_manager/local_user_credentials.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_credentials.g.dart';

@JsonSerializable(explicitToJson: true)
class UserCredentials {
  @JsonKey(name: "access_token")
  final String accessToken;

  @JsonKey(name: "refresh_token")
  final String refreshToken;

  @JsonKey(name: "expires_in")
  final DateTime expiryDateTime;

  @JsonKey(name: "refresh_expires_in")
  final DateTime refreshExpiryDateTime;

  UserCredentials(
      {required this.accessToken,
      required this.refreshToken,
      required int expiryDateTime,
      required int refreshExpiryDateTime})
      : expiryDateTime = DateTime.now().add(Duration(seconds: expiryDateTime)),
        refreshExpiryDateTime = DateTime.now().add(Duration(seconds: refreshExpiryDateTime));

  UserCredentials.fromLocal(LocalUserCredentials localCredentials)
      : this.accessToken = localCredentials.accessToken,
        this.refreshToken = localCredentials.refreshToken,
        this.expiryDateTime = localCredentials.expiryDateTime,
        this.refreshExpiryDateTime = localCredentials.refreshExpiryDateTime;

  factory UserCredentials.fromJson(Map<String, dynamic> json) => _$UserCredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$UserCredentialsToJson(this);
}
