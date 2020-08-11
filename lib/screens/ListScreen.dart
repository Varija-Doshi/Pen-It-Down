import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Todo_App2/screens/note_editor.dart';
import 'package:Todo_App2/utils/crud.dart';

class ListScreen extends StatefulWidget {
  final Function signOut;
  ListScreen({this.signOut});
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  Stream notes;
  bool done, pinned;
  String title, content;
  CrudMethods crudobj = CrudMethods();

  void checkbox(bool done, String title, String content, docId) {
    if (done) {
      crudobj
          .doneData(
              {'title': this.title, 'content': this.content, 'done': true},
              docId)
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
                else
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 5.0,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.grey[100],
                      child: Slidable(
                        child: ListTile(
                          leading: IconButton(
                              icon: snapshot.data.documents[i].data['done']
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.red,
                                    ),
                              onPressed: () {
                                done = snapshot.data.documents[i].data['done'];
                                done = !done;
                                crudobj.updateList(
                                    snapshot.data.documents[i].documentID,
                                    {'done': this.done});
                                title =
                                    snapshot.data.documents[i].data['title'];
                                content =
                                    snapshot.data.documents[i].data['content'];
                                var docId =
                                    snapshot.data.documents[i].documentID;
                                checkbox(
                                  this.done,
                                  this.title,
                                  this.content,
                                  docId,
                                );
                              }),
                          title: Text(
                            snapshot.data.documents[i].data['title'],
                            style: TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            snapshot.data.documents[i].data['content'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                                        true)));
                          },
                          //isThreeLine: true,
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
          "No Notes yet",
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
                  IconButton(
                      icon: Icon(
                        Icons.power_settings_new,
                        color: Colors.red,
                        size: 30.0,
                      ),
                      onPressed: widget.signOut),
                  SizedBox(
                    width: 50.0,
                  ),
                  Text(
                    "Todos",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                    ),
                  ),
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
