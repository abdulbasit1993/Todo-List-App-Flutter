import 'dart:convert';

import 'package:flutter/material.dart';
import 'add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(item['title']),
                  subtitle: Text(item['content']),
                  trailing: PopupMenuButton(onSelected: (value) {
                    if (value == 'edit') {
                      // Open Edit Screen
                    } else if (value == 'delete') {
                      // Delete and remove the item
                      deleteById(id);
                    }
                  }, itemBuilder: (context) {
                    return [
                      PopupMenuItem(child: Text('Edit'), value: 'edit'),
                      PopupMenuItem(
                        child: Text('Delete'),
                        value: 'delete',
                      ),
                    ];
                  }),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: Text('Add Todo')),
    );
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    Navigator.push(context, route);
  }

  Future<void> deleteById(String id) async {
    // Delete the item
    final url =
        'https://amused-tank-top-bee.cyclic.app/api/todos/deleteTodo/${id}';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      // Remove the item from the list

    } else {
      // Show error
    }
  }

  Future<void> fetchTodo() async {
    final url = "https://amused-tank-top-bee.cyclic.app/api/todos/getTodos";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
