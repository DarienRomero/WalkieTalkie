import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:walkie_tolkie_app/models/channel_model.dart';
import 'package:walkie_tolkie_app/models/error_response.dart';
import 'package:walkie_tolkie_app/models/message_model.dart';
import 'package:walkie_tolkie_app/models/user_model.dart';

class ChannelsController {

  ChannelsController._privateConstructor();
  static final ChannelsController _instance = ChannelsController._privateConstructor();
  factory ChannelsController() => _instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String channelsCollection = "channels";
  final String messagesCollection = "messages";

  Stream<QuerySnapshot<Map<String, dynamic>>> channelsStream(String userId) => _db.collection(channelsCollection).where("users", arrayContains: userId).snapshots();

  List<ChannelModel> parseChannels(List<QueryDocumentSnapshot<Object?>> docs){
    List<ChannelModel> channels = [];
    for (QueryDocumentSnapshot snapshot in docs) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        channels.add(ChannelModel(
          id: data["id"] ?? "", 
          name: data["name"] ?? "", 
          peopleCounter: data["people_counter"] ?? 0, 
          users: data["users"] != null ? List<String>.from(data["users"]) : []
        ));
      }
    }
    return channels;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream(String userId, String channelId) => _db.collection(channelsCollection).doc(channelId).collection(messagesCollection).orderBy('date_time', descending: false).snapshots();

  List<MessageModel> parseMessages(List<QueryDocumentSnapshot<Object?>> docs){
    List<MessageModel> messages = [];
    for (QueryDocumentSnapshot snapshot in docs) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        messages.add(MessageModel(
          id: data["id"] ?? "", 
          senderId: data["sender_id"] ?? "", 
          senderName: data["sender_name"] ?? 0, 
          dateTime: data["date_time"]?.toDate(),
          audioUrl: data["audio_url"] ?? 0, 
        ));
      }
    }
    return messages;
  }
  Future<dynamic> createMessage(MessageModel message, UserModel user, String channelId, String audioUrl) async{
    try {
      final CollectionReference ref = _db.collection(channelsCollection).doc(channelId).collection(messagesCollection);
      final userRef = await ref.add({
        "sender_id": user.id,
        "sender_name": user.name,
        "date_time": DateTime.now(),
        "audio_url": audioUrl
      });
      return userRef.id;
    }  on SocketException{
      return ErrorResponse.network;
    } catch(_){
      return ErrorResponse.unknown;
    }
  }
}