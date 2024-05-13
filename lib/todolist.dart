import 'package:flutter/material.dart';

class ToDoListPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<String> _toDoItems = [];

  void _addNewItem() async {
    String result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('新增TODO项'),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(labelText: '请输入 ToDo item'),
          onSubmitted: (value) {
            Navigator.of(context).pop(value);
          },
        ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _toDoItems.add(result);
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _toDoItems.removeAt(index);
    });
  }

  void _editItem(int index) async {
    String result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('编辑 Item'),
        content: TextField(
          autofocus: true,
          controller: TextEditingController(text: _toDoItems[index]),
          decoration: InputDecoration(labelText: '请输入 ToDo item'),
          onSubmitted: (value) {
            Navigator.of(context).pop(value);
          },
        ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _toDoItems[index] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List'),
        automaticallyImplyLeading: false, // 不显示返回箭头
      ),
      body: ListView.builder(
        itemCount: _toDoItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(_toDoItems[index]),
            onDismissed: (direction) {
              _removeItem(index);
            },
            background: Container(
              color: Colors.red,
              child: Icon(Icons.delete),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
            ),
            child: Card(
              elevation: 4, // Add elevation for a raised effect
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Add margin for spacing
              child: ListTile(
                title: Text(
                  _toDoItems[index],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto', // Apply custom font
                  ),
                ),
                trailing: Icon(Icons.edit), // Add an edit icon as a trailing widget
                onTap: () {
                  _editItem(index);
                },
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addNewItem,
        tooltip: '新增 Item',
        child: Icon(Icons.add),
      ),
    );
  }
}