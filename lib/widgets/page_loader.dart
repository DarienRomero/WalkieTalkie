import 'package:flutter/material.dart';
import 'package:walkie_tolkie_app/utils/utils.dart';

class PageLoader extends StatelessWidget {
  final bool loading;
  final String message;

  const PageLoader({
    Key? key, 
    required this.loading, 
    required this.message
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loading ? Container(
      width: mqWidth(context, 100),
      height: mqHeigth(context, 100),
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor
            ),
            Container(height: 5),
            Text(message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600
              )
            )
          ],
        ),
      ),
    ) : Container();
  }
}
