import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Todo_App2/screens/note_editor.dart';
import 'package:Todo_App2/utils/crud.dart';
import 'sign_in.dart';

class ListScreen1 extends StatefulWidget {
  final Function signOut;
  ListScreen1({this.signOut});
  @override
  _ListScreenState1 createState() => _ListScreenState1();
}

class _ListScreenState1 extends State<ListScreen1> {
  Stream notes;
  bool done, pin, pinned = false;
  String title, content, date, time, uid;
  CrudMethods crudobj = CrudMethods();

  void checkbox(done, uid, title, content, date, time, pin, docId) {
    print("pin $pin");
    if (done) {
      crudobj
          .doneData({
            'title': this.title,
            'content': this.content,
            'pin': pin,
            'done': true,
            'date': date,
            'time': time,
            'uid': uid,
          }, docId)
          .then((value) => null)
          .catchError((e) {
            print(e);
          });
      print("collection done created");
    } else {
      crudobj.deleteDone(docId);
      print("todo should be deleted from the done screen");
    }
  }

  @override
  void initState() {
    crudobj.getData().then((results) {
      setState(() {
        notes = results;
      });
    });
    super.initState();
  }

  Widget _buildList() {
    if (notes != null) {
      return StreamBuilder(
        stream: notes,
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, int i) {
                if (snapshot.data.documents[i] == null)
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          "Please wait Loading",
                          style: TextStyle(color: Colors.black, fontSize: 30.0),
                        ),
                        Icon(
                          MdiIcons.loading,
                          size: 25.0,
                        ),
                      ],
                    ),
                  );
                else {
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 5.0,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: snapshot.data.documents[i].data['pinned']
                          ? Colors.red[200]
                          : Colors.white,
                      child: Slidable(
                        child: GestureDetector(
                          onLongPress: () {
                            title = snapshot.data.documents[i].data['title'];
                            content =
                                snapshot.data.documents[i].data['content'];
                            pinned = snapshot.data.documents[i].data['pinned'];
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
                                        true)));
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
                                          done = snapshot
                                              .data.documents[i].data['done'];
                                          done = !done;
                                          crudobj.updateList(
                                              snapshot
                                                  .data.documents[i].documentID,
                                              {'done': this.done});
                                          title = snapshot
                                              .data.documents[i].data['title'];
                                          uid = snapshot
                                              .data.documents[i].data['uid'];
                                          content = snapshot.data.documents[i]
                                              .data['content'];
                                          pinned = snapshot
                                              .data.documents[i].data['pinned'];
                                          var docId = snapshot
                                              .data.documents[i].documentID;
                                          checkbox(
                                            this.done,
                                            this.uid,
                                            this.title,
                                            this.content,
                                            snapshot
                                                .data.documents[i].data['date'],
                                            snapshot
                                                .data.documents[i].data['time'],
                                            this.pinned,
                                            docId,
                                          );
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
                                Row(
                                  children: <Widget>[
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
                                  ],
                                ),
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
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      snapshot
                                          .data.documents[i].data['content'],
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
                                  height: 5,
                                )
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
                              // delete from the main list
                              crudobj.deleteData(
                                  snapshot.data.documents[i].documentID);
                              // delete from done list if there
                              crudobj.deleteDone(
                                  snapshot.data.documents[i].documentID);
                            },
                          ),
                          IconSlideAction(
                            caption: 'Pin',
                            color: Colors.purple[200],
                            icon: snapshot.data.documents[i].data['pinned']
                                ? MdiIcons.pin
                                : MdiIcons.pinOutline,
                            onTap: () {
                              pinned = !pinned;
                              crudobj.updateList(
                                  snapshot.data.documents[i].documentID,
                                  {'pinned': this.pinned});
                              /*crudobj.doneData(
                                  snapshot.data.documents[i].documentID, {
                                'pin': this.pinned
                              }).then((_) => print("pin data added to done"));*/
                              crudobj.updateDone(
                                  snapshot.data.documents[i].documentID, {
                                'pin': this.pinned
                              }).then((_) =>
                                  print("pin data added to done using func"));
                            },
                          )
                        ],
                      ),
                    ),
                  );
                }
              });
        },
      );
    } else {
      return Center(
        child: Text(
          "Add a New Note",
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
        backgroundColor: Color(0xFF21BFBD),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                   SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      
                      CircleAvatar(
                        backgroundImage: NetworkImage(photoUrl),
                        radius: 25.0,
                      ),
                      Text(displayname , style: TextStyle(fontSize: 19),)
                    ],
                  ),
                  SizedBox(
                    width: 50.0,
                  ),
                  Text(
                    "To-do's",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontFamily: "Lobster",
                      //fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: (MediaQuery.of(context).size.width/6 )+ 20,),
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
                      Text("Logout" ,style: TextStyle(fontSize: 19 , fontWeight: FontWeight.w600)),
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
                height: 60,
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
