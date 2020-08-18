import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Todo_App2/screens/note_editor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Todo_App2/utils/crud.dart';
import 'sign_in.dart';

class DoneScreen extends StatefulWidget {
  final Function signOut;
  DoneScreen({this.signOut});
  @override
  _DoneScreenState createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  Stream done;
  bool checkdone, pin;
  CrudMethods crudobj = CrudMethods();
  String title, content;

  @override
  void initState() {
    crudobj.getdone().then((results) {
      setState(() {
        done = results;
      });
    });
    super.initState();
  }

  void deleteNotes(docId) async {
    Firestore.instance.collection("todos").document(docId).get().then((value) {
      DocumentSnapshot notesSnapshot = value;
      crudobj.deleteData(notesSnapshot.documentID);
    });
    print("delete linked");
  }

  Widget _buildList() {
    if (done.isEmpty !=null) {
      return StreamBuilder(
        stream: done,
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, int i) {
                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 5.0,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: snapshot.data.documents[i].data['pin']
                        ? Colors.red[200]
                        : Colors.white,
                    child: Slidable(
                      child: GestureDetector(
                        onLongPress: () {
                          title = snapshot.data.documents[i].data['title'];
                          content = snapshot.data.documents[i].data['content'];
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NoteEditor(
                                      true,
                                      snapshot.data.documents[i].documentID,
                                      title,
                                      content,
                                      snapshot.data.documents[i].data['date'],
                                    snapshot.data.documents[i].data['time'],
                                      false)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                      icon: snapshot
                                              .data.documents[i].data['done']
                                          ? Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            )
                                          : Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.red,
                                            ),
                                      onPressed: () {
                                        checkdone = snapshot
                                            .data.documents[i].data['done'];
                                        checkdone = !checkdone;
                                        crudobj.updateList(
                                            snapshot
                                                .data.documents[i].documentID,
                                            {'done': this.checkdone});
                                        if (checkdone == false) {
                                          crudobj.deleteDone(snapshot
                                              .data.documents[i].documentID);
                                          print(
                                              "done changed to false so must delete");
                                        }
                                      }),
                                  Text(
                                    snapshot.data.documents[i].data['title'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: "Title",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.purple,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                 snapshot.data.documents[i].data['date'],
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 16,
                                    fontFamily: "Body",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.timer,
                                    color: Colors.purple,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    snapshot.data.documents[i].data['time'],
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16,
                                      fontFamily: "Body",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  snapshot.data.documents[i].data['content'],
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Body"),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                      actionPane: SlidableDrawerActionPane(),
                      closeOnScroll: true,
                      actionExtentRatio: 0.25,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
                            crudobj.deleteDone(
                                snapshot.data.documents[i].documentID);
                            var docId = snapshot.data.documents[i].documentID;
                            deleteNotes(docId);
                          },
                        ),
                        IconSlideAction(
                          caption: 'Pin',
                          color: Colors.purple[200],
                          icon: snapshot.data.documents[i].data['pin']
                              ? MdiIcons.pin
                              : MdiIcons.pinOutline,
                          onTap: () {
                            pin = snapshot.data.documents[i].data['pin'];
                            pin = !pin;
                            print("pin in done screen = $pin");
                            crudobj.updateList(
                                snapshot.data.documents[i].documentID,
                                {'pinned': this.pin}).then((_) {
                              print("done screen to list screen update");
                            });
                            crudobj.updateDone(
                                snapshot.data.documents[i].documentID,
                                {'pin': pin}).then((_) {
                              print("done screen to done screen update");
                            });
                          },
                        )
                      ],
                    ),
                  ),
                );
              });
        },
      );
    } else {
      return Center(
        child: Text(
          "Nothing Completed Yet!",
          style: TextStyle(color: Colors.red[800], fontSize: 30),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF111D5E),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(photoUrl),
                        radius: 25.0,
                      ),
                      Text(displayname , style: TextStyle(fontSize: 19 , color: Colors.white),)
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/6-10,
                  ),
                  Text(
                    "Done !!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontFamily: "Lobster",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width:  MediaQuery.of(context).size.width/4 -10,
                  ),
                   Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                      icon: Icon(
                        MdiIcons.login,
                        color: Colors.red,
                        size: 40.0,
                      ),
                      onPressed: () {
                        widget.signOut();
                        Navigator.pop(context);
                      }),
                      Text("Logout" ,style: TextStyle(fontSize: 19 , fontWeight: FontWeight.w600 , color: Colors.white)),
                      ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 55,
              decoration: BoxDecoration(
                  color: Color(0xFFDDF3F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(55.0),
                    topRight: Radius.circular(55.0),
                  )),
              child: SizedBox(
                height: 55,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 50,
              color: Color(0xFFDDF3F5),
              child: ListView(
                primary: false,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: _buildList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
