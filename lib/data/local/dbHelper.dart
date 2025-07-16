import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class dbHelper{
  //singleton
  dbHelper._();

  static final dbHelper getInstance=dbHelper._();
  static final String TABLE_NOTE="note";
  static final String COLUNM_NOTE_SNO="s_no";
  static final String COLUNM_NOTE_TITLE="title";
  static final String COLUNM_NOTE_DESC="desc";
  Database? mydb;
  //open db
  Future<Database> getdb() async {
    /*if(mydb!=null){
      return mydb!;
    }
    else{
      mydb=await opendb();
      return mydb!;
    }*/
    mydb??=await opendb();
    return mydb!;
  }
  Future<Database> opendb() async{
    Directory appdir=await getApplicationDocumentsDirectory();
    String dbPath=join(appdir.path,"note.db");
    return await openDatabase(dbPath,onCreate:(db,version){
      // create all tables
      db.execute("create table $TABLE_NOTE($COLUNM_NOTE_SNO integer primary key autoincrement,$COLUNM_NOTE_TITLE text,$COLUNM_NOTE_DESC  text)");
      },version: 1);
  }
  //all query 
  //insert
  Future<bool> addNote({required String mTitle ,required String mDesc}) async {
    var db= await getdb();
    int rousEffected=await db.insert(TABLE_NOTE,{
      COLUNM_NOTE_TITLE:mTitle,
      COLUNM_NOTE_DESC:mDesc
    });
    return rousEffected>0;
  }
  //select
  Future<List<Map<String,dynamic>>> getAllNotes() async {
    var db= await getdb();
    List<Map<String,dynamic>> mData=await db.query(TABLE_NOTE);
    return mData;
  }
  Future<bool> updateNote({required String mTitle,required String mDesc,required int sno}) async {
    var db= await getdb();
    int rousEffected=await db.update(TABLE_NOTE,{
      COLUNM_NOTE_TITLE:mTitle,
      COLUNM_NOTE_DESC:mDesc
    },where: "$COLUNM_NOTE_SNO=$sno");
    return rousEffected>0;
  }
  Future<bool> deleteNote({required int sno}) async {
    var db= await getdb();
    int rowsEffected=await db.delete(TABLE_NOTE,where: '$COLUNM_NOTE_SNO=$sno');
    return rowsEffected>0;
  }
}