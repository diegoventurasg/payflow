import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payflow/modules/barcode_scanner/barcode_scanner_status.dart';

class BarcodeScannerController {
  final statusNotifier =
      ValueNotifier<BarcodeScannerStatus>(BarcodeScannerStatus());

  BarcodeScannerStatus get status => statusNotifier.value;
  set status(BarcodeScannerStatus status) => statusNotifier.value = status;

  final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  CameraController? cameraController;

  Timer? delay;

  void getAvailableCameras() async {
    try {
      final response = await availableCameras();
      final camera = response.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.back,
      );
      cameraController =
          CameraController(camera, ResolutionPreset.max, enableAudio: false);
      await cameraController!.initialize();
      scanWithCamera();
      listenCamera();
    } catch (e) {
      status = BarcodeScannerStatus.error(e.toString());
    }
  }

  Future<void> scannerBarCode(InputImage inputImage) async {
    try {
      final barcodes = await barcodeScanner.processImage(inputImage);
      print("TOTALB: " + barcodes.length.toString());

      var barcode;
      for (Barcode item in barcodes) {
        barcode = item.value.displayValue;
      }

      if (barcode != null && status.barcode.isEmpty) {
        status = BarcodeScannerStatus.barcode(barcode);
        cameraController!.dispose();
        await barcodeScanner.close();
      }

      return;
    } catch (e) {
      print("ERRO DA LEITURA $e");
    }
  }

  ///If a image was picked return true, else return false
  Future<bool> scanWithImagePicker() async {
    final response = await ImagePicker().getImage(source: ImageSource.gallery);
    if (response != null) {
      final inputImage = InputImage.fromFilePath(response.path);
      await scannerBarCode(inputImage);
      if (status.hasBarcode == false)
        status = BarcodeScannerStatus.error(
            "Não foi possível localizar um código de barras na imagem");
      return true;
    }
    return false;
  }

  void scanWithCamera() {
    status = BarcodeScannerStatus.available();
    delay = Timer(Duration(seconds: 20), () {
      if (status.hasBarcode == false)
        status = BarcodeScannerStatus.error("Timeout de leitura de boleto");
    });
  }

  void listenCamera() {
    if (cameraController!.value.isStreamingImages == false)
      cameraController!.startImageStream((cameraImage) async {
        if (status.stopScanner == false) {
          try {
            final WriteBuffer allBytes = WriteBuffer();
            for (Plane plane in cameraImage.planes) {
              allBytes.putUint8List(plane.bytes);
            }
            final bytes = allBytes.done().buffer.asUint8List();
            final Size imageSize = Size(
                cameraImage.width.toDouble(), cameraImage.height.toDouble());
            final InputImageRotation imageRotation =
                InputImageRotation.Rotation_0deg;
            final InputImageFormat inputImageFormat =
                InputImageFormatMethods.fromRawValue(cameraImage.format.raw) ??
                    InputImageFormat.NV21;
            final planeData = cameraImage.planes.map(
              (Plane plane) {
                return InputImagePlaneMetadata(
                  bytesPerRow: plane.bytesPerRow,
                  height: plane.height,
                  width: plane.width,
                );
              },
            ).toList();

            final inputImageData = InputImageData(
              size: imageSize,
              imageRotation: imageRotation,
              inputImageFormat: inputImageFormat,
              planeData: planeData,
            );
            final inputImageCamera = InputImage.fromBytes(
                bytes: bytes, inputImageData: inputImageData);
            scannerBarCode(inputImageCamera);
          } catch (e) {
            print(e);
          }
        }
      });
  }

  void cancel() {
    delay!.cancel();
    barcodeScanner.close();
    if (status.showCamera) {
      cameraController!.dispose();
    }
  }

  void dispose() {
    delay!.cancel();
    statusNotifier.dispose();
    barcodeScanner.close();
    if (status.showCamera) {
      cameraController!.dispose();
    }
  }
}
