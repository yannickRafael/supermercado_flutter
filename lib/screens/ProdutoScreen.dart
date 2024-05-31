import 'package:flutter/material.dart';
import '../database/DatabaseHelper.dart';
import '../models/Produto.dart';

class ProdutoScreen extends StatefulWidget {
  @override
  _ProdutoScreenState createState() => _ProdutoScreenState();
}

class _ProdutoScreenState extends State<ProdutoScreen> {
  final dbHelper = DatabaseHelper();
  List<Produto> produtos = [];

  @override
  void initState() {
    super.initState();
    _fetchProdutos();
  }

  _fetchProdutos() async {
    List<Produto> list = await dbHelper.getProdutos();
    setState(() {
      produtos = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
      ),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(produtos[index].nome),
            subtitle: Text('Quantidade: ${produtos[index].quantidade}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await dbHelper.deleteProduto(produtos[index].id);
                _fetchProdutos();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Código para adicionar novo produto
        },
      ),
    );
  }
}
