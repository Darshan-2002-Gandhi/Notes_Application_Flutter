import 'package:database_demo/data/local/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  List<Map<String, dynamic>> allNotes = [];
  dbHelper? dbRef;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbRef = dbHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes', style: TextStyle(fontSize: 30.sp)),
        centerTitle: true,
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  title: Text(
                    allNotes[index][dbHelper.COLUNM_NOTE_TITLE],
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    allNotes[index][dbHelper.COLUNM_NOTE_DESC],
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  trailing: SizedBox(
                    width: 50.w,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            titleController.text =
                                allNotes[index][dbHelper.COLUNM_NOTE_TITLE];
                            descController.text =
                                allNotes[index][dbHelper.COLUNM_NOTE_DESC];
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return getBottomSheetWidget(
                                  isUpdate: true,
                                  sno:
                                      allNotes[index][dbHelper.COLUNM_NOTE_SNO],
                                );
                              },
                            );
                          },
                          child: Icon(Icons.edit, size: 25),
                        ),
                        InkWell(
                          onTap: () async {
                            bool check = await dbRef!.deleteNote(
                              sno: allNotes[index][dbHelper.COLUNM_NOTE_SNO],
                            );
                            if (check) {
                              getNotes();
                            }
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text("no notes yet", style: TextStyle(fontSize: 25.sp)),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          titleController.clear();
          descController.clear();
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return getBottomSheetWidget();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getBottomSheetWidget({bool isUpdate = false, int sno = 0}) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 30,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isUpdate ? 'Update Note ' : "Add Note",
              style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter title here ",
                label: Text('Title', style: TextStyle(fontSize: 18.sp)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter description ",
                label: Text('Desc.', style: TextStyle(fontSize: 18.sp)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1.2.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    onPressed: () async {
                      var Title = titleController.text;
                      var Desc = descController.text;
                      if (Title.isNotEmpty && Desc.isNotEmpty) {
                        bool check = isUpdate
                            ? await dbRef!.updateNote(
                                mTitle: Title,
                                mDesc: Desc,
                                sno: sno,
                              )
                            : await dbRef!.addNote(mTitle: Title, mDesc: Desc);
                        if (check) {
                          getNotes();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please fill all details")),
                        );
                      }
                      titleController.clear();
                      descController.clear();
                      Navigator.pop(context);
                    },
                    child: Text(
                      isUpdate ? "Update Note" : "Add Note",
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1.2.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    onPressed: () {
                      titleController.clear();
                      descController.clear();
                      Navigator.pop(context);
                    },
                    child: Text("Cancel", style: TextStyle(fontSize: 18.sp)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
