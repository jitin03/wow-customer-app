import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mistry_customer/model/booking_request.dart';
import 'package:mistry_customer/services/booking_service.dart';
import 'package:mistry_customer/utils/config.dart';
import 'package:mistry_customer/utils/images.dart';

import '../services/shared_service.dart';
import 'auth/landing_screen.dart';

class BookingScreen extends ConsumerStatefulWidget {
  String? providerId;
  String? customerId;
  String? serviceName;

  BookingScreen({this.serviceName,this.providerId, this.customerId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  String? providerId;
  String? customerId;
  Position? _currentPosition;
  String? _currentAddress;
  String? serviceName;
  bool isApiCallProcess = false;
  late TextEditingController _locationController = TextEditingController();
  final _scheduleController = TextEditingController();


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
  void initState(){
    super.initState();
    whereToGo();
    providerId = widget.providerId;
    customerId = widget.customerId;
    serviceName = widget.serviceName;
    print(providerId);
    print(customerId);

  }
  @override
  Widget build(BuildContext context) {
    final format = DateFormat('dd-MM-yyyy HH:mma');
    String location ='Null, Press Button';
    BookingRequest bookingRequest = new BookingRequest();

    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Service"),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: primaryColor,
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: "Work Sans",
            fontSize: 18,
            fontWeight: FontWeight.w800),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Booking Details",
                      style: TextStyle(fontSize: 18, fontFamily: 'Work Sans'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFF6F7F9),
                      border: Border.all(
                        color: Color(0XFF6F7F9),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Your Address :",
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
                              validator: (value){
                                if(value!.isEmpty){
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
                                  fillColor: Colors.white,
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
                                    // _getCurrentLocation();
                                    //
                                    // _locationController.text =
                                    //     _currentAddress ?? "";
                                  },
                                  child: Text(
                                    "Use Current Location",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontFamily: 'Work Sans',
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                            Text(
                              "Date And Time :",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Work Sans',
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            DateTimeField(
                              controller: _scheduleController,
                              validator: (value) {
                                if (value == null) {
                                  return "Please schedule your booking";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: Image.asset(calendar,
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
                              ),
                              format: format,
                              initialValue: DateTime.now(),
                              onChanged: (selectedDate) {
                                if (selectedDate != null && selectedDate.isBefore(DateTime.now())) {
                                  _scheduleController.clear(); // clear the selected date
                                }
                              },
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (date != null) {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now(),
                                    ),
                                  );
                                  return DateTimeField.combine(date, time);
                                } else {
                                  return currentValue;
                                }
                              },
                            ),

                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment:
                                  Alignment.topLeft,
                                  child: Text(
                                    "Disclaimer:",
                                    style: TextStyle(
                                        fontFamily:
                                        'Work Sans',
                                        fontWeight:
                                        FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ),
                                Text(
                                  "We're available to assist you from 9 AM to 5 PM!",
                                  style: TextStyle(
                                      fontFamily: 'Work Sans',
                                      fontWeight:
                                      FontWeight.w500,
                                      color:
                                      Color(0xff6C757D),
                                      fontSize: 12),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0Xff5F60B9),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      // Background color
                    ),
                    onPressed: () async {
                      if (validateAndSave()) {
                        bookingRequest.status = "New";
                        bookingRequest.bookingTime = _scheduleController.text;
                        bookingRequest.customerId = customerId;
                        bookingRequest.serviceType = serviceName;
                        bookingRequest.paymentMode = "UPI";
                        bookingRequest.providerId = providerId;
                        bookingRequest.bookingAddress = _locationController.text;
                        print(bookingRequest.toJson());
                        showConfirmBookDialog(context, () async {
                          setState(() {
                            isApiCallProcess =true;
                          });
                          var resp = await ref
                              .read(bookingServiceProvider)
                              .saveBooking(bookingRequest);
                          setState(() {
                            isApiCallProcess =false;
                          });
                          if(resp !=null){
                            Navigator
                                .pushNamedAndRemoveUntil(
                              context,
                              '/bookings',
                                  (route) => false,
                            );
                          }
                        },isApiCallProcess);
                      }


                    },
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "NEXT",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> whereToGo() async {
    var isLoggedIn = await SharedService.isLoggedIn();
    // var isLoggedIn = false;


    if (isLoggedIn != null) {
      if (isLoggedIn) {
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => DashboadScreen(currentIndex: 0),
        //     ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LandingScreen(),
            ));
      }
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LandingScreen(),
          ));
    }

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

showConfirmBookDialog(context, confirmation,isApiCallProcess) {
  return showDialog(
    context: context,
    builder: (context) {

      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            // padding: EdgeInsets.all(15),
            height: 320,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                      child: ImageIcon(
                        AssetImage(icon_check),
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "Are you sure you want to confirm the booking?",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          isApiCallProcess ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(10.0)),
                              // Background color
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                "SAVING...",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Work Sans',
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ):
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    // Background color
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text(
                                      "CANCEL",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Work Sans',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0Xff5F60B9),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    // Background color
                                  ),
                                  onPressed: confirmation,
                                  child: const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text(
                                      "BOOK",
                                      style: TextStyle(color: Colors.white),
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
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
