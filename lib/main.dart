import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:walkie_tolkie_app/controllers/storage_controller.dart';

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _myRecorded = FlutterSoundRecorder();
  final storageController = StorageController();
  bool _mPlayerIsInited = false;
  bool _mRecordedIsInited = false;
  @override
  void initState() {
    super.initState();
    _myPlayer.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
      openRecorder();
    });
  }



  @override
  void dispose() {
    // Be careful : you must `close` the audio session when you have finished with it.
    _myPlayer.closePlayer();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: TextButton(
              onPressed: (){
                if(!_mPlayerIsInited) return;
                if(!_mRecordedIsInited) return;
                recordAndPlay();
              }, 
              child: Text("Play")
            )
          ),
        ),
      ),
    );
  }
  void playSound1() async {
    await _myPlayer.startPlayer(
      // fromURI: "https://firebasestorage.googleapis.com/v0/b/walkietalkie-ea0f9.appspot.com/o/zapsplat_fantasy_fairy_dust_twinkle_sparkle_bell_tree_lower_pitched_65543.mp3?alt=media&token=b5a0332a-db16-45fb-b546-2a06d787ab37",
      fromURI: "https://firebasestorage.googleapis.com/v0/b/walkietalkie-ea0f9.appspot.com/o/zapsplat_cartoon_anime_laser_weapon_weak_fire_79059.mp3?alt=media&token=8776b66e-62cc-47a2-b6c8-9a3a66c1e104",
      codec: Codec.mp3,
      whenFinished: () async {
        playSound2();
      }
    );
  }
  void playSound2() async {
    await _myPlayer.startPlayer(
      fromURI: "https://firebasestorage.googleapis.com/v0/b/walkietalkie-ea0f9.appspot.com/o/zapsplat_fantasy_fairy_dust_twinkle_sparkle_bell_tree_lower_pitched_65543.mp3?alt=media&token=b5a0332a-db16-45fb-b546-2a06d787ab37",
      // fromURI: "https://firebasestorage.googleapis.com/v0/b/walkietalkie-ea0f9.appspot.com/o/zapsplat_cartoon_anime_laser_weapon_weak_fire_79059.mp3?alt=media&token=8776b66e-62cc-47a2-b6c8-9a3a66c1e104",
      codec: Codec.mp3,
      whenFinished: (){
        playSound1();
      }
    );
  }
  void openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    _myRecorded.openRecorder().then((value){
      setState(() {
        _mRecordedIsInited = true;
      });
    });
  }
  void recordAndPlay() async {
    Directory tempDir = await getTemporaryDirectory();
    String outputFile = '${tempDir.path}/myFile.aac';

    await _myRecorded.startRecorder
    (
        codec: Codec.aacADTS,
        toFile: outputFile,
        sampleRate: 16000,
        numChannels: 1,
    );
    await Future.delayed(const Duration(seconds: 5));
    await _myRecorded.stopRecorder();
    /* await _myPlayer.startPlayer(
      fromURI: outputFile,
      codec: Codec.aacADTS,
      whenFinished: (){ /* Do something */},

    ); */
    String? url = await storageController.uploadAndGetUrl(1, File(outputFile));
    if(url == null){
      print("Ocurrió un error al subir el archivo");
      return;
    }
    await _myPlayer.startPlayer(
      fromURI: url,
      codec: Codec.mp3,
      whenFinished: (){ /* Do something */},

    );
  }
}