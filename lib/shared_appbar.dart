import 'package:flutter/material.dart';

PreferredSizeWidget buildNotestashAppBar({
  required String title,
  required IconData actionIcon,
  required VoidCallback onActionTap,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(65),
    child: AppBar(
      backgroundColor: Colors.grey,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: onActionTap,
            icon: Icon(actionIcon, color: Colors.white),
          ),
        ],
      ),
    ),
  );
}
