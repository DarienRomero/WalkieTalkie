import 'package:flutter/material.dart';

Future<void> showLoading(BuildContext context) async{
  await showDialog(
    context: context, 
    builder: (context) => const AlertDialog(
      title: Text("Cargando"),
      content: Center(
        child: CircularProgressIndicator()
      ),
    )
  );
}

Future<void> showError({
  required BuildContext context,
  required String title,
  required String subtitle
}) async{
  await showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(subtitle),
    )
  );
}

Future<void> showInfo({
  required BuildContext context,
  required String title,
  required String subtitle
}) async{
  await showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(subtitle),
    )
  );
}