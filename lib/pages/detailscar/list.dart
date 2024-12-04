import 'package:flutter/material.dart';
import 'car_details.dart';

Widget buildDetail(String label, dynamic value) {
  if (value == null || value.toString().isEmpty) {
    return const SizedBox.shrink();
  }
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Text('$label: $value'),
  );
}

List<Widget> buildDetailsList(Map<String, dynamic> carDetails) {
  Map<String, dynamic> detailsMap = {
    'ID': carDetails!['id'],
    'Nome': carDetails!['name'],
    'Descrição': carDetails!['description'],
    'Preço sugerido (MSRP)': carDetails!['msrp'],
    'Fatura': carDetails!['invoice'],
    'Marca': carDetails!['make_model']['make']['name'],
    'Modelo': carDetails!['make_model']['name'],
    'Ano': carDetails!['year'],
    'Tipo de veículo': carDetails!['make_model_trim_body']['type'],
    'Portas': carDetails!['make_model_trim_body']['doors'],
    'Assentos': carDetails!['make_model_trim_body']['seats'],
    'Comprimento': carDetails!['make_model_trim_body']['length'],
    'Largura': carDetails!['make_model_trim_body']['width'],
    'Tipo de motor': carDetails!['make_model_trim_engine']['engine_type'],
    'Combustível': carDetails!['make_model_trim_engine']['fuel_type'],
    'Potência': carDetails!['make_model_trim_engine']['horsepower_hp'],
    'Torque': carDetails!['make_model_trim_engine']['torque_ft_lbs'],
    'Transmissão': carDetails!['make_model_trim_engine']['transmission'],
    'Consumo combinado (MPG)': carDetails!['make_model_trim_mileage']['combined_mpg'],
    'Capacidade do tanque': carDetails!['make_model_trim_mileage']['fuel_tank_capacity'],
  };

  return detailsMap.entries.map((entry) {
    return buildDetail(entry.key, entry.key);
  }).toList();
}