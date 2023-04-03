import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mistry_customer/utils/images.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  List imageList = [
    {"id": 1, "image_path": 'assets/images/Banner_01.png'},
    {"id": 2, "image_path": 'assets/images/Banner_02.png'},
    // {"id": 3, "image_path": 'assets/images/banner.png'}
  ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  Position? _currentPosition;
  String? _currentAddress;
  late Position _position;
  String _address = '';
  _getCurrentLocation() async {
    // Test if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            Exception('Location permissions are permanently denied.'));
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(Exception('Location permissions are denied.'));
      }
    }
    print(serviceEnabled);
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
  Future<void> _getUserCurrentLocation() async {
    try {
      // Test if location services are enabled.
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, handle appropriately.
          return Future.error(
              Exception('Location permissions are permanently denied.'));
        }

        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error(Exception('Location permissions are denied.'));
        }
      }
      _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _position.latitude,
        _position.longitude,
      );
      Placemark placemark = placemarks[0];
      setState(() {
        _address = '${placemark.street ?? ''}, ${placemark.locality ?? ''}, ${placemark.administrativeArea ?? ''}, ${placemark.country ?? ''} ${placemark.postalCode ?? ''}';
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Stack(
          children: [
            InkWell(
              onTap: () {
                print(currentIndex);
                if(currentIndex==0){
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/laundry-service',
                    arguments: "All-Laundry",
                        (route) => true,
                  );
                }else{
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/vehicle-service',
                    arguments: "All-Vehicles",
                        (route) => true,
                  );
                }
              },
              child: CarouselSlider(
                items: imageList
                    .map(
                      (item) => Image.asset(
                        item['image_path'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                    .toList(),
                carouselController: carouselController,
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  autoPlay: true,
                  aspectRatio: 2,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () =>
                            carouselController.animateToPage(entry.key),
                        child: Container(
                          width: currentIndex == entry.key ? 17 : 7,
                          height: 7.0,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 3.0,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: currentIndex == entry.key
                                  ? Colors.red
                                  : Colors.teal),
                        ),
                      );
                    }).toList(),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     _getUserCurrentLocation();
                  //     print(_currentPosition);
                  //   },
                  //   child: Card(
                  //     color: Color(0xffFFFFFF),
                  //     margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         children: [
                  //           Container(
                  //             child: Row(
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceAround,
                  //               children: [
                  //                 ImageIcon(
                  //                   AssetImage(ic_location),
                  //                   color: Color(0XFF1C1F34),
                  //                   size: 16,
                  //                 ),
                  //                 SizedBox(
                  //                   width: 20,
                  //                 ),
                  //                 Text(
                  //                   _currentAddress == null
                  //                       ? "Your location"
                  //                       : _currentAddress!,
                  //                   style: TextStyle(
                  //                     fontFamily: 'SourceSans-Regular',
                  //                     color: Color(0XFF6C757D),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           Expanded(
                  //             child: Container(
                  //               alignment: Alignment.topRight,
                  //               child: ImageIcon(
                  //                 AssetImage(ic_search_location),
                  //                 color: Color(0XFF1C1F34),
                  //                 size: 16,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
