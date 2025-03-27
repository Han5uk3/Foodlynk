import 'package:flutter/cupertino.dart';

class SaverLoader extends StatelessWidget {
  const SaverLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CupertinoActivityIndicator(
          color: const Color.fromARGB(255, 38, 38, 38),
        ),
      ),
    );
  }
}
