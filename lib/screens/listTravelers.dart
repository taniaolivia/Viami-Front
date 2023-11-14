import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:viami/models-api/userImage/usersImages.dart';
import 'package:viami/services/userImage/usersImages.service.dart';

class ListTravelersPage extends StatefulWidget {
  final List? users;
  const ListTravelersPage({Key? key, this.users}) : super(key: key);

  @override
  State<ListTravelersPage> createState() => _ListTravelersPageState();
}

class _ListTravelersPageState extends State<ListTravelersPage> {
  final storage = const FlutterSecureStorage();
  String? token;
  String userImages = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {   

  Future<void> getUsersImages() async {
        token = await storage.read(key: "token");

        final images = await UsersImagesService()
            .getUserImagesById(widget.users![0].userId, token.toString());
print(widget.users![0].userId);
        setState(() {
          userImages = images.userImages[0].image;
      });
    }

    getUsersImages();

    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(20, 30, 20, 40),
                child:
                 Column(children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText('Voyageurs',
                            minFontSize: 22,
                            maxFontSize: 25,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText('Retrouvez les voyageurs cherchant un duo pour cette conversation',
                            minFontSize: 9,
                            maxFontSize: 11,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 0.7)
                            ),
                          )
                        ),
                        Container(child: 
                            ListView.builder(
                              itemCount: widget.users!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: ((context, index) {
                                return Container(
                                  width: 100,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    image: DecorationImage(image: NetworkImage(userImages), fit: BoxFit.cover)
                                  ), 
                                );
                              }))
                            
                            
                        )
                ])
              )
    );
  }
}
