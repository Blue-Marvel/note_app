import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/domain/model.dart';
import 'package:todo/presentation/edit_note.dart';
import 'package:todo/repository/db_note.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  late Future<List<NoteModel>> todoFuture;

  @override
  void initState() {
    todoFuture = TodoDB.getAllTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EditNote(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: todoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 50,
                height: 50,
                child: LinearProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error loading: ${snapshot.error}"),
              );
            }
            final todoData = snapshot.data;
            // print("${todoData![0].id} ${todoData[0].title}");
            return todoData!.isEmpty
                ? const Center(
                    child: Text(
                      "You don't Any Notes yet\nClick the button below to add notes",
                      textAlign: TextAlign.center,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: todoData.length,
                      itemBuilder: (_, index) {
                        final data = todoData[index];
                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditNote(
                                  id: data.id,
                                  title: data.title,
                                  description: data.description),
                            ),
                          ),
                          onLongPress: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (_) {
                                return CupertinoAlertDialog(
                                  title: const Text("Delete Note"),
                                  content: const Text(
                                      "Are you sure you want to delete this note?"),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: const Text("Delete"),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const NoteList()));
                                        TodoDB.deleteTodo(data);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Card(
                            shadowColor: Colors.white,
                            child: ListTile(
                              title: Text(
                                data.title,
                              ),
                              subtitle: Text(
                                data.description,
                                maxLines: 4,
                                overflow: TextOverflow.clip,
                                softWrap: true,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
          }),
    );
  }
}
