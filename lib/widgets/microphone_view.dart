import 'package:flutter/material.dart';
import 'package:walkie_tolkie_app/utils/utils.dart';

class MicrophoneView extends StatelessWidget {
  final bool recording;
  final Function() startRecording;
  final Function() endRecording;
  const MicrophoneView({
    Key? key,
    required this.recording,
    required this.startRecording,
    required this.endRecording
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: mqWidth(context, 80),
        height: mqWidth(context, 80),
        child: GestureDetector(
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(mqWidth(context, 40)),
              side: const BorderSide(
                color: Colors.orange,
                width: 2.0
              )
            ),
            color: Colors.white.withOpacity(recording ? 0.4 : 0.2),
            child: const Icon(Icons.mic, size: 36),
            onPressed: (){

            }
          ),
          onLongPressUp: (){
            endRecording();
          },
          onLongPressDown: (details){
            startRecording();
          },
        ),
      ),
    );
  }
}