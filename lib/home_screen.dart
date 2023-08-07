import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'note.dart';

class HomeScreen extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (_) => const HomeScreen());
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTileIndex = -1;

  void _handleTileLongPress(int index) {
    setState(() {
      if (selectedTileIndex == index) {
        selectedTileIndex = -1;
      } else {
        selectedTileIndex = index;
      }
    });
  }

  bool isTap = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState != ConnectionState.active) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        String uid = FirebaseAuth.instance.currentUser!.uid;

        return StreamBuilder<List<Note>>(
            stream: FirebaseFirestore.instance
                .collection('notes-$uid')
                .snapshots()
                .map((snapshots) => snapshots.docs
                    .map((doc) => Note.fromJson(doc.data()))
                    .toList()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final note = snapshot.data!;
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('My Notes'),
                    actions: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade200,
                        child: Text(
                          '${note.length}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22.0),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  body: ListView.separated(
                      itemCount: note.length,
                      separatorBuilder: (context, index) => const Divider(
                            color: Colors.blueGrey,
                          ),
                      itemBuilder: (context, index) {
                        return _NoteList(
                          note: note[index],
                          isTap: isTap,
                          isLongTap: selectedTileIndex == index,
                          onLongPress: () => _handleTileLongPress(index),
                        );
                      }),
                  floatingActionButton: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                          child: (isTap == true)
                              ? const Icon(Icons.menu)
                              : const Icon(Icons.unfold_less_sharp),
                          tooltip: 'Show less. Hide notes content',
                          onPressed: () {
                            setState(() {
                              isTap = !isTap;
                            });
                          }),

                      /* Notes: for the "Show More" icon use: Icons.menu */

                      FloatingActionButton(
                        child: const Icon(Icons.add),
                        tooltip: 'Add a new note',
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text("Error has occurred");
              }

              return Container(
                color: Colors.white,
              );
            });
      },
    );
  }
}

class _NoteList extends StatefulWidget {
  final Note note;
  final bool isTap;
  final Function() onLongPress;
  final bool isLongTap;
  const _NoteList({
    Key? key,
    required this.note,
    required this.isTap,
    required this.onLongPress,
    required this.isLongTap,
  }) : super(key: key);

  @override
  State<_NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<_NoteList> {
  // bool isLongTap = false;

  // void _toggleEditing() {
  //   setState(() {
  //     isLongTap = !isLongTap;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${widget.note.title}'),
      subtitle: (widget.isTap == true)
          ? Text('${widget.note.content}')
          : const Text(''),
      trailing: widget.isLongTap
          ? SizedBox(
              width: 110.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.blue,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            )
          : const SizedBox(),
      onTap: () {},
      onLongPress: widget.onLongPress,
    );
  }
}
