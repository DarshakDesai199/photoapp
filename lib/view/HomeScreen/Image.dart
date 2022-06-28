import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photoapp/view/Details.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/ImageData.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  List<Photo> photos = [];
  RefreshController controller = RefreshController(initialRefresh: true);

  var currentPage = 1;
  int? totalPage;
  Future getData<bool>({isRefresh = false}) async {
    if (isRefresh) {
      currentPage = Random().nextInt(200);
    } else {
      if (currentPage >= totalPage!) {
        controller.loadNoData();
        return false;
      }
    }
    http.Response response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/curated?per_page80&page=$currentPage%22563492ad6f917000010000016c0aab4b56484ba2990869b52cc89cc5"),
        headers: {
          "Authorization":
              "563492ad6f917000010000016c0aab4b56484ba2990869b52cc89cc5"
        });
    if (response.statusCode == 200) {
      final result = imageDataFromJson(response.body);
      if (isRefresh) {
        photos = result.photos!;
      } else {
        photos.addAll(result.photos!);
      }
      currentPage++;
      totalPage = result.totalResults!;

      print(response.body);
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SmartRefresher(
        controller: controller,
        onRefresh: () async {
          var result = await getData(isRefresh: true);
          if (result) {
            controller.refreshCompleted();
          } else {
            controller.refreshFailed();
          }
        },
        enablePullUp: true,
        onLoading: () async {
          var result = await getData();
          if (result) {
            controller.loadComplete();
          } else {
            controller.loadFailed();
          }
        },
        child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 5),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisExtent: 300,
            mainAxisSpacing: 10,
          ),
          itemCount: photos.length,
          itemBuilder: (BuildContext context, int index) {
            final data = photos[index];
            return InkWell(
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
                    placeholder: (context, url) => Shimmer.fromColors(
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
            );
          },
        ),
        // child: ListView.separated(
        //   itemCount: photos.length,
        //   separatorBuilder: (BuildContext context, int index) {
        //     return Divider();
        //   },
        //   itemBuilder: (BuildContext context, int index) {
        //     final data = photos[index];
        //     return Image.network(
        //       "${data.src!.portrait}",
        //       height: 200,
        //       width: 350,
        //       fit: BoxFit.cover,
        //     );
        //   },
        // ),
      ),
    );
  }
}
