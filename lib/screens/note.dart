import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';

import '../models/note_v1.dart';
import '../misc.dart';

class NoteScreen extends StatefulWidget {
  final String noteId;
  const NoteScreen({super.key, required this.noteId});

  @override
  State<StatefulWidget> createState() => _NoteScreenState();
}


class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final FocusNode textFocusNode = FocusNode();

  DateTime titleLastModified = DateTime.timestamp();
  DateTime textLastModified = DateTime.timestamp();
  late NoteV1 note;

  Future<void> saveNote() async {
    String title = titleController.text;
    String text = textController.text;
    bool updateTitle = false;
    bool updateText = false;

    if(note.title != title) {
      updateTitle = true;
    }
    if(note.text != text) {
      updateText = true;
    }
    if(updateTitle || updateText) {
      var timestamp = DateTime.timestamp();

      note = NoteV1(
        id: note.id,
        accountId: note.accountId,
        createdAt: note.createdAt,
        title: updateTitle ? title : note.title,
        titleModifiedAt: updateTitle ? timestamp : note.titleModifiedAt,
        text: updateText ? text : note.text,
        textModifiedAt: updateText ? timestamp : note.textModifiedAt,
        deleted: note.deleted,
        deletionStateChangedAt: note.deletionStateChangedAt,
      );

      await NoteV1.updateNote(note);
      //eventsBox.addEvent(event);
      notesChangeNotifier.updateNotes();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    textController.dispose();
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initializeNote();
    super.initState();
  }

  Future<void> _initializeNote() async {
    final fetchedNote = await NoteV1.getNote(widget.noteId);
    if (fetchedNote != null) {
      setState(() {
        note = fetchedNote;
        titleController.text = note.title;
        textController.text = note.text;
      });

      titleController.addListener(() async {
        DateTime thisTitleLastModified = DateTime.timestamp();
        titleLastModified = thisTitleLastModified;
        await Future.delayed(Duration(seconds: 3), () {
          if(titleLastModified == thisTitleLastModified) {
            saveNote();
          }
        });
      });

      textController.addListener(() async {
        DateTime thisTextLastModified = DateTime.timestamp();
        textLastModified = thisTextLastModified;
        await Future.delayed(Duration(seconds: 3), () {
          if(textLastModified == thisTextLastModified) {
            saveNote();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          if(result != "delete") {
            saveNote();
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            actions: [
              PopupMenuButton<String>(
                elevation: 10,
                constraints: BoxConstraints(minWidth: 128),
                borderRadius: BorderRadius.all(Radius.circular(100)),
                surfaceTintColor: Theme.of(context).colorScheme.primary,
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                       onTap: () async {
                        /*DeleteNoteEvent event = DeleteNoteEvent(
                            noteId: note.id,
                            noteDeletedAt: DateTime.timestamp(),
                            applied: true);*/
                        var deletedNote = NoteV1(
                          id: note.id,
                          accountId: note.accountId,
                          createdAt: note.createdAt,
                          title: note.title,
                          titleModifiedAt: note.titleModifiedAt,
                          text: note.text,
                          textModifiedAt: note.textModifiedAt,
                          deleted: true,
                          deletionStateChangedAt: DateTime.timestamp(),
                        );
                        await NoteV1.updateNote(deletedNote);
                        //eventsBox.addEvent(event);
                        notesChangeNotifier.updateNotes();
                        context.pop("delete");
                      },
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(
                            width: 8,
                          ),
                          Text("Delete")
                        ],
                      ),
                    ),
                  ];
                },
              )
            ],
          ),
          body: SafeArea(
            top: false, bottom: false, left: true, right: true,
            child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate(
                          [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  TextField(
                                    style: TextStyle(fontSize: 24),
                                    scrollPhysics: NeverScrollableScrollPhysics(),
                                    controller: titleController,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: "Title",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                  TextField(
                                    focusNode: textFocusNode,
                                    scrollPhysics: NeverScrollableScrollPhysics(),
                                    maxLines: null,
                                    controller: textController,
                                    //style: TextStyle(height: 1.25),
                                    decoration: InputDecoration(
                                      hintText: "Start writing...",
                                      border: InputBorder.none,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]
                      )
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: GestureDetector(
                      onTap: () {
                        textFocusNode.requestFocus();
                        textController.selection = TextSelection.fromPosition(TextPosition(offset: textController.text.length));
                        SystemChannels.textInput.invokeMethod("TextInput.show");
                      },
                    ),
                  )
                ]
            ),
          )
      ),
    );
  }
}
