import 'package:echonest/presentation/colors/contantColors.dart';
import 'package:echonest/presentation/login/widgets/drawer/listtile.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final Function()? signOut;
  final Function()? goToProfile;

  final Function()? goTochatPage;
  const DrawerWidget({
    super.key,
    required this.signOut,
    required this.goToProfile, required this.goTochatPage,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: loginPagetextcolor,
      child: Column(
        children: [
          const DrawerHeader(
            child: Center(
              child: Icon(
                Icons.person,
                size: 70,
                color: drawerIcon,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DrawerListTile(
                icon: const Icon(Icons.home, color: drawerIcon),
                text: "H O M E",
                ontap: () => Navigator.of(context).pop(),
              ),
              DrawerListTile(
                icon: const Icon(Icons.person, color: drawerIcon),
                text: "P R O F I L E",
                ontap: goToProfile,
              ),
              DrawerListTile(
                icon: const Icon(Icons.contact_page, color: drawerIcon),
                text: "C O N T A C T S",
                ontap: goTochatPage,
              ),
            ],
          ),
          Expanded(child: Container()), 
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DrawerListTile(
              icon: const Icon(Icons.logout, color: drawerIcon),
              text: "S I G N O U T",
              ontap: signOut,
            ),
          ),
        ],
      ),
    );
  }
}
