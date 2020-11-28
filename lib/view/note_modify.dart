import 'package:api_curd/models/apiResponse_model.dart';
import 'package:api_curd/models/notelist_model.dart';
import 'package:api_curd/services/noteService.dart';
import 'package:flutter/material.dart';

class NoteModify extends StatefulWidget {
  final String noteID;
  NoteModify({this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;
  String title;
  String errorMsg;
  String successMsg;
  APIResponse<Note> response;
  APIResponse<bool> created;
  Note note;

  TextEditingController _contentController = TextEditingController();
  TextEditingController _titleController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    fetchNote(widget.noteID);
    super.initState();
  }

  fetchNote(noteId) async {
    if (isEditing) {
      setState(() => _isLoading = true);
      response = await NotesService.getNote(noteId);
      if (response.error) {
        errorMsg = response.errorMessage ?? 'An Error Occurred';
      }
      note = response.data;
      _titleController.text = note.noteTitle;
      _contentController.text = note.noteContent;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit note' : 'Create note')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: 'Note title'),
                  ),
                  Container(height: 8),
                  TextFormField(
                    controller: _contentController,
                    decoration: InputDecoration(hintText: 'Note content'),
                  ),
                  Container(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: RaisedButton(
                      child:
                          Text('Submit', style: TextStyle(color: Colors.white)),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        if (isEditing) {
                          print('===============');
                          print(widget.noteID);
                          created = await NotesService.updateNote(
                              noteId: widget.noteID,
                              noteTitle: _titleController.text,
                              noteContent: _contentController.text);
                          if (created.error) {
                            title = 'Error!';
                            errorMsg =
                                created.errorMessage ?? 'Error Updating Node';
                          } else {
                            title = 'Done!';
                            successMsg = 'Successfully Updated Note';
                          }
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(title),
                              content: Text(errorMsg ?? successMsg),
                              actions: [
                                FlatButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    })
                              ],
                            ),
                          ).then((_) {
                            if (created.data) {
                              Navigator.of(context).pop();
                            }
                          });
                        } else {
                          created = await NotesService.createNote(
                            noteTitle: _titleController.text,
                            noteContent: _contentController.text,
                          );
                          if (created.error) {
                            title = 'Error!';
                            errorMsg =
                                created.errorMessage ?? 'Error Creating Node';
                          } else {
                            title = 'Done!';
                            successMsg = 'Successfully Created Note';
                          }
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(title),
                              content: Text(successMsg ?? errorMsg),
                              actions: [
                                FlatButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    })
                              ],
                            ),
                          ).then((_) {
                            if (created.data) {
                              Navigator.of(context).pop();
                            }
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
