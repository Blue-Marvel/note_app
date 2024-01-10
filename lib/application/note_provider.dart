import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/domain/model.dart';
import 'package:todo/repository/db_note.dart';

final todoProvider = ChangeNotifierProvider((ref) => TodoProvider());

class TodoProvider extends ChangeNotifier {
  List<NoteModel> _todoList = [];
  Map<String, String> _todoData = {};

  List<NoteModel> get noteList => _todoList;
  Map<String, String> get noteData => _todoData;

  void createTodo({required String title, required String description}) async {
    _todoData = {
      "title": title,
      "description": description,
    };
    await TodoDB.addTodo(todoData: _todoData);
    notifyListeners();
  }

  void getAllNote() async {
    try {
      final list = await TodoDB.getAllTodos();
      _todoList = list;
      notifyListeners();
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }

  void listenToAction() {}

  // Future
}
