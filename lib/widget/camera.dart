import 'dart:async';
import 'dart:io';
import 'package:black_book/bloc/product/bloc.dart';
import 'package:black_book/bloc/product/event.dart';
import 'package:black_book/bloc/product/state.dart';
import 'package:black_book/bloc/upload/bloc.dart';
import 'package:black_book/bloc/upload/event.dart';
import 'package:black_book/bloc/upload/state.dart';
import 'package:black_book/constant.dart';
import 'package:black_book/models/default/product.dart';
import 'package:black_book/screen/home/navigator.dart';
import 'package:black_book/util/utils.dart';
import 'package:black_book/widget/alert/error.dart';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'alert/mixin_dialog.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen(
      {super.key,
      required this.cameras,
      required this.id,
      required this.list,
      required this.productCode,
      required this.productName});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
  final List<CameraDescription> cameras;
  final String productName, productCode;
  final int id;
  final List<ProductDefaultModel> list;
}

class _CameraScreenState extends State<CameraScreen> with BaseStateMixin {
  late CameraController _cameraController;
  bool _showCamera = true;
  File? imageFile;
  final _bloc = ProductBloc();
  final _blocUpload = UploadBloc();
  String? url;
  FlashMode flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    _cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.high);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }
    final XFile picture = await _cameraController.takePicture();
    setState(() {
      imageFile = File(picture.path);
      _showCamera = false;
    });
  }

  Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<void> onCreate() async {
    if (imageFile == null) {
      showErrorDialog("Зураг оруулна уу!");
    } else {
      if (!await checkNetwork()) {
        showWarningDialog("Интернэт холболтоо шалгана уу.");
      } else {
        _blocUpload.add(UploadPhotoEvent(imageFile!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProductBloc, ProductState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is ProductLoading) {
                Utils.startLoader(context);
              }
              if (state is ProductFailure) {
                if (state.message == "Token") {
                  _bloc.add(CreateProductEvent(widget.productName,
                      widget.productCode, widget.id, widget.list, url!));
                } else {
                  Utils.cancelLoader(context);
                  ErrorMessage.attentionMessage(context, state.message);
                }
              }
              if (state is ProductSuccess) {
                Utils.cancelLoader(context);
                widget.list.clear();
                showSuccessDialog("Мэдээлэл", false, "Амжилттай хадгаллаа");
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const NavigatorScreen(screenIndex: 0,)),
                      (route) => false);
                });
              }
            }),
        BlocListener<UploadBloc, UploadPhotoState>(
            bloc: _blocUpload,
            listener: (context, state) {
              if (state is UploadLoading) {
                Utils.startLoader(context);
              }
              if (state is UploadFailure) {
                if (state.message == "Token") {
                  _blocUpload.add(UploadPhotoEvent(imageFile!));
                } else {
                  Utils.cancelLoader(context);
                  ErrorMessage.attentionMessage(context, state.message);
                }
              }
              if (state is UploadSuccess) {
                Utils.cancelLoader(context);
                setState(() {
                  url = state.data.url!;
                });
                _bloc.add(CreateProductEvent(widget.productName,
                    widget.productCode, widget.id, widget.list, url!));
              }
            })
      ],
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.keyboard_arrow_left, size: 30)),
            foregroundColor: kWhite,
            title: Image.asset('assets/images/logoSecond.png', width: 160)),
        body: _cameraController.value.isInitialized
            ? Stack(
                children: [
                  _showCamera
                      ? Positioned.fill(
                          child: AspectRatio(
                            aspectRatio: _cameraController.value.aspectRatio,
                            child: CameraPreview(_cameraController),
                          ),
                        )
                      : Positioned.fill(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(imageFile!),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.grey,
                              border:
                                  Border.all(width: 8, color: Colors.black12),
                            ),
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      height: 80,
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: kWhite.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextButton(
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: kPrimarySecondColor),
                                      onPressed: () =>
                                          getImage(source: ImageSource.gallery),
                                      child: const Text("Цомог",
                                          style: TextStyle(fontSize: 14))))),
                          Expanded(
                              child: InkWell(
                                  onTap: () =>
                                      _showCamera ? _takePicture() : null,
                                  child: CircleAvatar(
                                      maxRadius: 30,
                                      backgroundColor: kWhite.withOpacity(0.7),
                                      child: const Icon(Icons.circle,
                                          color: kWhite, size: 60)))),
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: kWhite.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: kPrimarySecondColor),
                                onPressed: () => onCreate(),
                                child: const Text(
                                  "Хадгалах",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              ),
      ),
    );
  }

  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
        _showCamera = false;
      });
    }
  }
}
