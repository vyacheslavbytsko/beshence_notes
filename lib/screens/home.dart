import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../models/note_v1.dart';
import '../misc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beshence Notes"),
      ),
      body: SafeArea(
          top: false,
          bottom: false,
          left: true,
          right: true,
          child: CustomScrollView(
              slivers: [
                SliverList(delegate: SliverChildListDelegate([
                  ListenableBuilder(
                      listenable: notesChangeNotifier,
                      builder: (BuildContext context, Widget? child) => FutureBuilder(
                        future: NoteV1.getAllNotesSorted(),
                        initialData: List<NoteV1>.empty(),
                        builder: (context, snapshot) {
                          List<NoteV1> notes = snapshot.requireData;
                          List<Widget> notesWidgets = [];
                          for (NoteV1 note in notes) {
                            notesWidgets.add(Card(
                              color: ElevationOverlay.applySurfaceTint(
                                  Theme.of(context).colorScheme.surface,
                                  Theme.of(context).colorScheme.surfaceTint,
                                  3),
                              margin: EdgeInsets.zero,
                              child: InkWell(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                onTap: () => context.go("/note/${note.id}"),
                                child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (note.title != "")
                                          Text(
                                            note.title,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        if (note.text != "" && note.title != "")
                                          SizedBox.fromSize(size: Size(0, 12)),
                                        if (note.text != "")
                                          Text(
                                            note.text,
                                            style: TextStyle(fontSize: 14),
                                            maxLines: 5,
                                            overflow: TextOverflow.fade,
                                          )
                                      ],
                                    )),
                              ),
                            ));
                          }
                          return notes.isNotEmpty
                              ? Padding(
                              padding: EdgeInsets.only(
                                  top: 0,
                                  left: 16,
                                  bottom: 88,
                                  right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: 16,
                                children: notesWidgets,
                              ))
                              : SizedBox.shrink();
                          },
                      )
                  ),
                ])),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: ListenableBuilder(
                    listenable: notesChangeNotifier,
                    builder: (BuildContext context, Widget? child) => FutureBuilder(
                        future: NoteV1.getNotesCount(),
                        builder: (context, snapshot) {
                          if(snapshot.data != 0) return SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 88),
                            child: Center(
                              child: Text("No notes."),
                            ),
                          );
                        },
                    )
                  ),
                )
              ]
          )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNewNote,
        label: Text("New note"),
        icon: Icon(Icons.edit),
      ),
    );
  }

  Future<void> _openNewNote() async {
    DateTime timestamp = DateTime.timestamp();
    NoteV1 note = NoteV1(
        id: Uuid().v4(),
        createdAt: timestamp,
        title: "",
        titleModifiedAt: null,
        text: "",
        textModifiedAt: null,
        deleted: false,
        deletionStateChangedAt: null);
    // CreateNoteEvent event = CreateNoteEvent(noteId: note.id, noteCreatedAt: timestamp, applied: true);
    await NoteV1.addNote(note);
    //eventsBox.addEvent(event);
    notesChangeNotifier.updateNotes();
    context.go('/note/${note.id}');
  }
}