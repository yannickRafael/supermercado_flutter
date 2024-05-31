import 'package:flutter/material.dart';
import '../database/DatabaseHelper.dart';
import '../models/Venda.dart';
import '../models/Produto.dart';
import '../models/Cliente.dart';

class VendaScreen extends StatefulWidget {
  @override
  _VendaScreenState createState() => _VendaScreenState();
}

class _VendaScreenState extends State<VendaScreen> {
  final dbHelper = DatabaseHelper();
  List<Venda> vendas = [];
  List<Produto> produtos = [];
  List<Cliente> clientes = [];
  final _formKey = GlobalKey<FormState>();
  int? _clienteId;
  int? _produtoId;
  int? _quantidade;
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    List<Venda> listVendas = await dbHelper.getVendas();
    List<Produto> listProdutos = await dbHelper.getProdutos();
    List<Cliente> listClientes = await dbHelper.getClientes();
    setState(() {
      vendas = listVendas;
      produtos = listProdutos;
      clientes = listClientes;
    });
  }

  _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Produto produto = produtos.firstWhere((p) => p.id == _produtoId);
      if (_quantidade! <= produto.quantidade) {
        setState(() {
          _total = _quantidade! * 10; // Supondo um valor fixo de 10 por produto
        });
        await dbHelper.insertVenda(Venda(clienteId: _clienteId!, produtoId: _produtoId!, quantidade: _quantidade!, total: _total));
        produto.quantidade -= _quantidade!;
        await dbHelper.updateProduto(produto);
        _fetchData();
        _formKey.currentState!.reset();
      } else {
        // Mostrar mensagem de erro caso a quantidade seja maior do que a disponível
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quantidade insuficiente em estoque')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<int>(
                    value: _clienteId,
                    hint: Text('Selecionar Cliente'),
                    items: clientes.map((cliente) {
                      return DropdownMenuItem<int>(
                        value: cliente.id,
                        child: Text(cliente.nome),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _clienteId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecione um cliente';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<int>(
                    value: _produtoId,
                    hint: Text('Selecionar Produto'),
                    items: produtos.map((produto) {
                      return DropdownMenuItem<int>(
                        value: produto.id,
                        child: Text(produto.nome),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _produtoId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecione um produto';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Quantidade'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a quantidade';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Por favor, insira um número válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _quantidade = int.tryParse(value!);
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Registrar Venda'),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vendas.length,
              itemBuilder: (context, index) {
                Cliente cliente = clientes.firstWhere((c) => c.id == vendas[index].clienteId);
                Produto produto = produtos.firstWhere((p) => p.id == vendas[index].produtoId);
                return ListTile(
                  title: Text('Venda para ${cliente.nome}'),
                  subtitle: Text('Produto: ${produto.nome}, Quantidade: ${vendas[index].quantidade}, Total: ${vendas[index].total}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await dbHelper.deleteVenda(vendas[index].id);
                      _fetchData();
                    },
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
