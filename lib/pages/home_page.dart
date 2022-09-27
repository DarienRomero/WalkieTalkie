import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walkie_tolkie_app/controllers/users_controller.dart';
import 'package:walkie_tolkie_app/pages/channel_page.dart';
import 'package:walkie_tolkie_app/pages/sign_in_page.dart';
import 'package:walkie_tolkie_app/providers/channels_provider.dart';
import 'package:walkie_tolkie_app/providers/user_provider.dart';
import 'package:walkie_tolkie_app/utils/audio_helpers.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final usersController = UsersController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final userId = Provider.of<UserProvider>(context, listen: false).currentUser;
      Provider.of<ChannelsProvider>(context, listen: false).getChannels(userId.id);
      requestPermission();
    });
  }
  List<String> items = ["Estado", "Opciones", "Cerrar sesión", "Salir"];
  String value = "Estado";

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    final channels = Provider.of<ChannelsProvider>(context).channels;
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        leading: Center(
          child: CircleAvatar(
            child: Text(user.name.isNotEmpty ? user.name[0] : ""),
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              usersController.signOut().then((value){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignInPage()), (route) => false);
              });
            }, 
            icon: Icon(Icons.more_vert_rounded)
          )
          /* DropdownButton(
            isDense: true,
            value: value,
            icon: const Icon(Icons.more_vert_rounded),   
            items: items.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (String? newValue) {
              
            },
          ), */
        ],
      ),
      body: ListView.builder(
        itemCount: channels.length,
        itemBuilder: (BuildContext context, int index){
          final item = channels[index];
          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green[600]
              ),
              child: item.peopleCounter > 1 ? const Icon(Icons.groups_rounded) : const Icon(Icons.person)
            ),
            title: Text(item.name),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChannelPage(channel: item)));
            },
            subtitle: const Text("1h atrás"),
            trailing: IconButton(
              onPressed: (){

              }, 
              icon: const Icon(Icons.chat_bubble)
            ),
          );
        },
      )
    );
  }
}