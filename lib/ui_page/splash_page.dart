import 'dart:async';
import 'package:db_exp/data/local/db_helper.dart';
import 'package:db_exp/ui_page/home_page.dart';
import 'package:db_exp/ui_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget
{
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
{
  @override
  void initState()
  {
    super.initState();
    Timer(Duration(seconds: 3),()
    async{
      var prefs = await SharedPreferences.getInstance();
      int check=  prefs.getInt(DbHelper.LOGIN_ID)??0;
      //var check= await  prefs.getInt(DbHelper.LOGIN_ID);
      Widget navigator = LoginPage();
      if(check>0)
      {
        navigator = HomePage();
       // Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>navigator));
    },);
  }
  @override
  Widget build(BuildContext context)
  {

   return Scaffold(
     body: Container(
           width: double.infinity,
           height: double.infinity,
         child: Image(image: AssetImage("assets/image/notes.splash.jpg"),fit: BoxFit.cover,)),
   );
  }
}