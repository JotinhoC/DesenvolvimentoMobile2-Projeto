import 'package:app/models/pedido_model.dart';
import 'package:app/services/pedido_banco.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    //============================================
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _valorController = TextEditingController();
  List<PedidoModel> _listarPedidos = []; 

  @override
  void initState() {
    super.initState();
    _carregarLista();
  }

  void _carregarLista() async {
    final pedidos = await PedidoBanco().listarContatos();
    setState(() {
      _listarPedidos = pedidos;
    });
  }

  void abrirFormulario(PedidoModel pedido) {
    _nomeController.text= pedido.nome;
    _descricaoController.text= pedido.descricao;
    _categoriaController.text= pedido.categoria;
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Cadastro"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  label: Text("Nome")
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  label: Text("Descrição")
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _categoriaController,
                decoration: InputDecoration(
                  label: Text("Categoria")
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _valorController,
                decoration: InputDecoration(
                  label: Text("Valor")
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
            TextButton(onPressed: () => _salvarDados(pedido), child: Text("Salvar"))
          ],
        );
      }
    );
  }//fim da função abrir formulario
  
  void _salvarDados(PedidoModel pedido) async {
    // pega os dados do formulario e cria um novo contato
    final novoPedido = PedidoModel(
      nome: _nomeController.text,
      descricao: _descricaoController.text,
      categoria: _categoriaController.text,
      valor: double.parse(_valorController.text),
      id: pedido.id
    );
    //verifica se é modo de edição ou cadastro
    bool modoEdicao = pedido.id == null;// se false, é modo de cadastro
    bool cadastrou = false;
    if(modoEdicao) {
      cadastrou = await PedidoBanco().inserirContato(novoPedido);
    } else {
      cadastrou = await PedidoBanco().atualizarContato(novoPedido);
    }
    if(cadastrou) {
      //atualiza a lista de contatos
      _carregarLista();
      //limpa os campos do formulario
      _nomeController.clear();
      _descricaoController.clear();
      _categoriaController.clear();
      _valorController.clear();
      //fecha o formulario
      Navigator.of(context).pop();
    }
  }

  void deletarContato(int id) async {
    bool deletou = await PedidoBanco().deletarPedido(id);
    if(deletou){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Contato apagado!"))
      );
    }
  }

  //modal confirmação
  void _abrirModalExclusao(PedidoModel contato){
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Excluir Contato"),
          content: Text("Tem certeza que deseja excluir ${contato.nome}?"),
          actions: [
            TextButton(onPressed: ()=>Navigator.of(context).pop(), 
            child: Text("Cancelar")),

            TextButton(
              onPressed: (){
                deletarContato(contato.id!);
                _carregarLista();
              }, 
              child: Text("Excluir")),

            
          ],
        );
      });
  }

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
              subtitle: Text("Descricao - categoria \n Preço"),
              isThreeLine: true
              
            ),
          );
        }
        ),
    );
  }
}