import 'package:flutter/material.dart';
import 'package:todos/todo_model.dart';
import 'package:todos/todos_service.dart';


final todosService = TodosService();

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: todosService.create,
          )
        ],
      ),
      body: StreamBuilder(
          stream: todosService.stream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final todos = snapshot.data ?? [];
              if (todos.isEmpty) {
                return const Center(child: Text('No todos found'));
              }
              todos.reversed;
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return TodoTile(todo: todo);
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class TodoTile extends StatefulWidget {
  const TodoTile({super.key, required this.todo});

  final Todo todo;
  bool get isNewTodo {
    return todo.title.isEmpty && todo.content.isEmpty;
  }

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  late bool _isExpanded;
  late bool _isEditing;

  @override
  void initState() {
    _titleController.text = widget.todo.title;
    _contentController.text = widget.todo.content;
    setState(() {
      _isEditing = widget.isNewTodo;
      _isExpanded = widget.isNewTodo;
    });
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        _isEditing
            ? TextField(
                controller: _contentController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                    hintText: 'Content',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                    border: InputBorder.none),
              )
            : Text(
                widget.todo.content,
                style: const TextStyle(fontSize: 18),
              ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            widget.todo.completed
                ? Container()
                : _isEditing
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            widget.todo.title = _titleController.text;
                            widget.todo.content = _contentController.text;
                            todosService.update(widget.todo);
                            _isEditing = false;
                            _isExpanded = false;
                          });
                        },
                        icon: const Icon(Icons.save),
                      )
                    : IconButton(
                        onPressed: () => setState(() => _isEditing = true),
                        icon: const Icon(Icons.edit),
                      ),
            IconButton(
              onPressed: () {
                todosService.delete(widget.todo);
                setState(() => _isExpanded = false);
              },
              icon: const Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () => setState(() {
                _isEditing = false;
                _isExpanded = false;
              }),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ],
    );

    return Card(
        color: _isEditing
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: _isEditing
                          ? TextField(
                              controller: _titleController,
                              style: const TextStyle(fontSize: 20),
                              decoration: const InputDecoration(
                                  hintText: 'Title',
                                  hintStyle:
                                      TextStyle(fontStyle: FontStyle.italic),
                                  border: InputBorder.none))
                          : Text(
                              widget.todo.title,
                              style: TextStyle(
                                fontSize: 20,
                                decoration: widget.todo.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                    ),
                    _isEditing
                        ? Container()
                        : Checkbox(
                            value: widget.todo.completed,
                            onChanged: (value) {
                              setState(() {
                                widget.todo.completed = value ?? false;
                                todosService.update(widget.todo);
                              });
                            },
                          ),
                  ],
                ),
              ),
              _isExpanded ? details : Container(),
            ],
          ),
        ));
  }
}
