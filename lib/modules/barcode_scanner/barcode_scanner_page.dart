import 'package:flutter/material.dart';
import 'package:payflow/modules/barcode_scanner/barcode_scanner_controller.dart';
import 'package:payflow/modules/barcode_scanner/barcode_scanner_status.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/widgets/bottom_sheet/bottom_sheet_widget.dart';
import 'package:payflow/shared/widgets/set_label_buttons/set_label_buttons.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key}) : super(key: key);

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final controller = BarcodeScannerController();

  @override
  void initState() {
    controller.getAvailableCameras();
    controller.statusNotifier.addListener(() {
      if (controller.status.hasBarcode) {
        openInsertBoleto();
      }
    });
    super.initState();
  }

  void openInsertBoleto() async {
    //da dispose para fechar a camera
    //antes de abrir a tela de cadastro de boleto
    controller.dispose();
    final result = await Navigator.pushNamed(context, "/insert_boleto",
        arguments: controller.status.barcode);
    //se result for diferente de null
    //o usuário deu back na tela insert_boleto e voltou para a tela de scanner
    //então chama controller.getAvailableCameras() para voltar a escanear
    if (result != null) controller.getAvailableCameras();
  }

  @override
  void dispose() {
    controller.statusNotifier.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ValueListenableBuilder<BarcodeScannerStatus>(
              valueListenable: controller.statusNotifier,
              builder: (_, status, __) {
                if (status.showCamera) {
                  return Container(
                    child: controller.cameraController!.buildPreview(),
                  );
                } else {
                  return Container();
                }
              }),
          RotatedBox(
            quarterTurns: 1,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  "Escaneie o código de barras do boleto",
                  style: AppTextStyles.buttonBackground,
                ),
                centerTitle: true,
                leading: BackButton(
                  color: AppColors.background,
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                      child: Container(
                    color: Colors.black.withOpacity(0.6),
                  )),
                  Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.transparent,
                      )),
                  Expanded(
                      child: Container(
                    color: Colors.black.withOpacity(0.6),
                  )),
                ],
              ),
              bottomNavigationBar: SetLabelButtons(
                primaryLabel: "Inserir código do boleto",
                primaryOnPressed: () {
                  openInsertBoleto();
                },
                secondaryLabel: "Adicionar da galeria",
                secondaryOnPressed: () async {
                  controller.dispose();
                  final imagePicked = await controller.scanWithImagePicker();
                  if (!imagePicked) controller.getAvailableCameras();
                },
              ),
            ),
          ),
          ValueListenableBuilder<BarcodeScannerStatus>(
              valueListenable: controller.statusNotifier,
              builder: (_, status, __) {
                if (status.hasError) {
                  return BottomSheetWidget(
                    title: "Não foi possível identificar um código de barras.",
                    subtitle:
                        "Tente escanear novamente ou digite o código do seu boleto.",
                    primaryLabel: "Escanear novamente",
                    primaryOnPressed: () {
                      //controller.scanWithCamera();
                      controller.getAvailableCameras();
                    },
                    secondaryLabel: "Digitar o código",
                    secondaryOnPressed: () {
                      openInsertBoleto();
                    },
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }
}
