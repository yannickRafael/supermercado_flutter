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
  String selectedReport = 'Abaixo do Estoque';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState?.openDrawer();
    });
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
    List<Produto> sortedProdutos = List.from(produtos);
    sortedProdutos.sort((a, b) => (vendaCount[b.id] ?? 0).compareTo(vendaCount[a.id] ?? 0));
    return sortedProdutos.take(5).toList(); // Pegando os 5 produtos mais vendidos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Relatórios'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Relatórios',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Produtos Abaixo do Estoque'),
              onTap: () {
                setState(() {
                  selectedReport = 'Abaixo do Estoque';
                  Navigator.pop(context); // close the drawer
                });
              },
            ),
            ListTile(
              title: Text('Produtos Mais Vendidos'),
              onTap: () {
                setState(() {
                  selectedReport = 'Mais Vendidos';
                  Navigator.pop(context); // close the drawer
                });
              },
            ),
          ],
        ),
      ),
      body: selectedReport == 'Abaixo do Estoque' ? _buildProdutosAbaixoDoEstoque() : _buildProdutosMaisVendidos(),
    );
  }

  Widget _buildProdutosAbaixoDoEstoque() {
    return ListView.builder(
      itemCount: produtosAbaixoDoEstoque.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(produtosAbaixoDoEstoque[index].nome),
          subtitle: Text('Quantidade: ${produtosAbaixoDoEstoque[index].quantidade}'),
        );
      },
    );
  }

  Widget _buildProdutosMaisVendidos() {
    return ListView.builder(
      itemCount: produtosMaisVendidos.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(produtosMaisVendidos[index].nome),
          subtitle: Text('Quantidade vendida: ${produtosMaisVendidos[index].quantidade}'),
        );
      },
    );
  }
}
