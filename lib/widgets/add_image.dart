import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker_web/image_picker_web.dart';
import 'dart:developer' as dev;

import 'package:image_picker_web/image_picker_web.dart';

class AddImage extends StatefulWidget {
  const AddImage({ super.key, required this.setImageField});

  final Function setImageField;
  

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();//picker.pickImage(source: source).whenComplete(() => dev.log("image uploaded"));
          widget.setImageField(bytesFromPicker);
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                        color: Theme.of(context)
                            .primaryColor)))),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Image"),
            Icon(Icons.add),
          ],
        ));
  }
}