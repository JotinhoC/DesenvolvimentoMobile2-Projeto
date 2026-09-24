import 'package:flutter/material.dart';
import 'package:listapedidos/models/pedido_model.dart';
import 'package:listapedidos/services/pedido_banco.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //============================================
  List<PedidoModel> _listarPedidos = [];

  @override
  void initState(){
    super.initState();
    _carregarLista();
  }

  void _carregarLista() async {
    final pedidos = await PedidoBanco().listarPedidos();
    setState(() {
      _listarPedidos = pedidos; 
    });
  }

  void abrirFormulario(PedidoModel? pedido){
    final nomeController = TextEditingController();
    final descricaoController = TextEditingController();
    final categoriaController = TextEditingController();
    final valorController = TextEditingController();
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(pedido?.id == null ? "Cadastro de contato" : "Edição contato"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(label: Text("Nome")),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(label: Text("Descricao")),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: categoriaController,
                decoration: InputDecoration(label: Text("Categoria")),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: valorController,
                decoration: InputDecoration(label: Text("Valor")),
              ),
              SizedBox(height: 20,),

            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text("Cancelar")
            ),
            TextButton(
              onPressed: () {
                final dadosPedido = PedidoModel(
                  id: pedido?.id,
                  nome: nomeController.text,
                  descricao: descricaoController.text,
                  categoria: categoriaController.text,
                  valor: double.parse(valorController.text)
                );

                _salvarDados(dadosPedido);
              }, 
              child: Text("Salvar")
            )
          ],
        );
      });
  }

  void _salvarDados(PedidoModel pedido) async {
    bool modoEdicao = pedido.id == null;
    bool salvou = false;
    if (modoEdicao) {
      salvou = await PedidoBanco().inserirPedido(pedido);
    } else {
      salvou = await PedidoBanco().atualizarPedido(pedido);
    }
    if (salvou) {
      //fecha modal formulario
      Navigator.of(context).pop();

      // carrega a lista novamente
      _carregarLista();

      //abre a modal de avisos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(modoEdicao ? "Contato salvo!" : "Contato atualizado!"),
        ),
      );
    }
  } //fim da função salvar dados


  //============================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projeto (WIP)"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (contexto, index){
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text("Nome"),
              subtitle: Text("Descrição \nCategoria \nPreço"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
                  IconButton(onPressed: (){}, icon: Icon(Icons.delete))
                ],
              ),
            )
            
          );
        }
        ),
    );
  }
}