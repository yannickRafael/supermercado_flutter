class Produto {
  int id;
  String nome;
  int quantidade;
  double preco;

  Produto({required this.id, required this.nome, required this.quantidade, required this.preco});

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
      preco: map['preco'],
      quantidade: map['quantidade'],
    );
  }
}
