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
      appBar: AppBar(backgroundColor: Colors.black87, title: const Text('Home'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 360,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/newlogo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(26.0),
              child: TextField(
                style: TextStyle(fontSize: 20),
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Digite a marca',
                  labelStyle: const TextStyle(fontSize: 26, color: Colors.black87,),
                  hintText: 'exemplo BMW',
                  alignLabelWithHint: true,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0)
                  ),
                  filled: true,
                  fillColor: Colors.white
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: TextStyle(fontSize: 18,)
                ),
                onPressed: () {
                  final brand = _controller.text;
                  if (brand.isNotEmpty) {
                    fetchCarData(brand);
                  } else {
                    print('Digite uma marca válida');
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Pesquisar'),
                    SizedBox(width: 12,),
                    Icon(
                      Icons.search,
                      color: Colors.black87,
                      size: 24,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
