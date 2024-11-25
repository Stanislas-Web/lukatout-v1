// import 'dart:io';

// import 'package:better_open_file/better_open_file.dart';
// import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_native_image/flutter_native_image.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart' as p ;

// class CameraAwesomeApp extends StatelessWidget {
//   const CameraAwesomeApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const CameraPage();
//   }
// }

// class CameraPage extends StatelessWidget {
//   const CameraPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   backgroundColor: Colors.transparent.withOpacity(0.1),
//       // ),
//       body:CameraAwesomeBuilder.awesome(
//             saveConfig: SaveConfig.photo(
//                 pathBuilder: () => _path(CaptureMode.photo, context)),

//             // saveConfig: SaveConfig.photoAndVideo(
//             //   photoPathBuilder: () => _path(CaptureMode.photo),
//             //   videoPathBuilder: () => _path(CaptureMode.video),
//             //   initialCaptureMode: CaptureMode.photo,
//             // ),
//             // filter: AwesomeFilter.None,
//             flashMode: FlashMode.auto,
//             aspectRatio: CameraAspectRatios.ratio_16_9,
//             previewFit: CameraPreviewFit.fitWidth,
//             onMediaTap: (mediaCapture) {
//               OpenFile.open(mediaCapture.filePath);
//               print('ok ok');
//             },

//       ),
//     );
//   }

//   Future<String> _path(CaptureMode captureMode, context) async {
//     var imageUrl;
//     final Directory extDir = await getTemporaryDirectory();
//     final testDir =
//         await Directory('${extDir.path}/test').create(recursive: true);
//     final String fileExtension =
//         captureMode == CaptureMode.photo ? 'png' : 'mp4';
//     final String filePath =
//         '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
//     // BlocProvider.of<SignupCubit>(context)
//     //     .updateField(context, field: "filePath", data: filePath);

//     final compressedFile = await FlutterNativeImage.compressImage(filePath,
//         quality: 5,);
//     // return compressedFile;

//     print(compressedFile);

//   // final newPath = p.join((await getTemporaryDirectory()).path, '${DateTime.now()}.${p.extension(filePath)}');

//   //   final result = await FlutterImageCompress.compressAndGetFile(
//   //     filePath,
//   //     newPath,
//   //     format: CompressFormat.png,
//   //     quality: 10);
//   //   print(result);

//     // File(filePath);

//     // var request = http.MultipartRequest('POST',
//     //     Uri.parse('https://api.trans-academia.cd/Trans-upload-image.php'));
//     // request.fields.addAll({'App_name': 'app', 'token': '2022', 'id': id});
//     // request.files.add(await http.MultipartFile.fromPath('photo', filePath));

//     // http.StreamedResponse response = await request.send();

//     // if (response.statusCode == 200) {

//     //   print(await response.stream.bytesToString());
//     //       Future.delayed(const Duration(milliseconds: 5000), () async {
//     //   // ignore: use_build_context_synchronously
//     //   Navigator.of(context).pushNamedAndRemoveUntil(
//     //       '/signupStep3', (Route<dynamic> route) => false);
//     // });
//     // return filePath;
//     // } else {
//     //   print(response.reasonPhrase);
//     //   return filePath;
//     // }

//     Future.delayed(const Duration(milliseconds: 2000), () async {
//       // ignore: use_build_context_synchronously
//       Navigator.of(context).pushNamedAndRemoveUntil(
//           '/signupStep3', (Route<dynamic> route) => false);
//     });

//     return filePath;
//   }
// }

