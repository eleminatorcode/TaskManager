import 'dart:convert';
import 'package:http/http.dart' as http;
class TodoService {
   final url;

  TodoService({
    this.url='https://jsonplaceholder.typicode.com/todos',
  });

   Future<List<Map<String,dynamic>>> getTodo() async {
   final baseUrl = Uri.parse('https://jsonplaceholder.typicode.com/todos');
    final response =await http.get(baseUrl);
    if(response.statusCode!=200){
      throw Exception('GET /todos failed: ${response.statusCode} ${response.reasonPhrase}');

    }
    final List<dynamic>data = jsonDecode(response.body);
    return data.cast<Map<String,dynamic>>();
  }

  Future<Map<String,dynamic>> postTodo({
  required String title,
  required String description,
   bool isCompleted = false,
    int userId = 1,

  })async{

    final baseUrl = Uri.parse('https://jsonplaceholder.typicode.com/todos');
    final response = await http.post(baseUrl,
      headers:{'Content-Type':
      'application/json; charset=UTF-8'},
    body: jsonEncode(
      {
        'title':title,
        'userID':userId,
        'completed':isCompleted,
        'description':description
      }
    ));
    if(response.statusCode==200|| response.statusCode==201){
      print('Successfully posted ${response.statusCode}:${response.body}');
    }
    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object');
    }
    return data;
  }

}
