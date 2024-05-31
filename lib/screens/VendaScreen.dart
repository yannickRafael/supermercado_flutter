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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendas'),
      ),
      body: ListView.builder(
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
                // Código para deletar venda
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Código para adicionar nova venda
        },
      ),
    );
  }
}
