import 'package:beshence_sdk_flutter/beshence_sdk_flutter.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:notes/events/delete_note_v1.dart';
import 'package:notes/events/update_note_text_v1.dart';
import 'package:notes/events/update_note_title_v1.dart';

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
    BeshenceChain notesChain = await (Beshence.selectedAccount)!.requireChain('notes');

    String title = titleController.text;
    String text = textController.text;

    UpdateNoteTitleV1Event? titleEvent;
    UpdateNoteTextV1Event? textEvent;

    var timestamp = DateTime.timestamp();

    if(note.title != title) {
      titleEvent = UpdateNoteTitleV1Event(
          noteId: note.id,
          title: title,
          updatedAt: timestamp);
      await notesChain.addEvent(titleEvent);
    }

    if(note.text != text) {
      textEvent = UpdateNoteTextV1Event(
          noteId: note.id,
          text: text,
          updatedAt: timestamp);
      await notesChain.addEvent(textEvent);
    }

    if(titleEvent != null || textEvent != null) {
      note = NoteV1(
        id: note.id,
        accountId: note.accountId,
        createdAt: note.createdAt,
        title: titleEvent != null ? title : note.title,
        titleUpdatedAt: titleEvent != null ? timestamp : note.titleUpdatedAt,
        text: textEvent != null ? text : note.text,
        textUpdatedAt: textEvent != null ? timestamp : note.textUpdatedAt,
        deleted: note.deleted,
        deletionStateChangedAt: note.deletionStateChangedAt,
      );

      await NoteV1.updateNote(note);
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
    final fetchedNote = NoteV1.getNote(widget.noteId);
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
                         BeshenceChain notesChain = await (Beshence.selectedAccount)!.requireChain('notes');
                         var timestamp = DateTime.timestamp();
                         DeleteNoteV1Event event = DeleteNoteV1Event(
                             noteId: note.id, deletedAt: timestamp);
                         notesChain.addEvent(event);
                        var deletedNote = NoteV1(
                          id: note.id,
                          accountId: note.accountId,
                          createdAt: note.createdAt,
                          title: note.title,
                          titleUpdatedAt: note.titleUpdatedAt,
                          text: note.text,
                          textUpdatedAt: note.textUpdatedAt,
                          deleted: true,
                          deletionStateChangedAt: timestamp,
                        );
                        await NoteV1.updateNote(deletedNote);
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
