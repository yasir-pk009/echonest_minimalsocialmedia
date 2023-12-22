import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {
  final void Function()? ontap;
  final String imagePath;
  const ImageTile({super.key,  required this.imagePath,required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
           width: 50,  // Set a fixed width for testing
        height: 50, 
        
                    decoration:  BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(imagePath), fit: BoxFit.cover,)),
                  ),
    );
  }
}