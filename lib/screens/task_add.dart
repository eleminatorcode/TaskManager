import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloctask/bloc_screen.dart';
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final title =TextEditingController();
  final desc =TextEditingController();
  @override
  void dispose() {
    title.dispose();
    desc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task')
      ),
      body:Center(
        child:
        Column(
          children: [
            SizedBox(
              height: 50,
              width: 304,
              child: TextField(
                controller:title ,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  fillColor: Colors.grey,
                  filled: true,
                  hintText: 'Enter Title',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12)
                      )
                ),
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(
              height: 150,
              width: 304,
              child: TextField(

                maxLines: null,
                expands: true,
                controller: desc,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey,
                  hintText: 'Description',

                  border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(
               width: 200,
              child:
              ElevatedButton(onPressed: ()async{
                final t = title.text.trim();
                final d =desc.text.trim();
                if(t.isEmpty) return;
                context.read<TaskBloc>().add(TaskAdd(t, d));
                Navigator.maybePop(context);
              }, child:Text( 'Save',style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.blueAccent),

                ),

              ),
            )
          ],
        ),
      ) ,
    );

  }
}
