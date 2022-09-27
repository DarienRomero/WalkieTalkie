class UserModel {
  final String id;
  final String name;

  UserModel({
    required this.id, 
    required this.name,
  });
  static get empty => UserModel(
    id: "",
    name: ""
  );
  UserModel copyWith({
    String? id,
    String? name,
  }) => UserModel(
    id: id ?? this.id, 
    name: name ?? this.name,
  );
}