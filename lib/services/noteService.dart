import 'dart:convert';

import 'package:api_curd/models/apiResponse_model.dart';
import 'package:api_curd/models/notelist_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NotesService {
  static const String apiURL = 'http://api.notes.programmingaddict.com';
  static const headers = {
    'apiKey': '64965478-cfd4-4e13-ac3b-43afdb1e3259',
    'Content-Type': 'application/json'
  };
  //fetching or Reading all Note
  static Future<APIResponse<List<Note>>> getNotesList() {
    return http.get(apiURL + '/notes', headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body) as List;
        List<Note> notes = jsonData.map((e) => Note.fromJson(e)).toList();
        return APIResponse<List<Note>>(data: notes);
      }
      return APIResponse<List<Note>>(
          error: true, errorMessage: 'Error Occured');
    }).catchError((_) =>
        APIResponse<List<Note>>(error: true, errorMessage: 'Error Occured!!'));
  }

  //fetching or reading by id
  static Future<APIResponse<Note>> getNote(noteId) {
    return http.get(apiURL + '/notes/$noteId', headers: headers).then(
        (response) {
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return APIResponse<Note>(data: Note.fromJson(jsonData));
      }
      return APIResponse<Note>(error: true, errorMessage: 'Error Occured');
    }).catchError(
        (_) => APIResponse<Note>(error: true, errorMessage: 'Error Occured'));
  }

  // creating note
  static Future<APIResponse<bool>> createNote(
      {@required String noteTitle, @required String noteContent}) {
    Map<String, String> data = {
      'noteTitle': noteTitle,
      'noteContent': noteContent
    };
    String body = json.encode(data);
    return http
        .post(apiURL + '/notes', headers: headers, body: body)
        .then((response) {
      if (response.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          error: true, errorMessage: 'Error Occured ,Could not post');
    }).catchError((_) => APIResponse<bool>(
            error: true, errorMessage: 'Error Occured ,Could not post'));
  }

  // updating note
  static Future<APIResponse<bool>> updateNote(
      {@required String noteId,
      @required String noteTitle,
      @required String noteContent}) {
    Map<String, String> data = {
      'noteTitle': noteTitle,
      'noteContent': noteContent
    };
    String body = json.encode(data);
    return http
        .put(apiURL + '/notes/$noteId', headers: headers, body: body)
        .then((response) {
      print(response.statusCode);
      if (response.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          error: true, errorMessage: 'Error Occured ,Could not post');
    }).catchError((_) => APIResponse<bool>(
            error: true, errorMessage: 'Error Occured ,Could not post'));
  }

  //delete note
  static Future<APIResponse<bool>> deleteNote({@required String noteId}) {
    return http
        .put(apiURL + '/notes/$noteId', headers: headers)
        .then((response) {
      print(response.statusCode);
      if (response.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          error: true, errorMessage: 'Error Occured ,Could not delete');
    }).catchError((_) => APIResponse<bool>(
            error: true, errorMessage: 'Error Occured ,Could not delete'));
  }
}
