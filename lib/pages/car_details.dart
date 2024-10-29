import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        child:SingleChildScrollView(
          child: Column(
            children: [
              buildDetail('ID', carDetails!['id']),
              buildDetail('Nome', carDetails!['name']),
              buildDetail('Descrição', carDetails!['description']),
              buildDetail('Preço sugerido (MSRP)', carDetails!['msrp']),
              buildDetail('Fatura', carDetails!['invoice']),
              const Divider(),
              buildDetail('Marca', carDetails!['make_model']['make']['name']),
              buildDetail('Modelo', carDetails!['make_model']['name']),
              buildDetail('Ano', carDetails!['year']),
              const Divider(),
              buildDetail('Tipo de veículo', carDetails!['make_model_trim_body']['type']),
              buildDetail('Portas', carDetails!['make_model_trim_body']['doors']),
              buildDetail('Assentos', carDetails!['make_model_trim_body']['seats']),
              buildDetail('Comprimento', carDetails!['make_model_trim_body']['length']),
              buildDetail('Largura', carDetails!['make_model_trim_body']['width']),
              const Divider(),
              buildDetail('Tipo de motor', carDetails!['make_model_trim_engine']['engine_type']),
              buildDetail('Combustível', carDetails!['make_model_trim_engine']['fuel_type']),
              buildDetail('Potência', carDetails!['make_model_trim_engine']['horsepower_hp']),
              buildDetail('Torque', carDetails!['make_model_trim_engine']['torque_ft_lbs']),
              buildDetail('Transmissão', carDetails!['make_model_trim_engine']['transmission']),
              const Divider(),
              buildDetail('Consumo combinado (MPG)', carDetails!['make_model_trim_mileage']['combined_mpg']),
              buildDetail('Capacidade do tanque', carDetails!['make_model_trim_mileage']['fuel_tank_capacity']),
            ],
          ),
        ),
      ),
    );
  }
}
