import 'package:flutter/material.dart';
import '../screens/ClienteScreen.dart'; // Import your other screens here
import '../screens/ProdutoScreen.dart';
import '../screens/VendaScreen.dart';
import '../screens/RelatorioScreen.dart';
import '../widgets/CustomDrawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistema de Gestão do Parque de Estacionamento'),
      ),
      drawer: CustomDrawer(),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          _buildMenuItem(context, 'Cliente', ClienteScreen()),
          _buildMenuItem(context, 'Produto', ProdutoScreen()),
          _buildMenuItem(context, 'Venda', VendaScreen()),
          _buildMenuItem(context, 'Relatório', RelatorioScreen()),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Card(
        margin: EdgeInsets.all(20),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
