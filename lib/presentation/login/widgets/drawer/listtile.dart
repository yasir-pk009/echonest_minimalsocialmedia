import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final Widget icon;
  final String text;
  final Function()? ontap;
  

  const DrawerListTile({
    super.key,
    required this.icon,
    required this.text, required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19,color: Colors.white),
      ),
      onTap: ontap,
    );
  }
}
