import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mistry_customer/model/customer_review_request.dart';

import '../provider/data_provider.dart';
import '../utils/config.dart';
import '../utils/images.dart';

class CustomerFeedback extends ConsumerStatefulWidget {
  final Object? customerId;

  CustomerFeedback({required this.customerId});

  @override
  ConsumerState<CustomerFeedback> createState() => _CustomerFeedbackState();
}

class _CustomerFeedbackState extends ConsumerState<CustomerFeedback> {
  late TextEditingController _locationController = TextEditingController();
  late TextEditingController serviceTypeController = TextEditingController();
  late TextEditingController serviceTypeDescriptionController = TextEditingController();
  Position? _currentPosition;
  String? _currentAddress;
CustomerFeedbackRequest feedbackRequest = CustomerFeedbackRequest();
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }


  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    _currentAddress = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    print(_currentAddress);
    setState(()  {
      _locationController.text =_currentAddress!;
    });
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    print(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    String location ='Null, Press Button';
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "New Service Suggestion",
        ),
        backgroundColor: primaryColor,
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: "Work Sans",
            fontSize: 18,
            fontWeight: FontWeight.w800),
      ),
      body: Form(
        key: formkey,
        child: Stack(children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        color: Color(0XFFF6F7F9),
                        border: Border.all(color: Color(0XFF6F7F9)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        controller: serviceTypeController,
                        validator: (value) {
                          if (value!.isEmpty || value == null) {
                            return 'Please enter your service type';
                          }
                        },
                        style: TextStyle(
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Service Type",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        color: Color(0XFFF6F7F9),
                        border: Border.all(color: Color(0XFF6F7F9)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        controller: serviceTypeDescriptionController,
                        maxLines: 4,
                        validator: (value) {
                          if (value!.isEmpty || value == null) {
                            return 'Please enter some description';
                          }
                        },
                        style: TextStyle(
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Service Description",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Which Area?",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _locationController,
                          maxLines: 3,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the address';
                            }
                          },
                          decoration: InputDecoration(
                              prefixIcon: Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Image.asset(ic_location,
                                    height: 20,
                                    width: 20,
                                    color: Color(0xFF6C757D)),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              fillColor: Color(0XFFF6F7F9),
                              filled: true,
                              hintText: "Address"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () async {
                              Position position = await _getGeoLocationPosition();
                              location ='Lat: ${position.latitude} , Long: ${position.longitude}';
                              GetAddressFromLatLong(position);
                            },
                            child: Text(
                              "Use Current Location",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 12,
                                  fontFamily: 'Work Sans',
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(5),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0Xff5F60B9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                onPressed: () async {
                  feedbackRequest.customerId = widget.customerId.toString();
                  feedbackRequest.serviceType = serviceTypeController.text;
                  feedbackRequest.serviceArea = _locationController.text;
                  feedbackRequest.serviceDescription = serviceTypeDescriptionController.text;

                  print(feedbackRequest.toJson());
                  if (validateAndSave()) {
                    var response = await ref
                        .read(reviewProvider)
                        .createCustomerFeedback(feedbackRequest);
                    if (response != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Your suggestion is saved with us!')),
                      );
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/dashboard',
                        (route) => false,
                      );
                    }
                  }
                },
                child: const Text(
                  'SAVE',
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'Work Sans'),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  bool validateAndSave() {
    final form = formkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
