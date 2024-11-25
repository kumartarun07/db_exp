import 'package:db_exp/data/local/db_helper.dart';

class NoteModel
{
  int sno;
  int uid;
  String title;
  String desc;
  NoteModel({required this.sno,required this.uid,required this.title,required this.desc});


  /// from map to model
   factory NoteModel.fromMap(Map<String,dynamic>map) => NoteModel(
                      sno: map[DbHelper.COLUMN_NOTE_SNO],
                      uid: map[DbHelper.COLUMN_USER_ID],
                      title: map[DbHelper.COLUMN_NOTE_TITLE],
                      desc: map[DbHelper.COLUMN_NOTE_DESC]);

/// from model to map
  Map<String,dynamic> toMap()=> {
    DbHelper.COLUMN_USER_ID :uid,
    DbHelper.COLUMN_NOTE_TITLE: title,
    DbHelper.COLUMN_NOTE_DESC: desc,
  };
}






















/*
class NoteModel
{
  int? sno;
  int uid;
  String title;
  String desc;
  NoteModel({this.sno,required this.uid,required this.title,required this.desc});


  /// from map to model
  factory NoteModel.fromMap(Map<String,dynamic>map) => NoteModel(
      sno: map[DbHelper.COLUMN_NOTE_SNO],
      uid: map[DbHelper.COLUMN_USER_ID],
      title: map[DbHelper.COLUMN_NOTE_TITLE],
      desc: map[DbHelper.COLUMN_NOTE_DESC]);

  /// from model to map
  Map<String,dynamic> toMap()=> {
    DbHelper.COLUMN_USER_ID :uid,
    DbHelper.COLUMN_NOTE_TITLE: title,
    DbHelper.COLUMN_NOTE_DESC: desc,
  };
}*/
