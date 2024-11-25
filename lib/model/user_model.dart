import 'package:db_exp/data/local/db_helper.dart';

class UserModel
{
  int uId;
  String uName,uEmail,uPass;
  UserModel({required this.uId,required this.uName,required this.uEmail,required this.uPass});

  factory UserModel.fromMap(Map<String,dynamic>map)=>UserModel(
      uId: map[DbHelper.COLUMN_USER_ID],
      uName: map[DbHelper.COLUMN_USER_NAME],
      uEmail: map[DbHelper.COLUMN_USER_EMAIL],
      uPass: map[DbHelper.COLUMN_USER_PASS]
  );

  Map<String,dynamic>toMap() => {
    DbHelper.COLUMN_USER_NAME:uName,
    DbHelper.COLUMN_USER_EMAIL:uEmail,
    DbHelper.COLUMN_USER_PASS:uPass,
  };
}







































/*class UserModel
{
  int uId;
  String uName;
  String uEmail;
  String uPass;

  UserModel({required this.uId,required this.uName,required this.uEmail,required this.uPass});

  factory UserModel.fromMap(Map<String,dynamic>map)=>
      UserModel(
          uId: map[DbHelper.COLUMN_USER_ID],
          uName: map[DbHelper.COLUMN_USER_NAME],
          uEmail: map[DbHelper.COLUMN_USER_EMAIL],
          uPass: map[DbHelper.COLUMN_USER_PASS]);

  Map<String,dynamic> tomap() => {
    DbHelper.COLUMN_USER_NAME:uName,
    DbHelper.COLUMN_USER_EMAIL:uEmail,
    DbHelper.COLUMN_USER_PASS:uPass
  };
}*/
