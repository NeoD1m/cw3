import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleText extends StatelessWidget{
  const TitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
          padding: const EdgeInsets.only(top: 25),
          child: Text(
            "Find Slaves for work",
            style: Theme.of(context).textTheme.headline2,
          )),
    );
  }

}