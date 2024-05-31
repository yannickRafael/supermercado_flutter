import 'package:flutter/material.dart';
import '../database/DatabaseHelper.dart';
import '../models/Cliente.dart';

class ClienteScreen extends StatefulWidget {
  @override
  _ClienteScreenState createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final dbHelper = DatabaseHelper();
  List<Cliente> clientes = [];

  @override
  void initState() {
    super.initState();
    _fetchClientes();
  }

  _fetchClientes() async {
    List<Cliente> list = await dbHelper.getClientes();
    setState(() {
      clientes = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
      ),
      body: ListView.builder(
        itemCount: clientes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(clientes[index].nome),
            subtitle: Text(clientes[index].email),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await dbHelper.deleteCliente(clientes[index].id);
                _fetchClientes();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Código para adicionar novo cliente
        },
      ),
    );
  }
}
