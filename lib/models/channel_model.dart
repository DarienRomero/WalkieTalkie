class ChannelModel {
  final String id;
  final String name;
  final List<String> users;
  final int peopleCounter;

  ChannelModel({
    required this.id, 
    required this.name,
    required this.users,
    required this.peopleCounter,
  });
  static get empty => ChannelModel(
    id: "",
    name: "",
    users: [],
    peopleCounter: 0
  );
  ChannelModel copyWith({
    String? id,
    String? name,
    List<String>? users,
    int? peopleCounter
  }) => ChannelModel(
    id: id ?? this.id, 
    name: name ?? this.name,
    users: users ?? this.users,
    peopleCounter: peopleCounter ?? this.peopleCounter,
  );
}