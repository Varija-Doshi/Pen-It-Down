import 'package:flutter/material.dart';


// build circular avatar of logged in
  Widget _buildAvatar(BuildContext context) {
    final url = Provider.of<CurrentUser>(context)?.data?.photoUrl;
    return CircleAvatar(
      backgroundImage: url != null ? NetworkImage(url) : null,
      child: url == null ? const Icon(Icons.face) : null,
      radius: 17,
    );
  }

//
new BottomAppBar(
        notchMargin: 5.0,
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new IconButton(
                icon: Icon(
                  MdiIcons.pin,
                ),
                onPressed: () {}),
            new IconButton(
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                onPressed: () {
                   Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>DoneScreen(signOut: widget.signOut)));
                }),
          ],
        ),
      ),





      //

      ListView(
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
                  width: 25.0,
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
            height: MediaQuery.of(context).size.height - 160.0,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(75.0),
                  topRight: Radius.circular(75.0),
                )),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 35.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: screens[_selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),