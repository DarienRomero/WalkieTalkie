import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:walkie_tolkie_app/controllers/channels_controller.dart';
import 'package:walkie_tolkie_app/controllers/storage_controller.dart';
import 'package:walkie_tolkie_app/models/channel_model.dart';
import 'package:walkie_tolkie_app/models/message_model.dart';
import 'package:walkie_tolkie_app/providers/channels_provider.dart';
import 'package:walkie_tolkie_app/providers/user_provider.dart';
import 'package:walkie_tolkie_app/utils/alerts.dart';
import 'package:walkie_tolkie_app/utils/audio_helpers.dart';
import 'package:walkie_tolkie_app/widgets/messages_view.dart';
import 'package:walkie_tolkie_app/widgets/microphone_view.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:provider/provider.dart';

class ChannelPage extends StatefulWidget {
  final ChannelModel channel;
  const ChannelPage({
    Key? key,
    required this.channel
  }) : super(key: key);

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  final FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();
  final FlutterSoundRecorder _myRecorded = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecordedIsInited = false;
  bool isRecording = false;
  final storageController = StorageController();
  final channelController = ChannelsController();
  String outputFile = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final userId = Provider.of<UserProvider>(context, listen: false).currentUser;
      _myPlayer.openPlayer().then((value) {
        setState(() {
          _mPlayerIsInited = true;
        });
        openRecorder(_myRecorded).then((value){
          _mRecordedIsInited = true;
        });
      });
      Provider.of<ChannelsProvider>(context, listen: false).getMessages(userId.id, widget.channel.id);
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.channel.name),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.mic)),
              Tab(icon: Icon(Icons.chat)),
              Tab(icon: Icon(Icons.people)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MicrophoneView(
              recording: isRecording,
              startRecording: (){
                startRecording();
              },
              endRecording: (){
                stopRecording();
              },
            ),
            MessagesView(
              onPressed: (MessageModel message){
                playSound(message.audioUrl);
              },
            ),
            const Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
  Future<void> startRecording() async {
    if(isRecording) return;
    setState(() {
      isRecording = true;
    });
    Directory tempDir = await getTemporaryDirectory();
    outputFile = '${tempDir.path}/${DateTime.now()}.aac';
    _myRecorded.startRecorder
    (
        codec: Codec.aacADTS,
        toFile: outputFile,
        sampleRate: 16000,
        numChannels: 1,
    );
  }
  Future<void> stopRecording() async {
    if(!isRecording) return;
    setState(() {
      isRecording = false;
    });
    await _myRecorded.stopRecorder();
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    String? url = await storageController.uploadAndGetUrl(user.id, File(outputFile));
    if(url == null){
      showError(context: context, title: "Lo sentimos", subtitle: "No se pudo subir el audio");
      return;
    }
    final MessageModel message = MessageModel(
      id: "", 
      senderId: user.id, 
      senderName: user.name, 
      dateTime: DateTime.now(), 
      audioUrl: url
    );  
    channelController.createMessage(message, user, widget.channel.id, url);
  }
  void playSound(String url) async {
    _myPlayer.startPlayer(
      fromURI: url,
      codec: Codec.mp3,
      whenFinished: (){ /* Do something */},
    );
  }
}