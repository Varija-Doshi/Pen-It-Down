import 'package:Todo_App2/utils/crud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:Todo_App2/screens/sign_in.dart';

class NoteEditor extends StatefulWidget {
  final bool update, oldpin;
  final selectedDoc;
  final String oldtitle, oldcontent, olddate, oldtime;
  NoteEditor(this.update, this.selectedDoc, this.oldtitle, this.oldcontent,
      this.olddate, this.oldtime, this.oldpin);
  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final _titleTextController = new TextEditingController();
  final _contentTextController = new TextEditingController();
  bool pinned = false;
  String _date = 'Not set', _time = "Not set";
  String title, content, newtitle, newcontent;
  CrudMethods crudobj = new CrudMethods();
  FocusNode titleField = FocusNode();
  FocusNode contentField = FocusNode();
  String uid = userid;


   

  @override
  void initState() {
    super.initState();
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
      _date = widget.olddate;
      _time = widget.oldtime;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () async {
              DatePicker.showDatePicker(context,
                  theme: DatePickerTheme(
                    containerHeight: 210.0,
                  ),
                  showTitleActions: true,
                  minTime: DateTime(2000, 1, 1),
                  maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                print('confirm $date');
                _date = '${date.year} - ${date.month} - ${date.day}';
                setState(() {});
                crudobj.updateList(widget.selectedDoc, {'date': this._date});
                crudobj.updateDone(widget.selectedDoc, {'date': this._date});
              }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 4.0,
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              size: 18.0,
                              color: Colors.teal,
                            ),
                            Text(
                              " $_date",
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(
                    "  Change",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ],
              ),
            ),
            color: Colors.white,
          ),
          SizedBox(
            height: 10.0,
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 4.0,
            onPressed: () {
              DatePicker.showTimePicker(context,
                  theme: DatePickerTheme(
                    containerHeight: 210.0,
                  ),
                  showTitleActions: true, onConfirm: (time) {
                print('confirm $time');
                _time = '${time.hour} : ${time.minute} : ${time.second}';
                setState(() {});
              }, currentTime: DateTime.now(), locale: LocaleType.en);
              setState(() {});
              crudobj.updateList(widget.selectedDoc, {'time': this._time});
              crudobj.updateDone(widget.selectedDoc, {'time': this._time});
            },
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.access_time,
                              size: 18.0,
                              color: Colors.teal,
                            ),
                            Text(
                              " $_time",
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(
                    "  Change",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ],
              ),
            ),
            color: Colors.white,
          ),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            focusNode: titleField,
            controller: _titleTextController,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              if (widget.update == false)
                this.title = value;
              else
                this.newtitle = value;
            },
            decoration: const InputDecoration(
              hintText: 'Title',
              hintStyle: TextStyle(fontSize: 25),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              //counter: const SizedBox(),
            ),
            maxLength: 1024,
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
          ),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            focusNode: contentField,
            textInputAction: TextInputAction.newline,
            //autofocus: true,
            controller: _contentTextController,
            decoration: const InputDecoration(
              hintText: 'Note.....',
              hintStyle: TextStyle(fontSize: 20),
              /*enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide:BorderSide(color: Colors.black, width: 2),
              ),*/
              //counter: const SizedBox(),
            ),
            maxLines: null,
            onChanged: (value) {
              if (!widget.update)
                this.content = value;
              else
                this.newcontent = value;
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
                        'date': _date,
                        'time': _time,
                        'uid':this.uid
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
