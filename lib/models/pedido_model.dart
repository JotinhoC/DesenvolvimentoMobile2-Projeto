class PedidoModel {
  int? id;
  final String nome;
  final String descricao;
  final String categoria;
  final double valor;
  
  PedidoModel({
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.valor,
    this.id
  });

  factory PedidoModel.fromJson(Map json) {
    return PedidoModel(
      id: json['id'],
      nome: json['nome'], 
      descricao: json['descricao'], 
      categoria: json['categoria'],
      valor: json['valor']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nome": nome,
      "descricao": descricao,
      "categoria": categoria,
      "valor": valor
    };
  }
}