import 'package:listapedidos/models/pedido_model.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PedidoBanco {

  Future<Database> iniciarBanco() async {
    return await openDatabase(
      // /data/data/<package_name>/databases/"contato.db"
      join(await getDatabasesPath(), 'pedidos.db'),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE pedidos (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, descricao TEXT, categoria TEXT,valor REAL)");
      },
      version: 1
    );
  }
  Future<List<PedidoModel>> listarPedidos() async {

    try{
      final db = await iniciarBanco();
      debugPrint(db.toString());
      final List<Map<String, dynamic>> json = await db.query("pedidos");
      
      return json.map((item) => PedidoModel.fromJson(item)).toList();
    }catch (e) {
      debugPrint("erro: ${e.toString()}");
      
      return [];
    }
    

    
  }

  Future<bool> inserirPedido(PedidoModel dadosPedido) async {
    final db = await iniciarBanco(); 
    await db.insert("pedidos", dadosPedido.toJson());
    return true;
  }

  Future<bool> atualizarPedido(PedidoModel dadosPedido) async {
    final db = await iniciarBanco();
    await db.update(
      "pedidos", 
      dadosPedido.toJson(),
      where: 'id = ?',
      whereArgs: [dadosPedido.id],
      conflictAlgorithm: ConflictAlgorithm.replace
    );
    return true;
  }

  Future<bool> deletarPedido(int id) async {
    final db = await iniciarBanco();
    await db.delete(
      "pedidos",
      where: 'id = ?',
      whereArgs: [id]
    );
    return true;
  }

}