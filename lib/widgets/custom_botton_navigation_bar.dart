// widgets/reusable_button.dart
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Colors.black, // Fondo negro
      selectedItemColor: Colors.lime, // Iconos en verde limón
      unselectedItemColor: Colors.lime,
      //elevation: 8.0, // Ajusta la altura aquí
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.file_copy),
          label: 'File',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Add Plus',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Star',
        ),
      ],
    );
  }
}