import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carviewproject/pages/detailscar/list.dart';

class CarDetails extends StatefulWidget {
  final Map<String, dynamic> car;

  const CarDetails({super.key, required this.car});

  @override
  _CarDetailsState createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  Map<String, dynamic>? carDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCarDetails();
  }

  Future<void> fetchCarDetails() async {
    final id = widget.car['id'];
    final apiKey = 'fa366e7c-4626-4696-9cbe-8aa24ea28b15';
    final url = 'https://carapi.app/api/trims/$id?year=2015&api_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          carDetails = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Erro ao buscar detalhes do carro: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro na requisição: $e');
    }
  }

  Widget buildDetail(String label, dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text('$label: $value'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(widget.car['name'] ?? 'Detalhes do Carro'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 26),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : carDetails == null
          ? const Center(child: Text('Detalhes não disponíveis'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: buildDetailsList(carDetails!),
            ),
          ),
        ),
      ),
    );
  }
}
