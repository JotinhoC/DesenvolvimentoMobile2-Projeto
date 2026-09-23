import 'package:app/models/pedido_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PedidoBanco {

  Future<Database> iniciarBanco() async {
    return await openDatabase(
      // /data/data/<package_name>/databases/"contato.db"
      join(await getDatabasesPath(), 'pedidos.db'),
      onCreate: (db, version) {
        return db.execute("""CREATE TABLE contatos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT,
          descricao TEXT,
          categoria TEXT,
          valor REAL
        )""");
      },
      version: 1
    );
  }
  Future<List<PedidoModel>> listarContatos() async {
    final db = await iniciarBanco();
    final List<Map<String, dynamic>> json = await db.query("pedidos");
     return json.map((item) => PedidoModel.fromJson(item)).toList();
  }

  Future<bool> inserirContato(PedidoModel dadosPedido) async {
    final db = await iniciarBanco(); 
    await db.insert("pedidos", dadosPedido.toJson());
    return true;
  }

  Future<bool> atualizarContato(PedidoModel dadosPedido) async {
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
      "contatos",
      where: 'id = ?',
      whereArgs: [id]
    );
    return true;
  }

}