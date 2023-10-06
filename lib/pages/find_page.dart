import 'dart:convert';

import 'package:course_work_3/pages/add_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;

import '../widgets/display_item.dart';
import '../widgets/title.dart';

class FindPeoplePage extends StatefulWidget {
  const FindPeoplePage({super.key});

  @override
  State<FindPeoplePage> createState() => _FindPeoplePageState();
}

class _FindPeoplePageState extends State<FindPeoplePage> {
  Future<List<DisplayItem>> getUser() async {
    final dio = Dio();
    Response<dynamic> response = await dio.get('http://localhost:8080/api/userids');
    print(response.data);
    List<DisplayItem> finalList = [];
    for (var item in response.data as List){
      print(item);
      final response = await dio.get('http://localhost:8080/api/user/$item');
      finalList.add(DisplayItem.fromJson(jsonDecode(response.toString())));
    }
    //List<int> list = jsonDecode(response.toString());
    //print(list);
    print("2");
    //print(list[0]);
    int a = 1;


    // for (var item in list){
    //   print("cycle ${item.runtimeType}");
    //   DisplayItem di = DisplayItem.fromJson(jsonDecode(item));
    //   print(di.name);
    // }
    print("3");
    return finalList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: FutureBuilder<List<DisplayItem>>(
                    future: getUser(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<DisplayItem>> snapshot) {
                      if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            snapshot.data![0],
                            snapshot.data![1],
                            snapshot.data![2],
                            snapshot.data![3],
                            snapshot.data![4],
                          ],
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () => setState(() {}),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith(
                            (states) => EdgeInsets.all(20)),
                        alignment: Alignment.center,
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Theme.of(context).primaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ))),
                    child: Icon(
                      Icons.refresh_outlined,
                      color: Theme.of(context).canvasColor,
                    )),
                // IconButton(
                //     color: Theme.of(context).primaryColor,
                //     onPressed: () => setState(() {}),
                //     icon: const Icon(Icons.refresh_outlined))
              ],
            ),
          ),
          const TitleText(),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
                padding: const EdgeInsets.only(bottom: 40, right: 40),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor)))),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddListingPage()),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "ADD",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
