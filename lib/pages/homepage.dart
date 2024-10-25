import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'car_list_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Homepage extends StatefulWidget {
  final FirebaseAnalytics analytics;

  const Homepage({super.key, required this.analytics});

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
          _carList = data['data'];
        });

        await widget.analytics.logEvent(
          name: 'search_car',
          parameters: {
            'brand': brand,
            'results': _carList.length,
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
        print('Evento search_car registrado com sucesso');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarListPage(carList: _carList),
          ),
        );
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 360,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Digite a marca',
                hintText: 'exemplo BMW',
                prefixIcon: Icon(Icons.search),
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
          ],
        ),
      ),
    );
  }
}
