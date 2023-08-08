import 'package:flutter/material.dart';
import 'package:map_exam/note.dart';

class EditScreen extends StatefulWidget {
  // static Route route() => MaterialPageRoute(builder: (_) => const EditScreen());
  final bool isView;
  final bool isNew;
  final Note? note;

  const EditScreen({
    Key? key,
    this.isView = false,
    this.isNew = false,
    this.note,
  }) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    final _titleController = TextEditingController(
        text: (widget.note != null) ? '${widget.note?.title}' : '');
    final _descriptionController = TextEditingController(
        text: (widget.note != null) ? '${widget.note?.content}' : '');

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text((widget.isView == false)
            ? 'Edit Note'
            : (widget.isNew == true)
                ? 'New Note'
                : 'View Note'),
        actions: [
          if (widget.isView == false)
            IconButton(
                icon: const Icon(
                  Icons.check_circle,
                  size: 30,
                ),
                onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.cancel_sharp,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              initialValue: null,
              enabled: true,
              decoration: const InputDecoration(
                hintText: 'Type the title here',
              ),
              readOnly: (widget.isView == false) ? false : true,
              onChanged: (value) {},
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: TextFormField(
                controller: _descriptionController,
                enabled: true,
                initialValue: null,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Type the description',
                ),
                readOnly: (widget.isView == false) ? false : true,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
