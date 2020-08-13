import 'package:Todo_App2/utils/crud.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NoteEditor extends StatefulWidget {
  final bool update, oldpin;
  final selectedDoc;
  final String oldtitle, oldcontent;
  NoteEditor(this.update, this.selectedDoc, this.oldtitle, this.oldcontent,
      this.oldpin);
  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final _titleTextController = new TextEditingController();
  final _contentTextController = new TextEditingController();
  bool pinned = false;

  String title, content, newtitle, newcontent;
  CrudMethods crudobj = new CrudMethods();

  void addPin(
    bool pin,
    String title,
    String content,
  ) {
    if (pin)
      crudobj.pinData(
          {'title': this.title, 'content': this.content, 'pin': true},
          widget.selectedDoc);
    else
      crudobj.deletePin(widget.selectedDoc);
  }

  Widget _buildNoteDetail() {
    if (widget.update == false) {
      _titleTextController.text = "";
      _contentTextController.text = "";
    } else {
      _titleTextController.text = widget.oldtitle;
      _contentTextController.text = widget.oldcontent;
      newtitle = widget.oldtitle;
      newcontent = widget.oldcontent;
      pinned = widget.oldpin;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _titleTextController,
            autofocus: true,
            onChanged: (value) {
              if (widget.update == false)
                this.title = value;
              else
                this.newtitle = value;
            },
            onEditingComplete: () {},
            decoration: const InputDecoration(
              hintText: 'Title',
              hintStyle: TextStyle(fontSize: 25),
              border: InputBorder.none,
              counter: const SizedBox(),
            ),
            maxLength: 1024,
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
          ),
          TextField(
            autofocus: true,
            controller: _contentTextController,
            decoration: const InputDecoration.collapsed(
              hintText: 'Note.....',
              hintStyle: TextStyle(fontSize: 20),
            ),
            maxLines: null,
            onChanged: (value) {
              if (!widget.update)
                this.content = value;
              else
                this.newcontent = value;
            },
            onEditingComplete: () {
              setState(() {});
            },
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
                if (!widget.update)
                  crudobj
                      .addData({
                        'title': this.title,
                        'content': this.content,
                        'pinned': this.pinned,
                        'done': false,
                      })
                      .then((value) => null)
                      .catchError((e) {
                        print(e);
                      });
                else {
                  crudobj.updateDone(widget.selectedDoc, {
                    'title': this.newtitle,
                    'content': this.newcontent
                  }).then((_) {
                    print("updated done");
                  }).catchError((e) {
                    print(e);
                  });
                  crudobj.updateList(widget.selectedDoc, {
                    'title': this.newtitle,
                    'content': this.newcontent,
                    'pinned': this.pinned
                  }).then((_) {
                    print("list updated");
                  }).catchError((e) {
                    print(e);
                  });
                }
              }),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.yellow[200],
        height: double.infinity, //MediaQuery.of(context).size.height ,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _buildNoteDetail(),
      ),
    );
  }
}
