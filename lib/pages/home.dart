
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
 const Home ({key}): super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
  class _HomeState extends State<Home> {

  final myController = TextEditingController();
  bool submit = false;

  Color mainColor = Color(0xFFEEEFF5);
  Color secColor = Color(0xFF3A3A3A);
  Color tdBlue = Color(0xFF5F52EE);


String temp = "";
  List<String> todoList = [];

  @override
  void initState() {

    super.initState();

    myController.addListener(() {
      setState(() {
        submit = myController.text.isNotEmpty;
      });
    });

    omLoadData();

  }

  submitData() async {
    setState(() {
      todoList.add(temp);
      clearText();
      onSaveData();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todo_list', todoList);
  }


  omLoadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("todo_list");
    todoList.addAll(data!);
  }

  onSaveData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todo_list', todoList);
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void clearText() {
      myController.clear();
  }


     @override
  Widget build(BuildContext context){
   return Scaffold(
      backgroundColor: mainColor,
     appBar: AppBar(
       elevation: 0.0,
       backgroundColor: secColor,
      title: Text ('TODO - List', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, fontFamily: 'JosefinSans'),),
     ),
        body: Column(
          children: [
            Container(

              margin: EdgeInsets.only(
                top: 15.0,
                left: 13.0,
                right: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (String value) {
                        temp = value;
                      },

                      controller: myController,
                      decoration:
                      InputDecoration(
                          prefixIcon: Icon(Icons.notes, color: Colors.orangeAccent,),
                          labelText: 'Замітка',
                          hintText: 'Введіть замітку',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(10.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30.0),),

                          ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: tdBlue),
                    onPressed:
                    submit ? () => submitData() : null,
                    child:
                    Text('+', style: TextStyle(fontSize: 37),),
                  ),
                ], // Закривається 2-ий чілдрен
              ), //Row 1-ий
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 5.0,
                ),
                child: ListView.builder(

                    itemCount: todoList.length,
                    itemBuilder: (BuildContext context, int index){
                      final item  = todoList[index] ;
                       return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: const Card(color: Colors.red,
                        child: Icon(Icons.delete_sweep,size: 30, color: Colors.white,)
                        ),
                        key: Key(todoList[index]),
                         onDismissed:
                             (direction) {
                          if (direction == DismissDirection.endToStart) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" note: $item - has been deleted")));
                          }  
                           setState(() async {
                             todoList.removeAt(index);
                             onSaveData();
                           });
                         },
                        child: Card(
                          margin: EdgeInsets.only(
                            top: 8.5,
                            left: 25.0,
                            right: 25.0,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                          elevation: 0.0,
                          child:
                          ListTile(
                            title: Text(todoList[index],style: TextStyle(fontFamily: 'Arial', fontSize: 16),),),

                        ),

                      );
                    },
                ),
              )

            ),

          ], // Закривається 1-ий чілдрен
        ),
   );
  }

}