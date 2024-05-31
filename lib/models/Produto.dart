class Produto {
  int id;
  String nome;
  int quantidade;

  Produto({required this.id, required this.nome, required this.quantidade});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'quantidade': quantidade,
    };
  }

  static Produto fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      quantidade: map['quantidade'],
    );
  }
}
