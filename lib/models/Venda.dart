class Venda {
  int id;
  int clienteId;
  int produtoId;
  int quantidade;
  double total;

  Venda({required this.id, required this.clienteId, required this.produtoId, required this.quantidade, required this.total});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
