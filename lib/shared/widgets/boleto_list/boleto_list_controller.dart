import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:payflow/shared/models/boleto_model.dart';

class BoletoListController {
  final boletosNotifier = ValueNotifier<List<BoletoModel>>(<BoletoModel>[]);
  List<BoletoModel> get boletos => boletosNotifier.value;
  set boletos(List<BoletoModel> value) => boletosNotifier.value = value;

  final bool paid;

  BoletoListController({required this.paid}) {
    getBoletos();
  }

  void dispose() {
    boletosNotifier.dispose();
  }

  Future<void> getBoletos({bool? paid}) async {
    paid = paid ?? this.paid;
    try {
      final instance = await SharedPreferences.getInstance();
      final response = instance.getStringList("boletos") ?? <String>[];
      boletos = response
          .where((e) => BoletoModel.fromJson(e).paid! == paid)
          .map((e) => BoletoModel.fromJson(e))
          .toList();
    } catch (e) {
      boletos = <BoletoModel>[];
    }
  }

  Future<void> deleteAll() async {
    try {
      final instance = await SharedPreferences.getInstance();
      instance.remove("boletos");
    } catch (e) {}
  }

  Future<bool> delete(BoletoModel boleto) async {
    try {
      final instance = await SharedPreferences.getInstance();
      final response = instance.getStringList("boletos") ?? <String>[];
      response.removeWhere((e) => boleto == BoletoModel.fromJson(e));
      await instance.setStringList("boletos", response);
      return true;
    } catch (e) {}
    return false;
  }

  Future<void> setPaid(BoletoModel boleto, bool paid) async {
    BoletoModel updatedBoleto = BoletoModel(
      name: boleto.name,
      dueDate: boleto.dueDate,
      value: boleto.value,
      barcode: boleto.barcode,
      paid: paid,
    );
    try {
      final instance = await SharedPreferences.getInstance();
      final response = instance.getStringList("boletos") ?? <String>[];
      response[response.indexWhere((e) => boleto == BoletoModel.fromJson(e))] =
          updatedBoleto.toJson();
      await instance.setStringList("boletos", response);
    } catch (e) {}
  }
}
