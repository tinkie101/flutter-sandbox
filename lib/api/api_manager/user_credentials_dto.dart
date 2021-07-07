import 'package:json_annotation/json_annotation.dart';

part 'user_credentials_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class UserCredentialsDto {
  @JsonKey(name: "access_token")
  final String accessToken;

  @JsonKey(name: "refresh_token")
  final String refreshToken;

  @JsonKey(name: "expires_in")
  final int expiresIn;

  @JsonKey(name: "refresh_expires_in")
  final int refreshExpiresIn;

  UserCredentialsDto(
      {required this.accessToken,
      required this.refreshToken,
      required this.expiresIn,
      required this.refreshExpiresIn});

  factory UserCredentialsDto.fromJson(Map<String, dynamic> json) => _$UserCredentialsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserCredentialsDtoToJson(this);
}
