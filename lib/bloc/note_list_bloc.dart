import 'package:api_curd/services/noteService.dart';

class NotesListBloc{
  getnotes() async {
    return await NotesService.getNotesList(); 
  }
}
