import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoflutter/pages/add_to_todo_page.dart';
import '../data/database.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][5] = !db.toDoList[index][5];
    });
    db.updateDataBase();
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>  false,
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          title: const Text('TO DO'),
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder:(context)=> AddToTodo()));
          },
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: ()async{
                // await Get.defaultDialog(
                //   title: db.toDoList[index][0],
                //   titleStyle: const TextStyle(color: Colors.blue),
                //   titlePadding: const EdgeInsets.only(top: 20),
                //   contentPadding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                //   content: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const SizedBox(
                //         height: 5,
                //       ),
                //       Text(db.toDoList[index][1].toString(),textAlign: TextAlign.justify,),
                //       const Divider(),
                //       Text('Due Date : ${db.toDoList[index][2]}'),
                //       const Divider(),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text('Created Date : ${db.toDoList[index][3].toString().split(' ')[0]}',textAlign: TextAlign.left),
                //           Text(db.toDoList[index][4])
                //         ],
                //       ),
                //     ],
                //   ),
                //   confirm: OutlinedButton(onPressed: (){
                //     Navigator.pop(context);
                //   }, child: const Text("Close",style: TextStyle(color: Colors.red),)),
                //   // cancel: Text(db.toDoList[index][4])
                // );
              },
              child: ToDoTile(
                taskName: db.toDoList[index][0],
                discription: db.toDoList[index][1],
                dueDate: db.toDoList[index][2],
                createdAt: db.toDoList[index][3],
                type: db.toDoList[index][4],
                taskCompleted: db.toDoList[index][5],
                onChanged: (value) => checkBoxChanged(value, index),
                deleteFunction: (context) => deleteTask(index),
              ),
            );
          },
        ),
      ),
    );
  }
}
