import 'package:db_exp/data/local/db_helper.dart';
import 'package:db_exp/ui_page/home_page.dart';
import 'package:db_exp/ui_page/signup_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Container(
              height: 500,
              width: 400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.pink.shade200),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40),
                child: Column(
                  children: [
                    Text(
                      "Login Your Account",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: passController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                        ),
                        height: 60,
                        width: 250,
                        child: TextButton(
                          onPressed: () async {
                            var db = DbHelper.getInstance();
                            var check = await db.autheticatUser(
                                emailController.text.toString(),
                                passController.text.toString());
                            if (check &&
                                emailController.text.isNotEmpty &&
                                passController.text.isNotEmpty) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text(
                                        "Invalid User Email and Password",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.blue),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Ok",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.blue),
                                            ))
                                      ],
                                    );
                                  });
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                          style: ButtonStyle(),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        },
                        child: Text(
                          "Create New Account ,SignUp?",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
