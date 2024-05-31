class Produto {
  int id;
  double preco;
  String nome;
  int quantidade;

  Produto({this.id=0,required this.preco, required this.nome, required this.quantidade});

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'quantidade': quantidade,
      'preco': preco
    };
  }

  static Produto fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      preco: map['preco'],
      nome: map['nome'],
      quantidade: map['quantidade'],
    );
  }
}
