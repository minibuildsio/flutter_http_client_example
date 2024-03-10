import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'client_model.g.dart';

@JsonSerializable()
class Post extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post(this.id, this.userId, this.title, this.body);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  @override
  List<Object?> get props => [id, userId, title, body];
}
