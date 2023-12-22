import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final Function() onTap;
   const LikeButton({super.key, required this.onTap,  this.isLiked = false});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon:  Icon(isLiked ? Icons.favorite: Icons.favorite_border,
      color:  isLiked ? Colors.red: Colors.black,
        
      ),
    );
  }
}
