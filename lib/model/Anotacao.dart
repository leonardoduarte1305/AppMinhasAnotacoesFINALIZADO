import 'package:notasdiarias/helper/AnotacaoHelper.dart';

class Anotacao {
  int? id;
  late String titulo;
  late String descricao;
  late String data;

  Anotacao(this.titulo, this.descricao, this.data);

  Anotacao.fromMap(Map map) {
    this.id = map[AnotacaoHelper.colunaId];
    this.titulo = map[AnotacaoHelper.colunaTitulo];
    this.descricao = map[AnotacaoHelper.colunaDescricao];
    this.data = map[AnotacaoHelper.colunaData];
  }

  Map toMap() {
    Map<String, dynamic> mapDaAnotacao = {
      "titulo": this.titulo,
      "descricao": this.descricao,
      "data": this.data,
    };

    if (this.id != null) {
      mapDaAnotacao["id"] = this.id;
    }

    return mapDaAnotacao;
  }
}
