import 'package:flutter/material.dart';
import '../screens/ClienteScreen.dart';
import '../screens/ProdutoScreen.dart';
import '../screens/VendaScreen.dart';
import '../screens/RelatorioScreen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Clientes'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ClienteScreen()));
            },
          ),
          ListTile(
            title: Text('Produtos'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProdutoScreen()));
            },
          ),
          ListTile(
            title: Text('Vendas'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VendaScreen()));
            },
          ),
          ListTile(
            title: Text('Relatórios'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RelatorioScreen()));
            },
          ),
        ],
      ),
    );
  }
}
