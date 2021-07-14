import 'package:notasdiarias/model/Anotacao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AnotacaoHelper {
  static final String nomeDaTabela = "anotacao";
  static final String colunaId = "id";
  static final String colunaTitulo = "titulo";
  static final String colunaDescricao = "descricao";
  static final String colunaData = "data";

  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database? _db;

  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal();

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDB();
      return _db;
    }
  }

  inicializarDB() async {
    final caminhoBancoDeDados = await getDatabasesPath();
    final localBancoDeDados =
        join(caminhoBancoDeDados, "banco_minhas_anotacoes.db");

    var db =
        await openDatabase(localBancoDeDados, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    String sql = "CREATE TABLE anotacao ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "titulo VARCHAR,"
        "descricao TEXT,"
        "data DATETIME)";
    await db.execute(sql);
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async {
    var bancoDeDados = await db; // Não está usando o _db, e sim o get do db
    int resultadoId = await bancoDeDados.insert(nomeDaTabela, anotacao.toMap());
    return resultadoId;
  }

  recuperarTodas() async {
    var bancoDeDados = await db; // Não está usando o _db, e sim o get do db
    String sql = "SELECT * FROM ${nomeDaTabela} ORDER BY ${colunaData} DESC";
    return await bancoDeDados.rawQuery(sql);
  }

  Future<int> atualizarAnotacao(Anotacao anotacaoSelecionada) async {
    var bancoDeDados = await db; // Não está usando o _db, e sim o get do db
    return await bancoDeDados.update(nomeDaTabela, anotacaoSelecionada.toMap(),
        where: "id = ?", whereArgs: [anotacaoSelecionada.id]);
  }

  excluirItem(int id) async {
    var bancoDeDados = await db; // Não está usando o _db, e sim o get do db
    return await bancoDeDados
        .delete(nomeDaTabela, where: "id = ?", whereArgs: [id]);
  }
}
