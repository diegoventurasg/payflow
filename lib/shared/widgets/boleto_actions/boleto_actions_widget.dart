import 'package:flutter/material.dart';

import 'package:payflow/shared/models/boleto_model.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/widgets/actions_button/actions_button.dart';
import 'package:payflow/shared/widgets/boleto_list/boleto_list_controller.dart';

class BoletoActionsWidget extends StatelessWidget {
  final BoletoModel data;
  final BoletoListController controller;
  const BoletoActionsWidget({
    Key? key,
    required this.data,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              height: 2,
              width: 43,
              decoration: BoxDecoration(
                color: AppColors.input,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 78,
              vertical: 26,
            ),
            child: Text.rich(
              TextSpan(
                text: controller.paid ? "Voltar o boleto " : "O boleto ",
                style: AppTextStyles.titleHeading,
                children: [
                  TextSpan(
                    text: data.name,
                    style: AppTextStyles.titleBoldHeading,
                  ),
                  TextSpan(
                    text: " no valor de R\$ ",
                    style: AppTextStyles.titleHeading,
                  ),
                  TextSpan(
                    text: data.value.toString(),
                    style: AppTextStyles.titleBoldHeading,
                  ),
                  TextSpan(
                    text: controller.paid ? " como não pago?" : " foi pago?",
                    style: AppTextStyles.titleHeading,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ActionsButton.white(
                label: controller.paid ? "Cancelar" : "Ainda não",
                onTap: () {
                  Navigator.pop(context);
                },
                textStyle: AppTextStyles.buttonGray,
              ),
              ActionsButton.orange(
                label: "Sim",
                onTap: () async {
                  await controller.setPaid(data, !controller.paid);
                  Navigator.pop(context);
                },
                textStyle: AppTextStyles.buttonBackground,
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Divider(
            thickness: 1,
            height: 1,
            color: AppColors.stroke,
          ),
          TextButton(
            onPressed: () async {
              final deleted = await controller.delete(data);
              if (deleted) {
                final snackBar = SnackBar(content: Text('Boleto'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.delete_forever_sharp,
                  color: Colors.red,
                  size: 15,
                ),
                Text(
                  "Deletar boleto",
                  style: AppTextStyles.buttonDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
