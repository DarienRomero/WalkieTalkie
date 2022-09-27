import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> openRecorder(FlutterSoundRecorder recorder) async {
  try{
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return false;
    }
    await recorder.openRecorder();
    return true;
  }catch(_){
    return false;
  }
}
Future<bool> requestPermission() async {
  try{
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return false;
    }
    return true;
  }catch(_){
    return false;
  }
}