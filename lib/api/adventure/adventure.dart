import 'package:json_annotation/json_annotation.dart';

part 'adventure.g.dart';

@JsonSerializable(explicitToJson: true)
class Adventure {
  final String id;
  final String name;
  final String description;

  Adventure({required this.id, this.name = "", this.description = ""});

  Adventure alteredAdventure({String? name, String? description}) {
    return Adventure(id: this.id, name: name ?? this.name, description: description ?? this.description);
  }

  factory Adventure.fromJson(Map<String, dynamic> json) => _$AdventureFromJson(json);

  Map<String, dynamic> toJson() => _$AdventureToJson(this);
}
