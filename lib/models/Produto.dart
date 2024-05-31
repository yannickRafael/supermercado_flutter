class Produto {
  int id;
  String nome;
  int quantidade;
  int quantidade_vendida;
  double preco;

  Produto({required this.id, required this.nome, required this.quantidade, required this.preco, this.quantidade_vendida = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'quantidade': quantidade,
      'preco': preco
    };
  }

  static Produto fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      preco: map['preco'] is int ? map['preco'].toDouble() : map['preco'],
      quantidade: map['quantidade'],
    );
  }

  static Produto fromMapQtdVendida(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      preco: map['preco'] is int ? map['preco'].toDouble() : map['preco'],
      quantidade: map['quantidade'],
      quantidade_vendida: map['quantidade_vendida']
    );
  }
}
