import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoList extends StatefulWidget {
  final int imageNumber;
  const PhotoList({Key? key, required this.imageNumber}) : super(key: key);

  @override
  State<PhotoList> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  final picker = ImagePicker();
  List<String> imageList = [];
  int clickedContainerIndex = 0;

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        if (imageList.isEmpty) {
          imageList.add(pickedFile.path);
        } else if (clickedContainerIndex <= imageList.length - 1) {
          setState(() {
            imageList[clickedContainerIndex] = pickedFile.path;
          });
        } else {
          imageList.add(pickedFile.path);
        }
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        if (imageList.isEmpty) {
          imageList.add(pickedFile.path);
        } else if (clickedContainerIndex <= imageList.length - 1) {
          setState(() {
            imageList[clickedContainerIndex] = pickedFile.path;
          });
        } else {
          imageList.add(pickedFile.path);
        }
      }
    });
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
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Caméra'),
            onPressed: () {
              Navigator.of(context).pop();
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> photoList = List.generate(widget.imageNumber, (index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            clickedContainerIndex = index;
          });

          showOptions();
        },
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3.6,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: const Color(0xFFD3D3D3),
                image: imageList.length >= index + 1
                    ? DecorationImage(
                        image: FileImage(File(imageList[index])),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    clickedContainerIndex = index;
                  });

                  showOptions();
                },
                icon: imageList.length >= index + 1
                    ? const Icon(Icons.create_rounded,
                        color: Colors.white, size: 30)
                    : const Icon(Icons.add_circle,
                        color: Colors.blue, size: 30),
              ),
            ),
          ],
        ),
      );
    });

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: photoList);
  }
}
