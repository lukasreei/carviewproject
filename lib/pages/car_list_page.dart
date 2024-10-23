import 'package:flutter/material.dart';
import 'car_details.dart';

class CarListPage extends StatelessWidget {
  final List<dynamic> carList;

  const CarListPage({Key? key, required this.carList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados da Pesquisa'),
      ),
      body: carList.isNotEmpty
          ? ListView.builder(
        itemCount: carList.length,
        itemBuilder: (context, index) {
          final car = carList[index];
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
          : const Center(child: Text('Nenhum carro encontrado')),
    );
  }
}