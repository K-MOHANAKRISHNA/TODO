import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:todoflutter/data/database.dart';
import 'package:todoflutter/pages/home_page.dart';

class AddToTodo extends StatefulWidget {
  const AddToTodo({super.key});

  @override
  State<AddToTodo> createState() => _AddToTodoState();
}

class _AddToTodoState extends State<AddToTodo> {
  // Box<TodoModel> box= Hive.box<TodoModel>('todoDB');
  
  final List<String> items = ["Low","Medium","High"];
  final TextEditingController type = TextEditingController();

  ToDoDataBase db = ToDoDataBase();
  TextEditingController title=TextEditingController();
  TextEditingController discription =TextEditingController();
  TextEditingController dateController = TextEditingController();

  void saveNewTask() {
    db.loadData();
    db.toDoList.add([
      title.text,
      discription.text,
      dateController.text,
      DateTime.now().toString(),
      type.text,
      false]
    );
    db.updateDataBase();
    title.clear();
    discription.clear();
    dateController.clear();
    type.clear();
    Navigator.push(context,MaterialPageRoute(builder: (context)=> const HomePage()));
    // Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(),
      body:  Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: title,
              
              decoration: const InputDecoration(
                // focusedBorder: InputBorder.none,
                // border: InputBorder.none
                hintText: "Title"
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: discription,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Discription"
              ),
            ),
            TextField(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context, 
                  initialDate: DateTime.now(), 
                  firstDate: DateTime.now(), 
                  lastDate: DateTime(2048),
                  onDatePickerModeChange: (value) {
                  },
                );
                if (picked != null && picked != dateController.text) {
                  dateController.text = "${picked.toLocal()}".split(' ')[0];
                }
              },
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(
              // focusedBorder: InputBorder.none,
              // border: InputBorder.none
              hintText: "Due Date",
              ),
            ),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return items;
                }
                return items.where((String option) {
                  return items.contains(textEditingValue.text.toLowerCase());
                });
              },
              initialValue: const TextEditingValue(text: ""),
              onSelected: (String selection) {
                type.text=selection;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (){
                  if(title.text.isEmpty || discription.text.isEmpty || dateController.text.isEmpty || type.text.isEmpty){
                    Get.snackbar("", "",backgroundColor: Colors.white,duration: const Duration(seconds: 2),titleText: const Text("WARNING",style: TextStyle(color:Colors.red,fontSize: 15,fontWeight: FontWeight.bold),),messageText: const Text("Please Fill the Form",style: TextStyle(fontSize: 15)),icon: const Icon(Icons.warning,color: Colors.red,));
                  }else{
                    saveNewTask();
                    // Navigator.push(context,MaterialPageRoute(builder: (context)=> const HomePage()));
                  }

                }, child: const Text("Add")),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
}