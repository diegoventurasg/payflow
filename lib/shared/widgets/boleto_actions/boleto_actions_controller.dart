import 'package:payflow/shared/models/boleto_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoletoActionsController {
  Future<void> delete(BoletoModel boleto) async {
    try {
      final instance = await SharedPreferences.getInstance();
      final response = instance.getStringList("boletos") ?? <String>[];
      response.removeWhere((e) => boleto == BoletoModel.fromJson(e));
      await instance.setStringList("boletos", response);
    } catch (e) {}
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
