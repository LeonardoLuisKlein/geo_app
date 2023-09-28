import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _precoBtc = '0';
  String _precoUsd = '0';
  String _precoEur = '0';
  String _endereco = "";
  bool _loading = false;
  bool _loadingCep = false;
  TextEditingController _cep = TextEditingController();
  void _recuperaPrecoBitcoin() async {
    setState(() {
      _loading = true;
    });
    String url =
        "http://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL,BTC-BRL";
    http.Response response = await http.get(Uri.parse(url));

    Map<String, dynamic> retrono = jsonDecode(response.body);

    setState(() {
      _precoBtc = (retrono["BTCBRL"]["bid"].toString());
      _precoUsd = (retrono["USDBRL"]["bid"].toString());
      _precoEur = (retrono["EURBRL"]["bid"].toString());
      _loading = false;
    });
  }

  void _buscaCep(String cep) async {
    setState(() {
      _loadingCep = true;
    });
    print(_cep);
    String url = "https://viacep.com.br/ws/$cep/json/";
    http.Response response = await http.get(Uri.parse(url));
    Map<String, dynamic> retrono = jsonDecode(response.body);

    setState(() {
      _endereco =
          (retrono["localidade"].toString() + " - " + retrono["uf"].toString());
      _loadingCep = false;
    });

    print("Resultado: " + retrono["BRL"]["buy"].toString());
  }

  @override
  void initState() {
    super.initState();
    _recuperaPrecoBitcoin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Geo App",
            textAlign: TextAlign.center,
          ),
          backgroundColor: const Color.fromARGB(255, 37, 83, 163)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.all(40),
              child: Text(
                "Cotações para o Real",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.network(
                "https://cdn-icons-png.flaticon.com/512/2038/2038689.png",
                height: 180,
                width: 180,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text("Valor do bitcoin R\$ $_precoBtc",
                  style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text("Valor do dolar R\$ $_precoUsd",
                  style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Valor do euro R\$ $_precoEur",
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            if (!_loading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 37, 83, 163)),
                    onPressed: _recuperaPrecoBitcoin,
                    child: const Text(
                      "Atualizar preco",
                      style: TextStyle(fontSize: 20.0),
                    )),
              ),
            if (_loading)
              const CircularProgressIndicator(
                color: Color.fromARGB(255, 37, 83, 163),
              ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Image.network(
                "https://static.vecteezy.com/system/resources/previews/010/158/131/original/house-symbol-home-icon-sign-design-free-png.png",
                height: 180,
                width: 180,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(40),
              child: Text(
                "Busca CEP",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: _cep,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Digite o CEP"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text("$_endereco",
                  style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
            ),
            if (!_loadingCep)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 37, 83, 163)),
                    onPressed: () {
                      _buscaCep(_cep.text);
                    },
                    child: const Text(
                      "Buscar Cep",
                      style: TextStyle(fontSize: 20.0),
                    )),
              ),
            if (_loadingCep)
              const CircularProgressIndicator(
                color: Color.fromARGB(255, 37, 83, 163),
              ),
          ]),
        ),
      ),
    );
  }
}
