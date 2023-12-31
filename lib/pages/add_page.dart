import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:course_work_3/widgets/add_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as dev;
import 'package:course_work_3/globals.dart' as globals;

import '../widgets/title.dart';

class AddListingPage extends StatefulWidget {
  AddListingPage({super.key});

  late Uint8List? _image = null;

  @override
  State<AddListingPage> createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  //username,wage,about,email,userimage
  TextEditingController usernameController = TextEditingController();
  TextEditingController wageController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _setImage(Uint8List image) {
    setState(() {
      widget._image = image;
    });
  }

  void setUser(
      {required String username,
      required String wage,
      required String about,
      required String email,
      required Uint8List userimage,
      required String password}) async {
    final dio = Dio();
    //
    String s = new String.fromCharCodes(userimage);
    //var outputAsUint8List = new Uint8List.fromList(s.codeUnits);
    String base64String = base64Encode(userimage);
    // final enCodedJson = utf8.encode(userimage.toString());
    // final gZipString = gzip.encode(enCodedJson);
    // final base64String = base64.encode(gZipString);
    final params = {
      "username": username,
      "wage": int.parse(wage),
      "about": about,
      "email": email,
      "password": password
      //MultipartFile.fromBytes(userimage).finalize()
    };
    print(params);
    try {
      await dio.post('http://neodim.fun:8080/api/user',
          queryParameters: params,
          data: {"userimage": base64Encode(userimage)});
    } catch (e) {
      print(e);
    }
  }
  void updateUser(
      {required String username,
        required String wage,
        required String about,
        required String email,
        required Uint8List userimage,
        required String password}) async {
    final dio = Dio();
    final params = {
      "oldname": globals.loggedUsername,
      "username": username,
      "wage": int.parse(wage),
      "about": about,
      "email": email,
      "password": password,
    };
    print(params);
    try {
      Response response = await dio.put('http://neodim.fun:8080/api/user',
          queryParameters: params,
          data: {"userimage": base64Encode(userimage)});
      print(response.data);
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 1000,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      (globals.loggedUsername == "")
                          ? "Create a listing:"
                          : "Edit you listing:",
                      style: TextStyle(fontSize: 30)),
                  const SizedBox(height: 24),
                  SizedBox(
                      height: 100,
                      width: 100,
                      child: widget._image == null
                          ? AddImage(setImageField: _setImage)
                          : Image.memory(widget._image!)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a name',
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: wageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a wage',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter an email',
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a password',
                    ),
                  ),
                  const SizedBox(height: 24),
                  // TextField(
                  //   controller: emailController,
                  //   decoration: const InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Enter a search term',
                  //   ),
                  // ),
                  const SizedBox(height: 24),
                  TextField(
                    maxLines: 10,
                    minLines: 10,
                    controller: aboutController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a text about yourself',
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                      onPressed: () {
                        if (usernameController.value.text.isNotEmpty &&
                            wageController.value.text.isNotEmpty &&
                            aboutController.value.text.isNotEmpty &&
                            emailController.value.text.isNotEmpty &&
                            passwordController.value.text.isNotEmpty &&
                            widget._image != null){
                          if (globals.loggedUsername == "") {
                            setUser(
                                username: usernameController.value.text,
                                wage: wageController.value.text,
                                about: aboutController.value.text,
                                email: emailController.value.text,
                                userimage: widget._image!,
                                password: passwordController.value.text);
                          } else {
                            updateUser(
                                username: usernameController.value.text,
                                wage: wageController.value.text,
                                about: aboutController.value.text,
                                email: emailController.value.text,
                                userimage: widget._image!,
                                password: passwordController.value.text);
                          }

                          dev.log("publish requested");
                        Navigator.of(context).pop();}
                        else {
                          showDialog(context: context,  builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error!'),
                              content: const Text(
                                'Fill all of the fields!',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },);
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Theme.of(context).primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0)))),
                      child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            (globals.loggedUsername == "")
                                ? "Publish listing"
                                : "Publish changes",
                            style: TextStyle(
                                color: Theme.of(context).canvasColor,
                                fontSize: 24),
                          )))
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.all(30),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
          ),
          const TitleText(),
        ],
      ),
    );
  }
}
