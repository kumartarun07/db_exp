import 'package:db_exp/data/local/db_helper.dart';
import 'package:db_exp/model/user_model.dart';
import 'package:db_exp/ui_page/login_page.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      body: Center(
        child: Container(
          height: 400,
          width: 400,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.grey.shade300),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Create your account",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                TextField(
                  controller: passController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Container(
                  height: 50,
                  width: 200,
                  child: TextButton(
                      onPressed: ()
                      async {
                        var DB = DbHelper.getInstance();
                        var check = await DB.addUser(UserModel(
                            uId: 0,
                            uName: nameController.text.toString(),
                            uEmail: emailController.text.toString(),
                            uPass: passController.text.toString()));
                        if (check &&
                            nameController.text.isNotEmpty &&
                            emailController.text.isNotEmpty &&
                            passController.text.isNotEmpty) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        } else {
                          /*  Container(width: 200,height: 200,
                      child: AlertDialog(shape: RoundedRectangleBorder(),
                        title: Text("Email already registered!!"),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                          }, child: Text("Login now ",style: TextStyle(fontSize: 25),)),
                        ],


                      ),
                    );*/
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
                                              fontSize: 20, color: Colors.blue),
                                        ))
                                  ],
                                );
                              });
                        }
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
