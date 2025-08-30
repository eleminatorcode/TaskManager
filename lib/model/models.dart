import 'package:flutter/cupertino.dart';

class todoData{
  final int id;
 final  String title;
  final String description;
  final bool isCompleted;

  const todoData( {
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
});
}