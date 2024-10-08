import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'car_details.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _carList = [];

  Future<void> fetchCarData(String brand) async {
    final url = Uri.parse('https://carapi.app/api/models?make=$brand&year=2015&api_key=fa366e7c-4626-4696-9cbe-8aa24ea28b15');

    try {
      final response = await http.get(url);
      print('Status da resposta: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _carList = data['data']; // Assume que a lista de carros está na chave 'data'
        });
      } else {
        print('Erro: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar os dados: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Digite a marca',
                hintText: 'exemplo BMW',
                border: OutlineInputBorder(),
              ),
            ),
            TextButton(
              onPressed: () {
                final brand = _controller.text;
                if (brand.isNotEmpty) {
                  fetchCarData(brand);
                } else {
                  print('Digite uma marca válida');
                }
              },
              child: const Text('Pesquisar'),
            ),
            const SizedBox(height: 20),
            // Verifica se há dados na lista e renderiza usando ListView.builder
            _carList.isNotEmpty
                ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _carList.length,
              itemBuilder: (context, index) {
                final car = _carList[index];
                return ListTile(
                  title: Text(car['name'] ?? 'Nome não disponível'),

                  onTap: () {
                    // Navega para a tela de detalhes passando o carro selecionado
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarDetails(car: car),
                      ),
                    );
                  },
                );
              },
            )
                : const Text('Nenhum carro encontrado'),
          ],
        ),
      ),
    );
  }
}
