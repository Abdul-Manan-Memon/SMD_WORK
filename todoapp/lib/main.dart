import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum StatusTypes { OPEN, IN_PROGRESS, COMPLETED }

class TodoItem {
  int id = 0;
  String title = '';
  String description = '';
  StatusTypes status = StatusTypes.OPEN;

  TodoItem(this.id, this.title, this.description, [String s = '']);
}

class MyApp extends StatefulWidget {
  const MyApp();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO_APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> _todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const My_Drawer(),
      appBar: AppBar(
        title: const Text('TO-DO APP'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: TodoList(todoList: _todoList),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) {
              return CreateTaskDialogBox(todoList: _todoList);
            },
          );
        },
        backgroundColor: Colors.black,
        hoverColor: Colors.white,
        tooltip: 'Add a New Task',
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class CreateTaskDialogBox extends StatefulWidget {
  final List<TodoItem> todoList;
  const CreateTaskDialogBox({Key? key, required this.todoList})
      : super(key: key);

  @override
  _CreateTaskDialogBoxState createState() => _CreateTaskDialogBoxState();
}

class _CreateTaskDialogBoxState extends State<CreateTaskDialogBox> {
  List<String> status = ['OPEN', 'IN_PROGRESS', 'COMPLETED'];
  String selected = 'OPEN';
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(
          onPressed: () {
            final title = _titleController.text;
            final description = _descriptionController.text;
            final status = selected;
            final newTodoItem = TodoItem(
              DateTime.now().millisecondsSinceEpoch,
              title,
              description,
            );

            setState(() {
              widget.todoList.add(newTodoItem);
            });

            Navigator.of(context).pop();
          },
          child: const Text('Submit'),
        ),
      ],
      title: const Text('New Task'),
      content: SizedBox(
        height: 200,
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Description',
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selected,
              onChanged: (String? newValue) {
                setState(() {
                  selected = newValue!;
                });
              },
              items: status
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class My_Drawer extends StatelessWidget {
  const My_Drawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
              height: 80.0,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Center(
                    child: Text(
                  'TASK STATUS',
                  style: TextStyle(color: Colors.white),
                )),
              )),
          ListTile(
            leading: const Icon(
              Icons.warning_outlined,
              color: Colors.deepOrange,
            ),
            title: const Text('OPEN'),
            onTap: () => {Navigator.pop(context)},
          ),
          ListTile(
            leading: const Icon(
              Icons.task_alt_outlined,
              color: Colors.lightGreen,
            ),
            title: const Text('IN-PROGRESS'),
            onTap: () => {Navigator.pop(context)},
          ),
          ListTile(
            leading: const Icon(Icons.verified_rounded, color: Colors.green),
            title: const Text('COMPLETED'),
            onTap: () => {Navigator.pop(context)},
          )
        ],
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  final List<TodoItem> todoList;
  const TodoList({Key? key, required this.todoList}) : super(key: key);
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  void add_item(TodoItem new_item) {
    setState(() {
      widget.todoList.add(new_item);
    });
  }

  void delete_item(TodoItem item) {
    setState(() {
      widget.todoList.remove(item);
    });
  }

  void change_status(TodoItem item, StatusTypes status) {
    setState(() {
      item.status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.todoList.length,
      itemBuilder: (BuildContext context, int index) {
        TodoItem item = widget.todoList[index];
        return Dismissible(
          key: Key(item.id.toString()),
          onDismissed: (direction) {
            delete_item(item);
          },
          child: Card(
            child: ListTile(
              title: Text(item.title),
              subtitle: Text(item.description),
              trailing: DropdownButton<StatusTypes>(
                value: item.status,
                onChanged: (StatusTypes? newStatus) {
                  if (newStatus != null) {
                    change_status(item, newStatus);
                  }
                },
                items: StatusTypes.values.map((StatusTypes status) {
                  return DropdownMenuItem<StatusTypes>(
                    value: status,
                    child: Text(
                      status.toString().split('.').last,
                      style: TextStyle(
                        color: status == StatusTypes.COMPLETED
                            ? Colors.green
                            : status == StatusTypes.IN_PROGRESS
                                ? Colors.orange
                                : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
