import 'package:flutter/material.dart';
import '../database/DatabaseHelper.dart';
import '../models/Produto.dart';
import '../models/Venda.dart';

class RelatorioScreen extends StatefulWidget {
  @override
  _RelatorioScreenState createState() => _RelatorioScreenState();
}

class _RelatorioScreenState extends State<RelatorioScreen> {
  final dbHelper = DatabaseHelper();
  List<Produto> produtosAbaixoDoEstoque = [];
  List<Produto> produtosMaisVendidos = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    List<Produto> listProdutos = await dbHelper.getProdutos();
    List<Venda> listVendas = await dbHelper.getVendas();
    setState(() {
      produtosAbaixoDoEstoque = listProdutos.where((p) => p.quantidade < 5).toList();
      produtosMaisVendidos = _getProdutosMaisVendidos(listProdutos, listVendas);
    });
  }

  List<Produto> _getProdutosMaisVendidos(List<Produto> produtos, List<Venda> vendas) {
    Map<int, int> vendaCount = {};
    for (var venda in vendas) {
      if (vendaCount.containsKey(venda.produtoId)) {
        vendaCount[venda.produtoId] = vendaCount[venda.produtoId]! + venda.quantidade;
      } else {
        vendaCount[venda.produtoId] = venda.quantidade;
      }
    }
    List<Produto> sortedProdutos = produtos;
    sortedProdutos.sort((a, b) => (vendaCount[b.id] ?? 0).compareTo(vendaCount[a.id] ?? 0));
    return sortedProdutos.take(5).toList(); // Pegando os 5 produtos mais vendidos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: produtosAbaixoDoEstoque.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(produtosAbaixoDoEstoque[index].nome),
                  subtitle: Text('Quantidade: ${produtosAbaixoDoEstoque[index].quantidade}'),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: produtosMaisVendidos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(produtosMaisVendidos[index].nome),
                  subtitle: Text('Quantidade vendida: ${produtosMaisVendidos[index].quantidade}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
