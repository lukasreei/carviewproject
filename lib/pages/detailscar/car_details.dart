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
    return Card(
      color: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          value.toString(),
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ),
    );
  }

  List<Widget> buildDetailsList(Map<String, dynamic> details) {
    return details.entries.map((entry) {
      return buildDetail(entry.key, entry.value);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.car['name'] ?? 'Detalhes do Carro',
          style: const TextStyle(fontFamily: 'The Seasons', fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
        ),
      )
          : carDetails == null
          ? const Center(
        child: Text(
          'Detalhes não disponíveis',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.car['name'] ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              ...buildDetailsList(carDetails!),
            ],
          ),
        ),
      ),
    );
  }
}
