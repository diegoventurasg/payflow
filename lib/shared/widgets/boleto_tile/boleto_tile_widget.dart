import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:payflow/shared/models/boleto_model.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/widgets/boleto_actions/boleto_actions_widget.dart';
import 'package:payflow/shared/widgets/boleto_list/boleto_list_controller.dart';

class BoletoTileWidget extends StatelessWidget {
  final BoletoModel data;
  final BoletoListController controller;
  const BoletoTileWidget({
    Key? key,
    required this.data,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      direction: AnimatedCardDirection.right,
      child: InkWell(
        onTap: () async {
          await showMaterialModalBottomSheet(
            context: context,
            builder: (context) => BoletoActionsWidget(
              data: data,
              controller: controller,
            ),
          );
          await controller.getBoletos();
        },
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            data.name!,
            style: AppTextStyles.titleListTile,
          ),
          subtitle: Text(
            "Vences em ${data.dueDate}",
            style: AppTextStyles.captionBody,
          ),
          trailing: Text.rich(TextSpan(
            text: "R\$ ",
            style: AppTextStyles.trailingRegular,
            children: [
              TextSpan(
                text:
                    "${data.value!.toStringAsFixed(2).replaceFirst(".", ",")}",
                style: AppTextStyles.trailingBold,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
