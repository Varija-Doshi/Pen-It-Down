import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Todo_App2/screens/note_editor.dart';
import 'package:Todo_App2/screens/doneScreen.dart';
import 'package:Todo_App2/screens/ListScreen1.dart';



class Todo {
  String title;
  String content;

  Todo(this.title, this.content);
}

class TodoScreen extends StatefulWidget {
  final Function signOut;
  TodoScreen({this.signOut});
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Widget> screens ;
  int _selectedIndex = 0;


  void _handleAdd() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NoteEditor(false, null, "", "", "Not set","Not set",false)));
  }

  
  void _handleSelect(int i) {
   
    if (i == 1) _handleAdd();
    
  }

  @override
  void initState() {

    screens = [ListScreen1(signOut : widget.signOut),ListScreen1(signOut : widget.signOut),  DoneScreen(signOut : widget.signOut)];
    super.initState();
  }
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          backgroundColor: Colors.white70,
          height: 50.0,
          animationDuration: Duration(milliseconds: 200),
          //animationcurve to give animations on button switch
          buttonBackgroundColor: Color(0xFF21BFBD),
          items: <Widget>[
            Icon(Icons.list, color: Colors.black, size: 30),
            Icon(Icons.add, color: Colors.black, size: 30),
            //Icon(MdiIcons.pin, color: Colors.black, size: 30),
            Icon(Icons.check_circle, color: Colors.black, size: 30),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            _handleSelect(index);
          }),
      body: screens[_selectedIndex],
    );
  }
}
