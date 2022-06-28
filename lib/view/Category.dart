import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:photoapp/Services/internet_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../common/Text.dart';
import '../model/categoriesModel.dart';
import 'Details.dart';

class Search2 extends StatefulWidget {
  final querry;
  const Search2({Key? key, this.querry}) : super(key: key);

  @override
  State<Search2> createState() => _Search2State();
}

class _Search2State extends State<Search2> {
  List<PhotosModel> photos = [];
  Future getData(querry) async {
    await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=${widget.querry}&per_page=30&page=1"),
        headers: {
          "Authorization":
              "563492ad6f917000010000016c0aab4b56484ba2990869b52cc89cc5"
        }).then(
      (value) {
        Map<String, dynamic> jsonData = jsonDecode(value.body);
        jsonData['photos'].forEach((element) {
          PhotosModel photosModel = new PhotosModel();
          photosModel = PhotosModel.fromMap(element);
          photos.add(photosModel);
        });
        setState(() {});
      },
    );
  }

  ConnectivityProvider connectivityProvider = Get.put(ConnectivityProvider());
  @override
  void initState() {
    connectivityProvider.startMonitoring();
    getData(widget.querry);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Ts(
              text: "Wallpaper",
              size: 25,
              color: Colors.white,
              weight: FontWeight.w500,
            ),
            Ts(
              text: "Yard",
              size: 25,
              color: Color(0xffFFB74D),
              weight: FontWeight.w500,
            ),
          ],
        ),
      ),
      body: GetBuilder<ConnectivityProvider>(
        builder: (controller) {
          return controller.isOnline
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 300,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: photos.length,
                          itemBuilder: (BuildContext context, int index) {
                            final data = photos[index];
                            return Container(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Details(
                                        pName: "${data.photographer}",
                                        image: "${data.src?.portrait}",
                                      ),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: "${data.src?.portrait}",
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: '${data.src?.portrait}',
                                      height: 300,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: Colors.grey.shade200,
                                        highlightColor: Colors.grey.shade300,
                                        child: Container(
                                          height: 300,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
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
                  child: SizedBox(
                      height: 250,
                      width: 250,
                      child: Lottie.asset("assets/96655-no-internet.json")));
        },
      ),
    );
  }
}
