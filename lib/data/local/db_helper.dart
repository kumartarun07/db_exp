import 'dart:async';
import 'dart:io';
import 'package:db_exp/model/note_model.dart';
import 'package:db_exp/model/user_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static DbHelper getInstance() => DbHelper._();
  Database? mDB;

  /// login pref key
  static final String LOGIN_ID = "uid";

  /// crete table
  static final String TABLE_NOTE = "note";
  static final String TABLE_USER = "user";

  /// notes table column
  static final String COLUMN_NOTE_SNO = "s_no";
  static final String COLUMN_NOTE_TITLE = "title";
  static final String COLUMN_NOTE_DESC = "desc";

  /// user table column
  static final String COLUMN_USER_ID = "uid";
  static final String COLUMN_USER_NAME = "uname";
  static final String COLUMN_USER_EMAIL = "uemail";
  static final String COLUMN_USER_PASS = "upass";

  Future<Database> getDB() async {
    /*if (mDB!=null)
      {
        return mDB!;
      }
    else
      {
        mDB = await OpenDB();
            return mDB!;
      }*/
    mDB ??= await OpenDB();
    return mDB!;
  }

  Future<Database> OpenDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbpath = join(appDir.path, "noteDB.db");
    return await openDatabase(dbpath, onCreate: (db, version) {
      db.execute(
          "create table $TABLE_NOTE ( $COLUMN_NOTE_SNO Integer primary key autoincrement, "
          "$COLUMN_USER_ID integer ,"
          "$COLUMN_NOTE_TITLE text ,"
          "$COLUMN_NOTE_DESC text )");
      db.execute(
          "create table $TABLE_USER ( $COLUMN_USER_ID integer primary key autoincrement ,"
          "$COLUMN_USER_NAME text, $COLUMN_USER_EMAIL text unique,"
          "$COLUMN_USER_PASS text )");
    }, version: 1);
  }

  Future<bool> addNote({required NoteModel newNote}) async {
    var mDB = await getDB();
    var uid = await getUid();
    newNote.uid = uid;
    int rowsEffected = await mDB.insert(TABLE_NOTE, newNote.toMap());
    return rowsEffected > 0;
  }

  Future<List<NoteModel>> fetchallnotes() async {
    var mDB = await getDB();
    var uid = await getUid();
    var data = await mDB.query(TABLE_NOTE, where: "$COLUMN_USER_ID=?", whereArgs: ['$uid']);
    List<NoteModel> mNotes = [];

    /// from map to model
    for (Map<String, dynamic> eachData in data) {
      // NoteModel eachNote = NoteModel.fromMap(eachData);
      // mNotes.add(eachNote);  //  multiline code
      mNotes.add(NoteModel.fromMap(eachData));

      ///single line
    }
    return mNotes;
  }

  Future<bool> updateNote(
      {required NoteModel updateNote, required int sno}) async {
    var mDB = await getDB();
    int rowsEffected = await mDB.update(TABLE_NOTE, updateNote.toMap(),
        //where: "$COLUMN_NOTE_SNO = ?",whereArgs: ['$sno']);
        where: "$COLUMN_NOTE_SNO = ?",
        whereArgs: ['$sno']);
    return rowsEffected > 0;
  }

  Future<bool> deleteNote({required int sno}) async {
    var mDB = await getDB();
    int rowsEffected =
        await mDB.delete(TABLE_NOTE, where: "$COLUMN_NOTE_SNO = $sno");
    return rowsEffected > 0;
  }

  /// queries for user
  /// user sign up
  Future<bool> addUser(UserModel newuser) async {
    var mDB = await getDB();
    bool haveaccount = await checkIfEmailAlreadyExit(newuser.uEmail);
    bool accCreated = false;
    if (!haveaccount) {
      var rowsEffected = await mDB.insert(TABLE_USER, newuser.toMap());
      accCreated = rowsEffected > 0;
    }
    return accCreated;
  }

  /// user check email exit
  Future<bool> checkIfEmailAlreadyExit(String email) async {
    var mDB = await getDB();
    var mdata = await mDB
        .query(TABLE_USER, where: "$COLUMN_USER_EMAIL=?", whereArgs: [email]);
    return mdata.isNotEmpty;
  }

  /// user Login
  Future<bool> autheticatUser(String email, String pass) async {
    var mDB = await getDB();
    var mdata = await mDB.query(TABLE_USER,
        where: "$COLUMN_USER_EMAIL=?"
            " and $COLUMN_USER_PASS=?",
        whereArgs: [email, pass]);
    if (mdata.isNotEmpty) {
      setUid(UserModel.fromMap(mdata[0]).uId);
    }
    return mdata.isNotEmpty;
  }

  ///get uid
  Future<int> getUid() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt(DbHelper.LOGIN_ID)!;
  }

  /// set uid
  void setUid(int uid) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(DbHelper.LOGIN_ID, uid);
  }
}

