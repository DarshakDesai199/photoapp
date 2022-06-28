import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:photoapp/Services/internet_controller.dart';
import 'package:photoapp/common/Text.dart';
import 'package:photoapp/view/Category.dart';
import 'package:photoapp/view/HomeScreen/Image.dart';
import 'package:photoapp/view/Search.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> categories = [
    {
      'image':
          "https://images.pexels.com/photos/545008/pexels-photo-545008.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
      'name': "Street Art"
    },
    {
      'image':
          "https://images.pexels.com/photos/34950/pexels-photo.jpg?auto=compress&cs=tinysrgb&dpr=2&w=500",
      'name': "Wild Life"
    },
    {
      'image':
          "https://images.pexels.com/photos/466685/pexels-photo-466685.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
      'name': "Motivation"
    },
    {
      'image':
          "https://images.pexels.com/photos/2116475/pexels-photo-2116475.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
      'name': "Bikes"
    },
    {
      'image':
          "https://images.pexels.com/photos/1149137/pexels-photo-1149137.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500",
      'name': "Cars"
    },
  ];
  TextEditingController search = TextEditingController();
  ConnectivityProvider connectivityProvider = Get.put(ConnectivityProvider());
  @override
  void initState() {
    connectivityProvider.startMonitoring();
    super.initState();
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
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
                ? SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.065,
                            width: width * 0.94,
                            child: TextFormField(
                              controller: search,
                              cursorColor: Colors.grey,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xffE0F2F1),
                                  hintText: "Search",
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        Get.to(() => Search(
                                              querry: search.text.isEmpty
                                                  ? "All"
                                                  : search.text,
                                            ))?.then(
                                          (value) => search.clear(),
                                        );
                                      },
                                      child: Icon(Icons.search,
                                          color: Colors.black)),
                                  hintStyle: TextStyle(fontSize: 17),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none)),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          SizedBox(
                            height: height * 0.078,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => Search2(
                                            querry:
                                                '${categories[index]['name']}',
                                          ));
                                    },
                                    child: Container(
                                      height: height,
                                      width: width * 0.35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              "${categories[index]['image']}",
                                            ),
                                            fit: BoxFit.cover),
                                      ),
                                      child: Container(
                                        height: height,
                                        width: width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${categories[index]['name']}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          ImageScreen()
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: SizedBox(
                        height: 250,
                        width: 250,
                        child: Lottie.asset("assets/96655-no-internet.json")));
          },
        ));
  }
}
