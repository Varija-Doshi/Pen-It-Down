import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Todo_App2/screens/sign_in.dart';
import 'package:Todo_App2/utils/userModel.dart';

class CrudMethods {
  //UserModel currentUser;
  String uid = userid;

  bool isLoggedin() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else
      return false;
  }

  getuid() async {
    var user = await FirebaseAuth.instance.currentUser();
    print("firebase user" + user.uid);
    //print("get uid " + uid);
  }

  Future<void> addData(todo) async {
    getuid();
    if (isLoggedin()) {
      Firestore.instance.collection("todos").add(todo).then((_) {
        // print(uid);
      }).catchError((e) {
        print(e);
      });
    } else {
      print("You need to be logged in");
    }
  }

  Future<void> doneData(data, docId) async {
    //var firebaseUser = await FirebaseAuth.instance.currentUser();
    if (isLoggedin()) {
      Firestore.instance
          .collection('done')
          .document(docId)
          .setData(data, merge: true)
          .then((_) {})
          .catchError((e) {
        print(e);
      });
    } else {
      print("You need to be logged in");
    }
  }

  getData() async {
    return Firestore.instance
        .collection('todos')
        .where('uid', isEqualTo: uid)
        .orderBy('pinned', descending: true)
        .snapshots();
  }

  getdone() async {
    return Firestore.instance
        .collection('done').where('uid', isEqualTo: uid)
        .orderBy('pin', descending: true)
        .snapshots();
  }


  Future updateList(selectedDoc, newTodo) async {
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
