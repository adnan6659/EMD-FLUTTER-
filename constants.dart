// constants.dart
import 'package:flutter/material.dart';
//import 'package:logger/logger.dart';
import 'drawerbutton/drawerbuttons.dart'; // Importing drawerbuttons.dart
//import 'lic_exp_reminder.dart';
//import 'usersettingpage.dart';



// App Bar Constants
const Color myAppBarBackgroundColor = Color(0xFF006FFD);
const Text myAppBarTitle = Text(
  'Document Management System',
  overflow: TextOverflow.visible,
  style: TextStyle(
    color: Colors.white,
    fontSize: 18.0,
    fontWeight: FontWeight.w300,
  ),
);
final Builder myAppBarLeading = Builder(
  builder: (BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        final ScaffoldState scaffoldState = Scaffold.of(context);

        if (scaffoldState.isDrawerOpen) {
          scaffoldState.openEndDrawer();
        } else {
          scaffoldState.openDrawer();
        }
      },
    );
  },
);
final List<Widget> myAppBarActions = [
  const SizedBox(width: 5.0),
  //const CustomDropdownButton(),
];

final AppBar myAppBar = AppBar(
  backgroundColor: myAppBarBackgroundColor,
  title: myAppBarTitle,
  leading: myAppBarLeading,
  actions: myAppBarActions,
);


// Drawer Constants
final Drawer myDrawer = Drawer(
  child: Container(
    color: const Color(0xFFE9ECEF),
    child: Column(
      children: [
        Container(
          child: myAppBar,
        ),
        const SizedBox(
          height: 15,
        ),
        // Using DrawerButtons widget here
        const DrawerButtons(),
      ],
    ),
  ),
);