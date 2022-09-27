import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walkie_tolkie_app/controllers/users_controller.dart';
import 'package:walkie_tolkie_app/models/error_response.dart';
import 'package:walkie_tolkie_app/pages/home_page.dart';
import 'package:walkie_tolkie_app/providers/user_provider.dart';
import 'package:walkie_tolkie_app/utils/alerts.dart';
import 'package:walkie_tolkie_app/utils/utils.dart';
import 'package:walkie_tolkie_app/widgets/custom_buttom.dart';
import 'package:walkie_tolkie_app/widgets/page_loader.dart';
import 'package:walkie_tolkie_app/widgets/scaffold_wrapper.dart';
import 'package:walkie_tolkie_app/widgets/v_spacing.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool loading = false;
  final usersController = UsersController();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      appBar: AppBar(
        title: const Text('Walkie Talkie'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const VSpacing(20),
                SizedBox(
                  width: mqWidth(context, 60),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                      label: Text("Email")
                    ),
                    onChanged: (newValue){
                      email = newValue;
                    },
                  ),
                ),
                const VSpacing(5),
                SizedBox(
                  width: mqWidth(context, 60),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Contraseña',
                      label: Text("Contraseña"),
                    ),
                    onChanged: (newValue){
                      password = newValue;
                    },
                  ),
                ),
                const VSpacing(3),
                CustomButton(
                  width: 60,
                  label: "Continuar", 
                  onPressed: () async {
                    if(loading) return;
                    setState(() {
                      loading = true;
                    });
                    final authResp = await usersController.signInUserEmailPassword(email, password);
                    if(authResp is ErrorResponse){
                      setState(() {
                        loading = false;
                      });
                      showError(context: context, title: "Error", subtitle: authResp.message);
                      return;
                    }
                    final temp = authResp as User;
                    final resp = await usersController.fetchUserById(temp.uid);
                    if(resp is ErrorResponse){
                      setState(() {
                        loading = false;
                      });
                      showError(context: context, title: "Error", subtitle: resp.message);
                      return;
                    }
                    Provider.of<UserProvider>(context, listen: false).setNewUser(resp);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
                  }
                )
              ],
            )
          ),
          PageLoader(
            loading: loading, 
            message: "Iniciando sesión"
          )
        ],
      )
    );
  }
}