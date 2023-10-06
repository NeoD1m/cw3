import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class DisplayItem extends StatefulWidget {
  DisplayItem({
    super.key,
    required this.name,
    required this.wage,
    required this.about,
    required this.email,
    required this.image,
  });

  factory DisplayItem.fromJson(Map<String, dynamic> json) {
    //
    List<dynamic> kek = json['userimage']["data"];
    List<int> list = kek.cast<int>();
    Uint8List image = Uint8List.fromList(list);
    //print(image);
    return DisplayItem(
      name: json['username'],
      about: json['about'],
      wage: json['wage'],
      email: json['email'],
      image: image//Uint8List.fromList([])
    );
  }

  final String name;
  final int wage;
  final String about;
  final String email;
  final Uint8List image;

  bool _isExtended = false;

  @override
  State<DisplayItem> createState() => _DisplayItemState();
}

class _DisplayItemState extends State<DisplayItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 50),
      //height: widget._isExtended ? null : 156,
      width: 500,
      child: ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ))),
        onPressed: () {
          setState(() {
            widget._isExtended = !widget._isExtended;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 80,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(widget.image),
                    ),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text("${widget.wage.toString()} руб"), // TODO prettify
                    Text(widget.email),
                    SizedBox(
                        width: 300,
                        child: Text(
                          widget.about,
                          softWrap: true,
                          overflow:
                              widget._isExtended ? null : TextOverflow.ellipsis,
                          maxLines: widget._isExtended ? null : 2,
                          //overflow: TextOverflow.ellipsis,
                        ))
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
// Container(
// width: 20,
// padding: EdgeInsets.only(bottom: 35),
// child: ExpansionTileCard(title: Text("лул"),baseColor: Colors.purple,children: [
// Text("Лалалалалалал")
// ],));
