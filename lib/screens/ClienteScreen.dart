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
  final _formKey = GlobalKey<FormState>();
  String? _nome;
  String? _email;
  int? _editingClienteId;

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

  _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_editingClienteId == null) {
        await dbHelper.insertCliente(Cliente(nome: _nome!, email: _email!));
      } else {
        await dbHelper.updateCliente(Cliente(id: _editingClienteId!, nome: _nome!, email: _email!));
        _editingClienteId = null;
      }
      _fetchClientes();
      _formKey.currentState!.reset();
    }
  }

  _editCliente(Cliente cliente) {
    setState(() {
      _editingClienteId = cliente.id;
      _nome = cliente.nome;
      _email = cliente.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _nome,
                    decoration: InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _nome = value;
                    },
                  ),
                  TextFormField(
                    initialValue: _email,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(_editingClienteId == null ? 'Adicionar Cliente' : 'Atualizar Cliente'),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(clientes[index].nome),
                  subtitle: Text(clientes[index].email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editCliente(clientes[index]),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await dbHelper.deleteCliente(clientes[index].id);
                          _fetchClientes();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
