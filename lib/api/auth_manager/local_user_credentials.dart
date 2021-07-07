import 'package:flutter_sandbox/api/api_manager/user_credentials_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'local_user_credentials.g.dart';

@JsonSerializable(explicitToJson: true)
class LocalUserCredentials {
  @JsonKey(name: "access_token")
  final String accessToken;

  @JsonKey(name: "refresh_token")
  final String refreshToken;

  @JsonKey(name: "expiry_date_time")
  final DateTime expiryDateTime;

  @JsonKey(name: "refresh_expiry_date_time")
  final DateTime refreshExpiryDateTime;

  @JsonKey(name: "expires_in")
  final int expiresIn;

  @JsonKey(name: "refresh_expires_in")
  final int refreshExpiresIn;

  LocalUserCredentials(
      {required this.accessToken,
      required this.refreshToken,
      required this.expiryDateTime,
      required this.refreshExpiryDateTime,
      required this.expiresIn,
      required this.refreshExpiresIn});

  LocalUserCredentials.fromCredentialsDto(UserCredentialsDto uc):
    accessToken=uc.accessToken,
    refreshToken=uc.refreshToken,
    expiresIn=uc.expiresIn,
    refreshExpiresIn=uc.refreshExpiresIn,
    expiryDateTime=DateTime.now().add(Duration(seconds: uc.expiresIn)),
    refreshExpiryDateTime=DateTime.now().add(Duration(seconds: uc.refreshExpiresIn));

  cloneUpdatedExpiryDates() => LocalUserCredentials(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiryDateTime: DateTime.now().add(Duration(seconds: expiresIn)),
      refreshExpiryDateTime: DateTime.now().add(Duration(seconds: refreshExpiresIn)),
      expiresIn: expiresIn,
      refreshExpiresIn: refreshExpiresIn);

  factory LocalUserCredentials.fromJson(Map<String, dynamic> json) => _$LocalUserCredentialsFromJson(json);
  Map<String, dynamic> toJson() => _$LocalUserCredentialsToJson(this);
}
