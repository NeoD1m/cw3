import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:course_work_3/globals.dart' as globals;
class LoginPage extends StatefulWidget{
  LoginPage({required this.reload});
  Function reload;

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>{
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 1000,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Enter login credentials",
                  style: TextStyle(fontSize: 30)),
              SizedBox(height: 24,),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your name',
                ),
              ),
              SizedBox(height: 24,),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(height: 24,),
              ElevatedButton(
                  onPressed: () async {
                    // if login success
                    final params = {
                      "username": usernameController.value.text??"",
                      "password" : passwordController.value.text??""
                    };
                    print(params);
                    try {
                      Dio dio = Dio();
                      Response<dynamic> response =  await dio.post('http://neodim.fun:8080/api/login', queryParameters: params);
                      print("RESPONSE: ${response.data}");
                      if (response.data.toString().contains("true")){
                        globals.loggedUsername = usernameController.value.text;
                        widget.reload();
                        Navigator.of(context).pop();
                      } else {
                        showDialog(context: context,  builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error!'),
                            content: const Text(
                              'Your name or password\nis incorrect.\nPlease try again.',
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
                    } catch (e){
                      print(e);
                    }
                    //Response<dynamic> response = await dio.get('http://neodim.fun:8080/api/userids');


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
                        "Enter",
                        style: TextStyle(
                            color: Theme.of(context).canvasColor,
                            fontSize: 24),
                      )))
            ],
          ),
        ),
      ),
    );
  }

}