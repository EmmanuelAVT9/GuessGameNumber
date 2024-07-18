// widgets/hamburger_menu.dart
import 'package:flutter/material.dart';

class HamburgerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menú'),
            decoration: BoxDecoration(
              color: Colors.deepOrangeAccent,
            ),
          ),
          ListTile(
            title: Text('Perfil'),
            onTap: () {
              // Navegar a la vista de notas
            },
          ),
          ListTile(
            title: Text('Mejores Puntuaciones'),
            onTap: () {
              // Navegar a la vista de notas
            },
          ),
          ListTile(
            title: Text('Desafios semanales'),
            onTap: () {
              // Navegar a la vista de notas
            },
          ),
          ListTile(
            title: Text('Logros y Recompensas'),
            onTap: () {
              // Navegar a la vista de carpetas
            },
          ),
          ListTile(
            title: Text('Configuración'),
            onTap: () {
              // Navegar a la vista de carpetas
            },
          ),
        ],
      ),
    );
  }
}
