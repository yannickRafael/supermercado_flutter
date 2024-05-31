class Cliente {
  int id;
  String nome;
  String email;

  Cliente({required this.id, required this.nome, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
    };
  }

  static Cliente fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
    );
  }
}