/*class DbHelper
{
  DbHelper ._();
  static DbHelper getInstance() => DbHelper._();

  Database? mDB;
  static final String TABLE_NOTE ="note";
  static final String COLUMN_NOTE_SNO="s_no";
  static final String COLUMN_NOTE_TITLE="title";
  static final String COLUMN_NOTE_DESC="desc";

  Future<Database> getDB()
 async {
    if(mDB! = null)
      {
        return mDB!;
      }
    else
      {
        mDB = await openDB();
        return mDB!;
      }
  }

  /// mDB = await opeDB(); return mDB!;

 Future<Database>openDB()
 async{
       Directory appDir = await getApplicationDocumentsDirectory();
       String dbPath  = join(appDir.path,"note.db");
       return await openDatabase(dbPath,onCreate:(db,version)
       {
         db.execute("Create Table $TABLE_NOTE ( $COLUMN_NOTE_SNO INTEGER PRIMARY KEY AUTO INCREMENT,"
             " $COLUMN_NOTE_TITLE TEXT,"
             "$COLUMN_NOTE_DESC TEXT)");
       },version: 1);
 }

 Future<bool>addNotes({required String title,required String desc})
 async{
         var mDB = await getDB();
         int rowseffected =  await mDB.insert(TABLE_NOTE,{
           COLUMN_NOTE_TITLE:title,
           COLUMN_NOTE_DESC:desc,
         });return rowseffected>0;
 }


   Future<List<Map<String,dynamic>>>fetchallNotes()
   async{
     var mDB = await getDB();
     return await mDB.query(TABLE_NOTE);
   }

   Future<bool>updatenote({required String mTitle,required String mDesc,required int sno})
   async{
     var mDB = await getDB();
     int rowsEffected = await mDB.update(TABLE_NOTE, {
       COLUMN_NOTE_TITLE : mTitle,
       COLUMN_NOTE_DESC : mDesc,
     },where: "$COLUMN_NOTE_SNO = ?" ,whereArgs: ['$sno']
     );return rowsEffected>0;
   }

   Future<bool> deletenote({required int sno})
   async{
          var mDB = await getDB();
          int rowsEffected = await mDB.delete(TABLE_NOTE,where: "$COLUMN_NOTE_SNO = $sno");
          return rowsEffected>0;
   }

}*/

/*
class DBhelper
{
  DBhelper ._();
  DBhelper getInstance() => DBhelper._();

  Database? mdb;
  static final String TABLE_NOTE = "note";
  static final String COLUMN_NOTE_SNO ="s_no";
  static final String COLUMN_NOTE_TITLE = "title";
  static final String COLUMN_NOTE_DESC = "desc";

  Future<Database>getdb()
  async{
    if(mdb!=null)
      {
        return mdb!;
      }
    else
      {
        mdb = await openDB();
        return mdb!;
      }
  }

  Future<Database>openDB()
  async{
    Directory appDir =await getApplicationDocumentsDirectory();
    String dbpath = join(appDir.path,"notes.db");
    return await openDatabase(dbpath,onCreate: (db,version)
    {
      db.execute("create Table Note ( $COLUMN_NOTE_SNO INTEGER PRIMARY KEY AUTO INCREMENT,"
          "$COLUMN_NOTE_TITLE TEXT , $COLUMN_NOTE_DESC TEXT )");
    },version: 1);
  }

  Future<bool>addnotes({required String title,required String desc})
  async{
    var mdb = await getdb();
    int rowsEffected =await mdb.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE : title,
      COLUMN_NOTE_DESC : desc,
    });return rowsEffected>0;
  }

  Future<List<Map<String,dynamic>>>fetchallnotes()
  async{
    var mdb = await getdb();
    return await mdb.query(TABLE_NOTE);
  }

  Future<bool> updatenote({required String mtitle , required String mdesc , required int sno})
  async{
    var mdb = await getdb();
    int rowsEffected = await mdb.update(TABLE_NOTE, {
      COLUMN_NOTE_TITLE : mtitle,
      COLUMN_NOTE_DESC : mdesc,
    },where: "$COLUMN_NOTE_SNO = ?",whereArgs: ['$sno']);
    return rowsEffected>0;
  }

  Future<bool> deletenote({required int sno})
  async{
    var mdb = await getdb();
    int rowsEffected = await mdb.delete(TABLE_NOTE,where: "$COLUMN_NOTE_SNO = $sno");
    return rowsEffected>0;
  }

}
*/

