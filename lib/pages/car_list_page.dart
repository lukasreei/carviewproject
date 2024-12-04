import 'package:flutter/material.dart';
import 'detailscar/car_details.dart';

class CarListPage extends StatelessWidget {
  final List<dynamic> carList;

  const CarListPage({Key? key, required this.carList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('Resultados da Pesquisa'),titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
      ),
      backgroundColor: Colors.white,
      body: carList.isNotEmpty
          ? ListView.builder(
        itemCount: carList.length,
        itemBuilder: (context, index) {
          final car = carList[index];
          return ListTile(
            title: Center(child: Text(car['name'] ?? 'Nome não disponível')),
            onTap: () {
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
