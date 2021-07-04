import 'package:json_annotation/json_annotation.dart';

part 'login_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginDto {
  @JsonKey(name: "grant_type")
  final String grantType;

  final String password;
  final String username;

  @JsonKey(name: "refresh_token")
  final String refreshToken;

  LoginDto(
      {required this.grantType,
      this.password = "",
      this.username = "",
      this.refreshToken = ""});

  Map<String, dynamic> toJson() => _$LoginDtoToJson(this);
}
