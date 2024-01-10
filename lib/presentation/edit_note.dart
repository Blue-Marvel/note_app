import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/application/note_provider.dart';
import 'package:todo/domain/model.dart';
import 'package:todo/presentation/note_list.dart';
import 'package:todo/repository/db_note.dart';

class EditNote extends ConsumerStatefulWidget {
  final int? id;
  final String? title;
  final String? description;
  const EditNote({super.key, this.title, this.description, this.id});
  @override
  ConsumerState<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends ConsumerState<EditNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.title ?? '';
    descriptionController.text = widget.description ?? '';

    super.initState();
  }

  void addUpdateNote() async {
    if (widget.id == null) {
      ref.read(todoProvider).createTodo(
          title: titleController.text, description: descriptionController.text);

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      final todo = NoteModel(
          id: widget.id!,
          title: titleController.text,
          description: descriptionController.text);
      await TodoDB.updateTodo(todo);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const NoteList()));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Add...' : 'Edit...'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addUpdateNote,
        child: const Icon(Icons.check),
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: deviceSize.width * 0.05,
                      ),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.02,
                    ),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Add title...',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceSize.height * 0.03,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: deviceSize.width * 0.05,
                      ),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.02,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: 'Add description....',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
