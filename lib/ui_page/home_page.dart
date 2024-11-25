import 'package:db_exp/data/local/db_helper.dart';
import 'package:db_exp/model/note_model.dart';
import 'package:db_exp/ui_page/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget
{


  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
{

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();
  DbHelper myDb = DbHelper.getInstance();
  List<NoteModel> allnotes = [];
  @override
  void initState()
  {
    super.initState();
    getnotes();
  }

  void getnotes()
      async {
        allnotes  = await myDb.fetchallnotes();
         setState(() {

         });
        }
  @override
  Widget build(BuildContext context)
  {
     return Scaffold(
       appBar: AppBar(
       actions: [TextButton(onPressed: ()
       async{
         var prefs = await SharedPreferences.getInstance();
         prefs.setInt(DbHelper.LOGIN_ID, -1);
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
       }, child: Text("Logout",style: TextStyle(fontSize: 20,color: Colors.black),))],
         leading:Padding(
           padding: const EdgeInsets.only(left: 10.0,top: 15),
           child: Text("Home",style: TextStyle(fontSize: 25),textAlign: TextAlign.center,),
         ) ,
         leadingWidth: 400,
       ),
           
       body: allnotes.isNotEmpty ? ListView.builder(
           itemCount: allnotes.length,
           itemBuilder: (_,index)
       {
                 return ListTile(
                   leading: Text('${index+1}'),
                   title: Text(allnotes[index].title),
                   subtitle: Text(allnotes[index].desc),
                   trailing: Container(width: 100,
                     child: Row(children: [
                       IconButton(onPressed: ()
                       {
                         titlecontroller.text = allnotes[index].title;
                         desccontroller.text = allnotes[index].desc;
                         showModalBottomSheet(context: context, builder: (_){
                           return
                             bottomSheetView(isUpdate: true,sno: allnotes[index].sno);
                         });

                       }, icon: Icon(Icons.edit)),
                       IconButton(onPressed: ()
                       async{
                         bool check = await myDb.deleteNote(sno: allnotes[index].sno);
                         if(check)
                           {
                             getnotes();
                           }
                       }, icon: Icon(Icons.delete,color: Colors.red,)),
                     ],),
                   ),
                 );
       }
       ):Center(child: Text("No Notes Yet !!"),),
       floatingActionButton: FloatingActionButton(onPressed: ()
      async {
         titlecontroller.clear();
         desccontroller.clear();
        showModalBottomSheet(context: context, builder: (_){
          return
           bottomSheetView();
        });
       },child: Icon(Icons.add,size: 30,),),
       
     );
  }

  Widget bottomSheetView({isUpdate = false,int sno=0,})
  {
    return  Container(width: double.infinity,
      padding: EdgeInsets.all(11),
      child: Column(
        children: [
          Text(isUpdate ? "Edit and Update":"Add Note",style: TextStyle(
              fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),),
          TextField(controller: titlecontroller,
            decoration: InputDecoration(border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)),hintText: "Add Title"),
          ),
          SizedBox(height: 20,),
          TextField(controller: desccontroller,
            decoration: InputDecoration(border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)),hintText: "Add Desc"),
          ),
          SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 150,
                child:
                ElevatedButton(onPressed: ()
                async{
                  if(titlecontroller.text.isNotEmpty && desccontroller.text.isNotEmpty)
                  {
                    bool check =false;
                    if(isUpdate)
                      {
                        check = await myDb.updateNote(sno: sno,updateNote:
                        NoteModel(sno: sno,
                          uid: 0,
                          title: titlecontroller.text, desc: desccontroller.text,), );
                      }
                    else {
                      check = await myDb.addNote(newNote:
                      NoteModel(
                        sno: sno,uid: 0,
                        title: titlecontroller.text, desc: desccontroller.text,),);
                    }
                    if(check)
                    {
                      getnotes();
                    }
                  }
                  Navigator.pop(context);
                }, child: Text(isUpdate ?"Update":"Add",style: TextStyle(fontSize: 20,color: Colors.green),)),
              ),
              SizedBox(width: 150,
                child: ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text("Cancel",style: TextStyle(fontSize: 20,color: Colors.red),)),
              ),
            ],
          )
        ],
      ),
    );
  }
}

















































/*

showModalBottomSheet(context: context, builder: (_){
return Container(width: double.infinity,
padding: EdgeInsets.all(11),
child: Column(
children: [
Text("Edit Notes And Desc",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),),
TextField(controller: noteseditingController,
decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),),
),
SizedBox(height: 20,),
TextField(controller: desceditingcontroller,
decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),),
),
SizedBox(height: 20,),
Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
SizedBox(width: 150,
child: ElevatedButton(onPressed: ()
async{
if(noteseditingController.text.isNotEmpty && desceditingcontroller.text.isNotEmpty)
{
bool check = await myDb.updateNote(mTitle: noteseditingController.text , mDesc: desceditingcontroller.text, sno: allnotes[index][DbHelper.COLUMN_NOTE_SNO]);
if(check)
{
getnotes();
}
}
Navigator.pop(context);
}, child: Text("save",style: TextStyle(fontSize: 20,color: Colors.green),)),
),
SizedBox(width: 150,
child: ElevatedButton(onPressed: (){
Navigator.pop(context);
}, child: Text("Cencel",style: TextStyle(fontSize: 20,color: Colors.red),)),
),
],
)
],
),
);
});
*/



















