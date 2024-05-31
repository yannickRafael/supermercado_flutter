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
  final _formKey = GlobalKey<FormState>();
  String? _nome;
  int? _quantidade;
  int? _editingProdutoId;
  double? _preco;

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

  _submitForm() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    if (_editingProdutoId == null) {
      try {
          await dbHelper.insertProduto(Produto(preco: _preco!,nome: _nome!, quantidade: _quantidade!));
        } catch (e) {
          print('Erro ao inserir produto: $e');
          // Ou exibir uma mensagem de erro para o usuário
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Erro'),
              content: Text('$e'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }

    } else {
      await dbHelper.updateProduto(Produto(preco: _preco!,id: _editingProdutoId!, nome: _nome!, quantidade: _quantidade!));
      _editingProdutoId = null;
    }
    _fetchProdutos();
    _formKey.currentState!.reset();
  }
}


  _editProduto(Produto produto) {
    setState(() {
      _editingProdutoId = produto.id;
      _nome = produto.nome;
      _quantidade = produto.quantidade;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
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
                    initialValue: _quantidade?.toString(),
                    decoration: InputDecoration(labelText: 'Quantidade'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a quantidade';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _quantidade = int.tryParse(value!);
                    },
                  ),
                  TextFormField(
                    initialValue: _preco?.toString(),
                    decoration: InputDecoration(labelText: 'Preço'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o preço';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _preco = double.tryParse(value!);
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(_editingProdutoId == null ? 'Adicionar Produto' : 'Atualizar Produto'),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(produtos[index].nome),
                  subtitle: Text('Quantidade: ${produtos[index].quantidade} | Preço : ${produtos[index].preco}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editProduto(produtos[index]),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await dbHelper.deleteProduto(produtos[index].id);
                          _fetchProdutos();
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
