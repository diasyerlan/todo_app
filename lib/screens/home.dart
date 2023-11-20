import 'package:flutter/material.dart';
import 'package:todo_copy/constants/colors.dart';
import 'package:todo_copy/models/todo.dart';
import 'package:todo_copy/widgets/todo_item.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final toDoList = ToDo.todoList();
  List<ToDo> _foundToDoList = [];
  final _toDoController = TextEditingController();

  @override
  void initState() {
    _foundToDoList = toDoList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _appbar(),
      body: Stack(children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              SearchBox(),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50, bottom: 20),
                      child: Text(
                        'All ToDos',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    for (ToDo todo in _foundToDoList.reversed)
                      ToDoItem(
                        todo: todo,
                        onToDoChange: _handleToDochange,
                        onDeleteItem: _handleDeleteItem,
                      )
                  ],
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                margin: EdgeInsets.only(bottom: 40, right: 20, left: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)],
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _toDoController,
                  decoration: InputDecoration(
                      hintText: "Add a new task", border: InputBorder.none),
                ),
              )),
              Container(
                margin: EdgeInsets.only(bottom: 40, right: 20),
                child: ElevatedButton(
                  onPressed: () {
                    _addToDoItem(_toDoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue, elevation: 10),
                  child: Text(
                    '+',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }

  AppBar _appbar() {
    return AppBar(
      backgroundColor: tdBGColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
          Container(
            height: 50,
            width: 50,
            child: ClipRRect(
              child: Image.asset(
                'assets/images/ava.png',
              ),
              borderRadius: BorderRadius.circular(25),
            ),
          )
        ],
      ),
    );
  }

  void searchToDoItems(String newKeyword) {
    List<ToDo> result = [];
    if (newKeyword.isEmpty) {
      result = toDoList;
    } else {
      result = toDoList
          .where((element) => element.todoText!
              .toLowerCase()
              .contains(newKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDoList = result;
    });
  }

  void _addToDoItem(String newTodo) {
    setState(() {
      toDoList.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: newTodo));
    });
    _toDoController.clear();
  }

  void _handleToDochange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _handleDeleteItem(String id) {
    setState(() {
      toDoList.removeWhere((element) => element.id == id);
    });
  }

  Widget SearchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: TextField(
        onChanged: (value) => searchToDoItems(value),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: tdBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: tdGrey)),
      ),
    );
  }
}
