class Venda {
  int id;
  int clienteId;
  int produtoId;
  int quantidade;
  double total;

  Venda({this.id=0, required this.clienteId, required this.produtoId, required this.quantidade, required this.total});

  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'produtoId': produtoId,
      'quantidade': quantidade,
      'total': total,
    };
  }

  static Venda fromMap(Map<String, dynamic> map) {
    return Venda(
      id: map['id'],
      clienteId: map['clienteId'],
      produtoId: map['produtoId'],
      quantidade: map['quantidade'],
      total: map['total'],
    );
  }
}
