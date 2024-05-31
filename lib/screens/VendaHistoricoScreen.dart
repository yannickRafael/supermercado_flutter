import 'package:flutter/material.dart';
import '../database/DatabaseHelper.dart';
import '../models/Venda.dart';
import '../models/Produto.dart';
import '../models/Cliente.dart';

class VendaHistoricoScreen extends StatefulWidget {
  final Cliente cliente;

  VendaHistoricoScreen({required this.cliente});

  @override
  _VendaHistoricoScreenState createState() => _VendaHistoricoScreenState();
}

class _VendaHistoricoScreenState extends State<VendaHistoricoScreen> {
  final dbHelper = DatabaseHelper();
  List<Venda> vendas = [];
  List<Produto> produtos = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    List<Venda> listVendas = await dbHelper.getVendasByCliente(widget.cliente.id);
    List<Produto> listProdutos = await dbHelper.getProdutos();
    setState(() {
      vendas = listVendas;
      produtos = listProdutos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Compras de ${widget.cliente.nome}'),
      ),
      body: ListView.builder(
        itemCount: vendas.length,
        itemBuilder: (context, index) {
          Produto produto = produtos.firstWhere((p) => p.id == vendas[index].produtoId);
          return ListTile(
            title: Text('Produto: ${produto.nome}'),
            subtitle: Text('Quantidade: ${vendas[index].quantidade}, Total: ${vendas[index].total}'),
          );
        },
      ),
    );
  }
}
