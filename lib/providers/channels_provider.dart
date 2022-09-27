import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:walkie_tolkie_app/controllers/channels_controller.dart';
import 'package:walkie_tolkie_app/models/channel_model.dart';
import 'package:walkie_tolkie_app/models/message_model.dart';

class ChannelsProvider extends ChangeNotifier{
  final channelsController = ChannelsController();

  StreamSubscription<dynamic>? subscriptionChannels;
  bool channelsLoading = true;
  bool channelsError = false;
  List<ChannelModel> channels = [];

  Future<void> getChannels(String userId) async {
    if(subscriptionChannels != null && !channelsError) return;
    subscriptionChannels = channelsController.channelsStream(userId).listen((QuerySnapshot<Map<String, dynamic>> snapshots) {
      if(snapshots.docs.isEmpty) return;
      final operations  = channelsController.parseChannels(snapshots.docs);
      channels = operations;
      channelsError = false;
      notifyListeners();
    }, onError: (error){
      channelsError = true;
      notifyListeners();
    });
  }

  StreamSubscription<dynamic>? subscriptionMessages;
  bool messagesLoading = true;
  bool messagesError = false;
  List<MessageModel> messages = [];

  Future<void> getMessages(String userId, String channelId) async {
    if(subscriptionMessages != null && !messagesError) return;
    subscriptionMessages = channelsController.messagesStream(userId, channelId).listen((QuerySnapshot<Map<String, dynamic>> snapshots) {
      if(snapshots.docs.isEmpty) return;
      final newMessages  = channelsController.parseMessages(snapshots.docs);
      messages = newMessages;
      messagesError = false;
      notifyListeners();
    }, onError: (error){
      messagesError = true;
      notifyListeners();
    });
  }
  
}