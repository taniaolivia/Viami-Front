import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/services/image/image.service.dart';
import 'package:viami/services/userImage/userImage.service.dart';
import 'package:viami/services/userImage/usersImages.service.dart';
import 'package:path_provider/path_provider.dart';

class PhotoList extends StatefulWidget {
  final int imageNumber;
  const PhotoList({Key? key, required this.imageNumber}) : super(key: key);

  @override
  State<PhotoList> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  final picker = ImagePicker();
  final storage = const FlutterSecureStorage();

  String? token = "";
  String? userId = "";
  int? userImagesLength = 0;
  String status = "add";
  int? clickedImageId;
  List<UserImage> userImages = [];

  Future<UsersImages> getUserImages() async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    final images = await UsersImagesService()
        .getUserImagesById(userId.toString(), token.toString());

    setState(() {
      userImagesLength = images.userImages.length;
      userImages = images.userImages;
    });

    return images;
  }

  Future<Map<String?, dynamic>> addNewImage(String path) async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    return UserImageService().addUserImage(userId!, path, token!);
  }

  updateImageById(int imageId, List<int> path) async {
    token = await storage.read(key: "token");

    return ImageService().updateImageById(imageId, path, token!);
  }

  Future<Map<String?, dynamic>> deleteUserImage() async {
    token = await storage.read(key: "token");
    userId = await storage.read(key: "userId");

    return UserImageService().deleteUserImage(userId!, clickedImageId!, token!);
  }

  String generateRandomImageName() {
    final uniqueId = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000);
    return 'image_${uniqueId}_$random.jpg';
  }

  Future getImageFromGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    Directory directory = await getApplicationDocumentsDirectory();
    String documentDirectoryPath = directory.path;

    String imageName = generateRandomImageName();
    String newPath = '$documentDirectoryPath/$imageName';

    if (pickedFile == null) {
      return;
    }

    try {
      final File imageFile = File(pickedFile.path);
      await imageFile.copy(newPath);
      final List<int> imageBytes = await imageFile.readAsBytes();

      if (status == "add") {
        addNewImage(newPath);
      } else {
        updateImageById(clickedImageId!, imageBytes);
      }

      setState(() {
        getUserImages();
      });
    } catch (e) {
    }
  }

  Future getImageFromCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    Directory directory = await getApplicationDocumentsDirectory();
    String documentDirectoryPath = directory.path;

    String imageName = generateRandomImageName();
    String newPath = '$documentDirectoryPath/$imageName';

    if (pickedFile == null) {
      return;
    }

    try {
      final File imageFile = File(pickedFile.path);
      await imageFile.copy(newPath);
      final List<int> imageBytes = await imageFile.readAsBytes();

      if (status == "add") {
        addNewImage(newPath);
      } else {
        updateImageById(clickedImageId!, imageBytes);
      }

      setState(() {
        getUserImages();
      });
    } catch (e) {
      print("Error copying image: $e");
    }
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Galerie de photos'),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromGallery();
              getUserImages();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Caméra'),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromCamera();
              getUserImages();
            },
          ),
        ],
      ),
    );
  }

  Future showOptionsImages() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Galerie de photos'),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromGallery();
              getUserImages();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Caméra'),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromCamera();
              getUserImages();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Supprimer'),
            onPressed: () {
              Navigator.of(context).pop();
              deleteUserImage();
              getUserImages();
            },
          ),
        ],
      ),
    );
  }

  Future<String> getApplicationDocumentsDirectoryPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String documentDirectoryPath = directory.path;

    return documentDirectoryPath;
  }

  @override
  void initState() {
    getUserImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return userImagesLength != 0
        ? SingleChildScrollView(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(userImages.length, (index) {
                      return GestureDetector(
                        onTap: () async {
                          setState(() {
                            if (userImagesLength == 3) {
                              status = "update";
                            } else {
                              status = "add";
                            }
                            clickedImageId = userImages[index].imageId;
                          });
                          await showOptionsImages();
                        },
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                              width: MediaQuery.of(context).size.width / 3.8,
                              height: 130,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  color: const Color(0xFFD3D3D3),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(userImages[index].image),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 3,
                              child: IconButton(
                                onPressed: () async {
                                  setState(() {
                                    if (userImagesLength == 3) {
                                      status = "update";
                                    } else {
                                      status = "add";
                                    }
                                    clickedImageId = userImages[index].imageId;
                                  });
                                  await showOptionsImages();
                                },
                                icon: userImages.length != 0
                                    ? const Icon(Icons.create_rounded,
                                        color: Colors.white, size: 20)
                                    : const Icon(Icons.add_circle,
                                        color: Colors.blue, size: 20),
                              ),
                            ),
                          ],
                        ),
                      );
                    })),
                userImagesLength! < 3
                    ? Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        height: 150,
                        child: IconButton(
                            onPressed: () async {
                              await showOptions();
                            },
                            icon: const Icon(Icons.add_circle,
                                size: 50, color: Colors.blue)))
                    : Container()
              ]))
        : Container(
            width: MediaQuery.of(context).size.width / 3.6,
            height: 130,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color.fromARGB(255, 222, 221, 221),
            ),
            child: IconButton(
                onPressed: () async {
                  await showOptions();
                },
                icon: const Icon(Icons.add_circle,
                    size: 50, color: Colors.blue)));
  }
}
