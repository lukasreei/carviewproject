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
        title: const Text('Resultados da Pesquisa',
        style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: carList.isNotEmpty
          ? ListView.builder(
        itemCount: carList.length,
        itemBuilder: (context, index) {
          final car = carList[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: Text(car['name'] ?? 'Nome não disponível', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              subtitle: Text('Detalhes Disponiveis', style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.black87,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarDetails(car: car),
                  ),
                );
              },
            ),
          );
        },
      )
          : const Center(child: Text('Nenhum carro encontrado')),
    );
  }
}
