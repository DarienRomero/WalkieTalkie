import 'package:flutter/material.dart';
import 'package:walkie_tolkie_app/utils/utils.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final double width;
  final Function() onPressed;

  const CustomButton({
    Key? key, 
    required this.label, 
    required this.width, 
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mqWidth(context, width),
      child: MaterialButton(
        height: mqHeigth(context, 8),
        minWidth: mqWidth(context, 80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: onPressed,
        child: Center(
          child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
    );
  }
}
