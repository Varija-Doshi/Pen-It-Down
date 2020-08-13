import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudMethods {
  bool isLoggedin() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else
      return false;
  }

  Future<void> addData(todo) async {
    if (isLoggedin()) {
      Firestore.instance.collection('todos').add(todo).catchError((e) {
        print(e);
      });
    } else {
      print("You need to be logged in");
    }
  }

  Future<void> doneData(data, docId) async {
    if (isLoggedin()) {
      Firestore.instance
          .collection('done')
          .document(docId)
          .setData(data, merge: true ).then((_){}).catchError((e) {
        print(e);
      });
    } else {
      print("You need to be logged in");
    }
  }

  Future<void> pinData(data, docId) async {
    if (isLoggedin()) {
      Firestore.instance
          .collection('pin')
          .document(docId)
          .setData(data, merge: true ).then((_){}).catchError((e) {
        print(e);
      });
    } else {
      print("You need to be logged in");
    }
  }

  getData() async {
    return Firestore.instance.collection('todos').snapshots();
  }

  getdone() async {
    return Firestore.instance.collection('done').snapshots();
  }

  getPin() async {
    return Firestore.instance.collection('pin').snapshots();
  }

  Future updateList(selectedDoc, newTodo) async{
   await Firestore.instance
        .collection('todos')
        .document(selectedDoc)
        .updateData(newTodo)
        .catchError((e) {
      print(e);
    });
  }

  Future updateDone(selectedDoc, newTodo) async {
    await Firestore.instance
        .collection('done')
        .document(selectedDoc)
        .updateData(newTodo)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(docId) {
    Firestore.instance
        .collection('todos')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  deletePin(docId) {
    Firestore.instance
        .collection('pin')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  deleteDone(docId) {
    Firestore.instance
        .collection('done')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
