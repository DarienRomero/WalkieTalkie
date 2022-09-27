import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walkie_tolkie_app/pages/router_page.dart';
import 'package:walkie_tolkie_app/providers/channels_provider.dart';
import 'package:walkie_tolkie_app/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<ChannelsProvider>(
          create: (context) => ChannelsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'WalkieTalkie',
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: const RouterPage()
      ),
    );
  }
}