// ignore_for_file: use_build_context_synchronously, sort_child_properties_last

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/data/repository/signUp_repository.dart';
import 'package:lukatout/presentation/widgets/buttons/buttonTransAcademia.dart';
import 'package:lukatout/presentation/widgets/dialog/TransAcademiaDialogError.dart';
import 'package:lukatout/presentation/widgets/dialog/loading.dialog.dart';
import 'package:lukatout/presentation/widgets/dialog/loading.dialogPhone.dart';
import 'package:lukatout/theme.dart';
import 'app_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CameraPage extends StatefulWidget {
  final String id;
  final String type;
  const CameraPage({Key? key, required this.id, required this.type})
      : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final _picker = ImagePicker();
  File? fileImage;

  loadPhoto() async {
    var response = await SignUpRepository.getPhoto();

    print(response['avatar']);

    if (response["status"] == 200) {
      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "photo",
          data: "https://kampeni.aads-rdc.org${response["avatar"]}");

      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      print("error");
    }
  }

  void saveImageToSharedPreferences(File? fileImage) async {
    if (fileImage == null) {
      return; // Ne faites rien si le fichier est null
    }

    try {
      List<int> imageBytes = fileImage.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('fileImage', base64Image);
    } catch (e) {
      print('Erreur lors de la sauvegarde du fichier : $e');
    }
  }

  _getImageFrom({required ImageSource source}) async {
    final _pickedImage = await _picker.pickImage(source: source);
    if (_pickedImage != null) {
      var image = File(_pickedImage.path.toString());
      final _sizeInKbBefore = image.lengthSync() / 1024;
      print('Before Compress $_sizeInKbBefore kb');
      // var _compressedImage = await AppHelper.compress(image: image);
      // final _sizeInKbAfter = _compressedImage.lengthSync() / 1024;
      // print('After Compress $_sizeInKbAfter kb');
      // var _croppedImage = await AppHelper.cropImage(_compressedImage);
      var _croppedImage = await AppHelper.cropImage(image);
      if (_croppedImage == null) {
        return;
      }

      setState(() {
        fileImage = _croppedImage;
      });
      saveImageToSharedPreferences(_croppedImage);

      BlocProvider.of<SignupCubit>(context)
          .updateField(context, field: "filePath", data: _croppedImage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: ftPrimary,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: widget.type == "update"
            ? Text("Modifier l'image ")
            : Text(
                "Ajouter l'image ",
                style: TextStyle(color: Colors.white),
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                )),
          )
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (fileImage != null)
            Container(
              height: 350,
              width: 300,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey,
                  image: DecorationImage(
                    image: FileImage(fileImage!),
                    fit: BoxFit.cover,
                  )),
            )
          else
            Container(
              height: 350,
              width: 350,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[300],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _openChangeImageBottomSheet();
                    },
                    child: SvgPicture.asset(
                      "assets/images/Avatar.svg",
                      width: 150,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "L'image s'affichera ici",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
          const SizedBox(
            height: 50,
          ),
          fileImage != null
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () {
                            _openChangeImageBottomSheet();
                          },
                          child: Container(
                            height: 50.0,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: ftRed),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Modifier",
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Center(
                        child: BlocBuilder<SignupCubit, SignupState>(
                          builder: (context, state) {
                            return InkWell(
                              onTap: () async {
                                if (widget.type == "update") {
                                  TransAcademiaLoadingDialog.show(context);
                                  var response =
                                      await SignUpRepository.postPhoto(
                                          state.field!['id'],
                                          state.field!['filePath']);
                                  int status = response['status'];

                                  if (status == 201) {
                                    loadPhoto();
                                  } else {
                                    TransAcademiaLoadingDialog.stop(context);
                                    TransAcademiaDialogError.show(context,
                                        "Erreur de chargement", "login");
                                  }
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Container(
                                height: 50.0,
                                width: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: ftPrimary),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "valider",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: InkWell(
                        onTap: () {
                          _openChangeImageBottomSheet();
                        },
                        child: ButtonTransAcademia(
                            title: fileImage == null
                                ? "Télécharger l'image"
                                : "Changer l'image")),
                  ),
                ),
          // Center(
          //   child: ElevatedButton(
          //       onPressed: () {
          //         _openChangeImageBottomSheet();
          //       },
          //       child: const Text('Upload Image')),
          // ),
        ],
      ),
    );
  }

  _openChangeImageBottomSheet() {
    return showCupertinoModalPopup(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CupertinoActionSheet(
            title: const Text(
              "Changer l'image",
              textAlign: TextAlign.center,
              // style: AppTextStyles.regular(fontSize: 19),
            ),
            actions: <Widget>[
              _buildCupertinoActionSheetAction(
                icon: Icons.camera_alt,
                title: 'Prendre une photo',
                voidCallback: () {
                  Navigator.pop(context);
                  _getImageFrom(source: ImageSource.camera);
                },
              ),
              _buildCupertinoActionSheetAction(
                icon: Icons.image,
                title: 'Importer depuis la Gallery',
                voidCallback: () {
                  Navigator.pop(context);
                  _getImageFrom(source: ImageSource.gallery);
                },
              ),
              _buildCupertinoActionSheetAction(
                title: 'Annuler',
                color: Colors.red,
                voidCallback: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _buildCupertinoActionSheetAction({
    IconData? icon,
    required String title,
    required VoidCallback voidCallback,
    Color? color,
  }) {
    return CupertinoActionSheetAction(
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: color ?? const Color(0xFF2564AF),
            ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              // style: AppTextStyles.regular(
              //   fontSize: 17,
              //   color: color ?? const Color(0xFF2564AF),
              // ),
            ),
          ),
          if (icon != null)
            const SizedBox(
              width: 25,
            ),
        ],
      ),
      onPressed: voidCallback,
    );
  }
}
