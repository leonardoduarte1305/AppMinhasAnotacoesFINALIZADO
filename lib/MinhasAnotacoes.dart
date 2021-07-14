import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notasdiarias/helper/AnotacaoHelper.dart';
import 'package:notasdiarias/model/Anotacao.dart';

import 'model/Anotacao.dart';

class MinhasAnotacoes extends StatefulWidget {
  const MinhasAnotacoes({Key? key}) : super(key: key);

  @override
  _MinhasAnotacoesState createState() => _MinhasAnotacoesState();
}

class _MinhasAnotacoesState extends State<MinhasAnotacoes> {
  TextEditingController _tituloController = new TextEditingController();
  TextEditingController _descricaoController = new TextEditingController();
  List<Anotacao> _anotacoes = [];
  var _db = AnotacaoHelper();

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    _recuperarAnotacoes();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text("Minhas anotações"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _anotacoes.length,
                itemBuilder: (context, index) {
                  final anotacao = _anotacoes[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        anotacao.titulo,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                          "${_dataFormatada(anotacao.data)} - ${anotacao.descricao}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.only(right: 30),
                              child: Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                            ),
                            onTap: () {
                              _exibirTelaCadastro(anotacao: anotacao);
                            },
                          ),
                          GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            onTap: () {
                              _removerItemDaLista(anotacao.id);
                            },
                          )
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _exibirTelaCadastro();
        },
      ),
    );
  }

  _exibirTelaCadastro({Anotacao? anotacao}) {
    String textoSalvarAtualizar = "Criando";
    String textoBotaoSalvarAtualizar = "Salvar";

    if (anotacao != null) {
      textoSalvarAtualizar = "Atualizando";
      _tituloController.text = anotacao.titulo;
      _descricaoController.text = anotacao.descricao;
      textoBotaoSalvarAtualizar = "Atualizar";
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("${textoSalvarAtualizar} anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Título", hintText: "Digite um título..."),
                ),
                TextField(
                  controller: _descricaoController,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Digite uma descrição..."),
                ),
              ],
            ),
            actions: [
              TextButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    _limparCampos();
                    Navigator.pop(context);
                  }),
              TextButton(
                child: Text(textoBotaoSalvarAtualizar),
                onPressed: () {
                  _salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
                  _limparCampos();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _salvarAtualizarAnotacao({Anotacao? anotacaoSelecionada}) async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    DateTime data = new DateTime.now();

    if (anotacaoSelecionada == null) {
      Anotacao anotacao = new Anotacao(titulo, descricao, data.toString());
      int resultado = await _db.salvarAnotacao(anotacao);
    } else {
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data = data.toString();
      int numDeAtualizados = await _db.atualizarAnotacao(anotacaoSelecionada);
    }

    _recuperarAnotacoes();
    _limparCampos();
  }

  _recuperarAnotacoes() async {
    List anotacoesRecuperadas = await _db.recuperarTodas();

    List<Anotacao> listaTemporaria = [];
    for (var item in anotacoesRecuperadas) {
      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);
    }

    setState(() {
      _anotacoes = listaTemporaria;
    });

    anotacoesRecuperadas = [];
  }

  _removerItemDaLista(int? id) async {
    await _db.excluirItem(id!);
    _recuperarAnotacoes();
  }

  _limparCampos() {
    _tituloController.clear();
    _descricaoController.clear();
  }

  _dataFormatada(String data) {
    //var iricializarFormatador = initializeDateFormatting("pt_BR", "BRAZIL");
    var formatador = DateFormat("d/M/y H:m:s");
    String dataFormatada = formatador.format(DateTime.parse(data));
    return dataFormatada;
  }
}