/*class DBHelper
{
  DBHelper._();
  static DBHelper getInstance() => DBHelper._();
  Database? mdb;
  static final String TABLE_NOTE = "note";
  static final String COLUMN_NOTE_SNO="s_no";
  static final String COLUMN_NOTE_TITLE ="note";
  static final String COLUMN_NOTE_DESC = "desc";

  Future<Database> getdb()
  async{
    if(mdb!=null)
      {
        return mdb!;
      }
    else{
      mdb = await openDB();
      return mdb!;
    }
  }

  Future<Database>openDB()
  async{
    Directory appdir = await getApplicationDocumentsDirectory();
    String dbpath = join(appdir.path,"notes.db");
    return await openDatabase(dbpath,onCreate:(db,version)
    {db.execute("create table $TABLE_NOTE ( $COLUMN_NOTE_SNO integer primary key auto increment ,"
        "$COLUMN_NOTE_TITLE text , $COLUMN_NOTE_DESC text)");},version: 1);
    }

    Future<bool> addnotes({required String title , required String desc})
   async {
      var mdb = await getdb();
      int rowsEffected = await mdb.insert(TABLE_NOTE, {
        COLUMN_NOTE_TITLE : "title",
        COLUMN_NOTE_DESC : "desc",
      }); return rowsEffected>0;
    }

    Future<List<Map<String,dynamic>>>fetchnote()
    async{
      var mdb = await getdb();
      return await mdb.query(TABLE_NOTE);
    }

    Future<bool>updatenote({required String mtitle,required String mdesc, required int sno})
    async{
      var mdb = await getdb();
      int rowsEffected = await mdb.update(TABLE_NOTE, {
        COLUMN_NOTE_TITLE :mtitle,
        COLUMN_NOTE_DESC : mdesc
      },where: "$COLUMN_NOTE_SNO = ? ",whereArgs: ['$sno']
      ); return rowsEffected>0;
    }

    Future<bool> deletenote({required int sno})
    async{
      var mdb = await getdb();
      int rowsEffected = await mdb.delete(TABLE_NOTE,where: "$COLUMN_NOTE_SNO = $sno"
      );return rowsEffected>0;
    }
}*/

/*
class DBHelper
{
  DBHelper ._();
  static  DbHelper getInstance()=>DbHelper._();
  Database? mdb;
  static final String TABLE_NOTE = "note";
  static final String NOTE_SNO = "sno";
  static final String NOTE_TITLE = "title";
  static final String NOTE_DESC = "desc";

  getDB()
  async{
     if(mdb!=null)
       {
         return mdb!;
       }
     else
       {
         mdb= await openDB();
         return mdb!;
       }
  }

  Future<Database>openDB()
  async{
    Directory appdir = await getApplicationDocumentsDirectory();
    String dbpath = join(appdir.path,"notes.db");
    return await openDatabase(dbpath,onCreate: (db,version)
    {
      db.execute("create Table $TABLE_NOTE ($NOTE_SNO INTEGER PRIMARY KEY AUTO INCREMENT "
                                             "$NOTE_TITLE TEXT $NOTE_DESC TEXT)" );
    },version: 1);
  }

}*/
