import 'package:api_curd/models/apiResponse_model.dart';
import 'package:api_curd/models/notelist_model.dart';
import 'package:api_curd/services/noteService.dart';
import 'package:flutter/material.dart';
import 'note_delete.dart';
import 'note_modify.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  APIResponse<List<Note>> _apiResponse;
  bool _isloading = false;

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  _fetchNotes() async {
    setState(() => _isloading = true);
    _apiResponse = await NotesService.getNotesList();
    setState(() => _isloading = false);
  }

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('List of notes')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => NoteModify()))
                .then((_) {
              print('===========OK===========');
              _fetchNotes();
            });
          },
          child: Icon(Icons.add),
        ),
        body: Builder(builder: (_) {
          if (_isloading) {
            return Center(child: CircularProgressIndicator());
          }
          if (_apiResponse.error) {
            return Center(child: Text(_apiResponse.errorMessage));
          }
          return ListView.separated(
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: Colors.green),
            itemBuilder: (_, index) {
              return Dismissible(
                key: ValueKey(_apiResponse.data[index].noteID),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {},
                confirmDismiss: (direction) async {
                  final result = await showDialog(
                      context: context, builder: (_) => NoteDelete());
                  print(result);
                  return result;
                },
                background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(left: 16),
                  child: Align(
                    child: Icon(Icons.delete, color: Colors.white),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    _apiResponse.data[index].noteTitle,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  subtitle: Text(
                      'Last edited on ${formatDateTime(_apiResponse.data[index].latestEditDateTime)}'),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (_) => NoteModify(
                                noteID: _apiResponse.data[index].noteID)))
                        .then((_) {
                          print('===========OK===========');
                      _fetchNotes();
                    });
                  },
                ),
              );
            },
            itemCount: _apiResponse.data.length,
          );
        }));
  }
}
