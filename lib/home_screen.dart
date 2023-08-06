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
  @override
  void initState() {
    super.initState();
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
                        return ListTile(
                          trailing: SizedBox(
                            width: 110.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
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
                          ),
                          title: Text('${note[index].title}'),
                          subtitle: (isTap == true)
                              ? Text('${note[index].content}')
                              : const Text(''),
                          onTap: () {},
                          onLongPress: () {},
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
