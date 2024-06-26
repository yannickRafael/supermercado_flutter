import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/Cliente.dart';
import '../models/Produto.dart';
import '../models/Venda.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'estacionamento.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE clientes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        email TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE produtos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        preco DECIMAL,
        quantidade INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE vendas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clienteId INTEGER,
        produtoId INTEGER,
        quantidade INTEGER,
        total REAL,
        FOREIGN KEY (clienteId) REFERENCES clientes(id),
        FOREIGN KEY (produtoId) REFERENCES produtos(id)
      )
    ''');
  }

  Future<void> createProduto(String nome, int quantidade, double preco) async {
    Database db = await database;
    await db.execute('''
      INSERT INTO produtos(nome, quantidade, preco) VALUES(?, ?, ?)
    ''', [nome, quantidade, preco]);
  }

  Future<void> createCliente(String nome, String email) async {
    Database db = await database;
    await db.execute('''
      INSERT INTO clientes(nome, email) VALUES(?, ?)
    ''', [nome, email]);
  }

  Future<void> createVenda(int clienteId, int produtoId, int quantidade, double total) async {
    Database db = await database;
    await db.execute('''
      INSERT INTO vendas(clienteId, produtoId, quantidade, total) VALUES(?, ?, ?, ?)
    ''', [clienteId, produtoId, quantidade, total]);
  }


  

  Future<int> insertCliente(Cliente cliente) async {
    Database db = await database;
    return await db.insert('clientes', cliente.toMap());
  }

  Future<int> updateCliente(Cliente cliente) async {
    Database db = await database;
    return await db.update('clientes', cliente.toMap(), where: 'id = ?', whereArgs: [cliente.id]);
  }

  Future<int> deleteCliente(int id) async {
    Database db = await database;
    return await db.delete('clientes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Cliente>> getClientes() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('clientes');
    return List.generate(maps.length, (i) {
      return Cliente.fromMap(maps[i]);
    });
  }

  Future<int> insertProduto(Produto produto) async {
    Database db = await database;
    return await db.insert('produtos', produto.toMap());
  }

  Future<int> updateProduto(Produto produto) async {
    Database db = await database;
    return await db.update('produtos', produto.toMap(), where: 'id = ?', whereArgs: [produto.id]);
  }

  Future<int> deleteProduto(int id) async {
    Database db = await database;
    return await db.delete('produtos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Produto>> getProdutos() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('produtos');
    return List.generate(maps.length, (i) {
      return Produto.fromMap(maps[i]);
    });
  }

  Future<int> insertVenda(Venda venda) async {
    Database db = await database;
    return await db.insert('vendas', venda.toMap());
  }

  Future<List<Venda>> getVendas() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('vendas');
    return List.generate(maps.length, (i) {
      return Venda.fromMap(maps[i]);
    });
  }

  Future<int> deleteVenda(int id) async {
    Database db = await database;
    return await db.delete('vendas', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Venda>> getVendasByCliente(int clienteId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'vendas',
      where: 'clienteId = ?',
      whereArgs: [clienteId],
    );

    return List.generate(maps.length, (i) {
      return Venda.fromMap(maps[i]);
    });
  }

  Future<List<Produto>> getProdutosMaisVendidos() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT p.*, SUM(v.quantidade) as quantidade_vendida  FROM produtos p
    JOIN vendas v
    ON p.id = v.produtoId
    GROUP BY p.id
    ORDER BY SUM(v.quantidade) DESC
  ''');

  return List.generate(maps.length, (i) {
    print(maps[i]);
    return Produto.fromMapQtdVendida(maps[i]);
  });
}

}
