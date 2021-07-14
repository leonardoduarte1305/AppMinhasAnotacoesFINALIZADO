import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  late Database _db;

  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal() {}

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = inicializarDB();
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
}

/*
class Normal {
  Normal() {}
}

class Singleton {
  static final Singleton _singleton = Singleton._internal();

  factory Singleton() {
    print("Singleton");
    return _singleton;
  }

  Singleton._internal() {
    print("_internal");
  }

}
*/
