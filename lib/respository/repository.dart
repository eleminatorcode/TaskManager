

import 'package:task_manager/model/models.dart';
import 'package:task_manager/services/services.dart';

class TodoRepository{
  final TodoService service;
 const TodoRepository(
  this.service
);

 Future<List<todoData>> taskList  () async{
   final list = await service.getTodo();
   return list.map((m){
   final id = (m['id']as num?)?.toInt() ?? 0 ;
   final title = (m['title']as String? ) ?? '' ;
   final isCompleted = (m['completed']as bool?)??false;
   final description =(m['description']as String?)??'';
return todoData(id: id, title: title, description: description, isCompleted: isCompleted);
   }).toList();

 }

 Future<todoData> addTask({required String title,required String description, bool completed=false}) async{
   final map = await service.postTodo(title:title , description: description,isCompleted: completed);
   final id = (map['id']as num?)?.toInt()??0;
   final tit = (map['title']as String?)??'';
   final des = (map['description']as String?)??'';
   final com = (map['completed']as bool?)?? false;
   return todoData(id: id, title: tit, description: des, isCompleted: com);
 }


}