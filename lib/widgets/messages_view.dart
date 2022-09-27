import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walkie_tolkie_app/models/message_model.dart';
import 'package:walkie_tolkie_app/providers/channels_provider.dart';
import 'package:walkie_tolkie_app/utils/utils.dart';

class MessagesView extends StatelessWidget {
  final Function(MessageModel) onPressed;
  const MessagesView({
    Key? key,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<ChannelsProvider>(context).messages;
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index){
        final item = messages[index];
        return ListTile(
          title: Text(item.senderName),
          onTap: () => onPressed(item),
          subtitle: Text(getTime(item.dateTime)),
        );
      },
    );
  }
}