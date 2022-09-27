class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final DateTime? dateTime;
  final String audioUrl;

  MessageModel({
    required this.id, 
    required this.senderId,
    required this.senderName,
    required this.dateTime,
    required this.audioUrl,
  });
  
  static get empty => MessageModel(
    id: "",
    senderId: "",
    senderName: "",
    dateTime: null,
    audioUrl: ""
  );

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? senderName,
    DateTime? dateTime,
    String? audioUrl
  }) => MessageModel(
    id: id ?? this.id, 
    senderId: senderId ?? this.senderId,
    senderName: senderName ?? this.senderName,
    dateTime: dateTime ?? this.dateTime,
    audioUrl: audioUrl ?? this.audioUrl,
  );
}