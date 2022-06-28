import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lottie/lottie.dart';
import 'package:photoapp/Services/internet_controller.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

import '../common/Text.dart';

class Details extends StatefulWidget {
  final String image, pName;
  const Details({
    Key? key,
    required this.image,
    required this.pName,
  }) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Future<void> _setwallpaper({location}) async {
    var file = await DefaultCacheManager().getSingleFile(widget.image);
    try {
      WallpaperManagerFlutter().setwallpaperfromFile(file, location);
      Get.snackbar("Successfully", "Set Wallpaper");
    } catch (e) {
      Get.snackbar("Error Setting Wallpaper", "");
      print(e);
    }
  }

  ConnectivityProvider connectivityProvider = Get.put(ConnectivityProvider());
  @override
  void initState() {
    connectivityProvider.startMonitoring();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return Scaffold(
      body: GetBuilder<ConnectivityProvider>(
        builder: (controller) {
          return controller.isOnline
              ? Hero(
                  tag: widget.image,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage("${widget.image}"),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                try {
                                  var response = await Dio()
                                      .get("${widget.image}",
                                          options: Options(
                                              responseType: ResponseType.bytes))
                                      .whenComplete(() => Get.snackbar(
                                          "Successfully", "Save!",
                                          snackPosition: SnackPosition.BOTTOM));
                                  final result =
                                      await ImageGallerySaver.saveImage(
                                          Uint8List.fromList(response.data),
                                          quality: 60,
                                          name: "${widget.pName}");
                                  print(result);
                                } catch (e) {
                                  Get.snackbar("", "$e");
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: height * 0.065,
                                width: width * 0.4,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.grey.withOpacity(0.55)),
                                child: Ts(
                                    text: "Save Gallery",
                                    size: 20,
                                    weight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            GestureDetector(
                              onTap: () async {
                                try {
                                  _setwallpaper(
                                      location:
                                          WallpaperManagerFlutter.BOTH_SCREENS);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: height * 0.065,
                                width: width * 0.5,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.grey.withOpacity(0.55)),
                                child: Ts(
                                    text: "Set as Wallpaper",
                                    size: 20,
                                    weight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.04,
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
