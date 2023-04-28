import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../components/round_button_icon.dart';

import '../model/booking_request.dart';
import '../model/cart.dart';
import '../model/customer_coupons_response.dart';
import '../model/validate_wow_coupon_request.dart';
import '../model/validate_wow_coupon_response.dart';
import '../provider/cart_view_model.dart';
import '../provider/data_provider.dart';
import '../services/booking_service.dart';
import '../services/shared_service.dart';
import '../utils/config.dart';
import '../utils/images.dart';
import 'auth/landing_screen.dart';

class StepperDemo extends ConsumerStatefulWidget {
  String? providerId;
  String? customerId;
  String? serviceName;
  StepperDemo({this.serviceName, this.providerId, this.customerId});
  @override
  _StepperDemoState createState() => _StepperDemoState();
}

class _StepperDemoState extends ConsumerState<StepperDemo> {
  int value = 0;
  late int discountRate;
  late String apply_coupon;
  String? providerId;
  String? customerId;
  String? serviceName;
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;
  bool isApiCallProcess = false;
  late TextEditingController _locationController = TextEditingController();
  final _scheduleController = TextEditingController();
  String? _currentAddress;
  List<ServiceLists> serviceLists = [];
  List<SubCategories> subCategoriesList = [];
  ServiceLists serviceList = ServiceLists();
  bool isEdit = false;

  bool isFormCompleted = false;
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
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    print(_currentAddress);
    setState(() {
      _locationController.text = _currentAddress!;
    });
  }

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool isBookingDetailComplete() {
    // if(_currentStep==0){
    //check address info form
    if (_locationController.text.isEmpty || _scheduleController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
    // }
  }

  @override
  void initState() {
    super.initState();

    whereToGo();
    providerId = widget.providerId;
    customerId = widget.customerId;
    serviceName = widget.serviceName;
    print(providerId);
    print(customerId);
    discountRate = 0;
    apply_coupon = "Apply Coupon";
  }

  @override
  Widget build(BuildContext context) {
    BookingRequest bookingRequest = new BookingRequest();
    final format = DateFormat('dd-MM-yyyy HH:mma');
    String location = 'Null, Press Button';
    final _providerDetails = ref.watch(providerDetailsData(providerId!));
    var customerCoupons =
        ref.watch(providerCustomerCouponProvider(widget.serviceName!));
    var cartList = ref.watch(cartListProvider).list =
        (ref.watch(cartListProvider).list.length == 0)
            ? [
                Cart(id: 0, title: "", price: 1, count: 0),
                Cart(id: 1, title: "", price: 1, count: 0),
                Cart(id: 2, title: "", price: 1, count: 0),
                Cart(id: 3, title: "", price: 1, count: 0),
                Cart(id: 4, title: "", price: 1, count: 0),
                Cart(id: 6, title: "", price: 1, count: 0),
                Cart(id: 7, title: "", price: 1, count: 0),
                Cart(id: 8, title: "", price: 1, count: 0),
                Cart(id: 9, title: "", price: 1, count: 0),
                Cart(id: 10, title: "", price: 1, count: 0),
                Cart(id: 11, title: "", price: 1, count: 0),
                Cart(id: 12, title: "", price: 1, count: 0),
                Cart(id: 13, title: "", price: 1, count: 0),
                Cart(id: 14, title: "", price: 1, count: 0),
                Cart(id: 15, title: "", price: 1, count: 0),
                Cart(id: 16, title: "", price: 1, count: 0),
                Cart(id: 17, title: "", price: 1, count: 0),
                Cart(id: 18, title: "", price: 1, count: 0),
                Cart(id: 19, title: "", price: 1, count: 0),
                Cart(id: 20, title: "", price: 1, count: 0),
                Cart(id: 21, title: "", price: 1, count: 0),
                Cart(id: 22, title: "", price: 1, count: 0),
                Cart(id: 23, title: "", price: 1, count: 0),
              ]
            : ref.watch(cartListProvider).list;

    var totalAmount = ref.read(totalAmountProvider);

    int indexOfServiceName = -1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Service"),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onTap: () {
            // ref.invalidate(totalAmountProvider);
            ref.invalidate(cartListProvider);

            totalAmount = 0.0;
            cartList = [];
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
      body: Form(
        key: formkey,
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Stepper(
                  controlsBuilder:
                      (BuildContext context, ControlsDetails details) {
                    return Row(
                      children: <Widget>[
                        if (_currentStep == 0)
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0Xff5F60B9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: details.onStepContinue,
                              child: const Text(
                                'NEXT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Work Sans',
                                ),
                              ),
                            ),
                          ),
                        if (_currentStep > 0)
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: details.onStepCancel,
                              child: const Text(
                                'CANCEL',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Work Sans',
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 10),
                        if (_currentStep == 1)
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0Xff5F60B9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                // TODO: add your custom action here
                                print('Custom action executed on last step');
                                // details.onStepCancel!();

                                bookingRequest.status = "New";
                                bookingRequest.bookingTime =
                                    _scheduleController.text;
                                bookingRequest.customerId = customerId;

                                //HACK AS OF NOW DUE TO PAYMENT GATEWAY UNAVAILABILITY
                                bookingRequest.paymentMode = "CASH";
                                bookingRequest.providerId = providerId;
                                bookingRequest.bookingAddress =
                                    _locationController.text;

                                bookingRequest.grossAmount =
                                    totalAmount.toStringAsFixed(2);
                                bookingRequest.paymentStatus = "Pending";

                                for (int index = 0;
                                    index <
                                        _providerDetails
                                            .value!
                                            .providerDetails
                                            .serviceLists![indexOfServiceName]
                                            .subCategory!
                                            .length;
                                    index++) {
                                  var subCategories = SubCategories();
                                  subCategories.name = _providerDetails
                                      .value!
                                      .providerDetails
                                      .serviceLists![indexOfServiceName]
                                      .subCategory![index]
                                      .name!;
                                  subCategories.price = _providerDetails
                                      .value!
                                      .providerDetails
                                      .serviceLists![indexOfServiceName]
                                      .subCategory![index]
                                      .price;
                                  subCategories.count =
                                      cartList?[index].count.toString() ?? "";
                                  if (int.parse(subCategories.count!) > 0) {
                                    subCategoriesList.add(subCategories);
                                  }
                                }

                                serviceList.subCategories = subCategoriesList;
                                serviceLists.add(serviceList);

                                bookingRequest.serviceLists = serviceLists;

                                print(bookingRequest.toJson());
                                showConfirmBookDialog(context, () async {
                                  setState(() {
                                    isApiCallProcess = true;
                                  });
                                  var resp = await ref
                                      .read(bookingServiceProvider)
                                      .saveBooking(bookingRequest);
                                  setState(() {
                                    isApiCallProcess = false;
                                  });
                                  ref.invalidate(cartListProvider);

                                  totalAmount = 0.0;
                                  cartList = [];
                                  if (resp != null) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/bookings',
                                      (route) => false,
                                    );
                                  }
                                }, isApiCallProcess);
                              },
                              child: const Text(
                                'CONFIRM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Work Sans',
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  type: stepperType,
                  physics: ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) {
                    formkey.currentState!.validate();
                    setState(() => _currentStep = step);
                  },
                  onStepCancel: _currentStep == 0 ? null : cancel,
                  onStepContinue: () {
                    formkey.currentState!.validate();

                    bool isBookingDetailValid = isBookingDetailComplete();
                    if (_currentStep == 1) {
                      // TODO: add your custom action here
                      print('Custom action executed on last step');
                    } else {
                      if (isBookingDetailValid) {
                        continued();
                      }
                    }
                  },
                  steps: <Step>[
                    Step(
                      title: new Text('Address Info'),
                      content: Container(
                        // margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Booking Details",
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Work Sans'),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                              Position position =
                                                  await _getGeoLocationPosition();
                                              location =
                                                  'Lat: ${position.latitude} , Long: ${position.longitude}';
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                        ),
                                        format: format,
                                        initialValue: DateTime.now(),
                                        onChanged: (selectedDate) {
                                          if (selectedDate != null &&
                                              selectedDate
                                                  .isBefore(DateTime.now())) {
                                            _scheduleController
                                                .clear(); // clear the selected date
                                          }
                                        },
                                        onShowPicker:
                                            (context, currentValue) async {
                                          final date = await showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            initialDate:
                                                currentValue ?? DateTime.now(),
                                            lastDate: DateTime(2100),
                                          );
                                          if (date != null) {
                                            final time = await showTimePicker(
                                              context: context,
                                              initialTime:
                                                  TimeOfDay.fromDateTime(
                                                currentValue ?? DateTime.now(),
                                              ),
                                            );
                                            return DateTimeField.combine(
                                                date, time);
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
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Disclaimer:",
                                              style: TextStyle(
                                                  fontFamily: 'Work Sans',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                          ),
                                          Text(
                                            "We're available to assist you from 9 AM to 5 PM!",
                                            style: TextStyle(
                                                fontFamily: 'Work Sans',
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff6C757D),
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
                          ],
                        ),
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: new Text('Add Items'),
                      content: Column(
                        children: [
                          Container(
                            child: _providerDetails.when(
                              data: (_data) {
                                for (int i = 0;
                                    i <
                                        _data.providerDetails.serviceLists!
                                            .length;
                                    i++) {
                                  if (_data.providerDetails.serviceLists![i]
                                          .name ==
                                      serviceName) {
                                    indexOfServiceName = i;
                                    break;
                                  }
                                }
                                return SingleChildScrollView(
                                  child: Container(
                                    // margin: EdgeInsets.fromLTRB(25, 20, 25, 20),
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            serviceName.toString(),
                                            style: TextStyle(
                                                fontFamily: 'Work Sans',
                                                fontWeight: FontWeight.w800,
                                                fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 220,
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Color(0XFFF6F7F9),
                                                  border: Border.all(
                                                    color: Color(0XFF6F7F9),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: ListView.separated(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  itemCount: _data
                                                      .providerDetails
                                                      .serviceLists![
                                                          indexOfServiceName]
                                                      .subCategory!
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    cartList[index].price = _data
                                                        .providerDetails
                                                        .serviceLists![
                                                            indexOfServiceName]
                                                        .subCategory![index]
                                                        .price!;
                                                    serviceList.name = _data
                                                        .providerDetails
                                                        .serviceLists![
                                                            indexOfServiceName]
                                                        .name;
                                                    serviceList.price = _data
                                                        .providerDetails
                                                        .serviceLists![
                                                            indexOfServiceName]
                                                        .price;

                                                    return Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Container(
                                                            child: Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    softWrap:
                                                                        true,
                                                                    _data
                                                                        .providerDetails
                                                                        .serviceLists![
                                                                            indexOfServiceName]
                                                                        .subCategory![
                                                                            index]
                                                                        .name!,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontFamily:
                                                                            'Work Sans',
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                  Text(
                                                                      '( \u{20B9} ${_data.providerDetails.serviceLists![indexOfServiceName].subCategory![index].price})')
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Row(
                                                              children: [
                                                                RoundedIconButton(
                                                                  icon: Icons
                                                                      .remove,
                                                                  iconSize:
                                                                      22.0,
                                                                  onPress: () {
                                                                    ref
                                                                        .read(
                                                                            cartListProvider)
                                                                        .decrement(
                                                                            index);
                                                                    setState(
                                                                        () {
                                                                      isEdit =
                                                                          true;
                                                                    });
                                                                  },
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                    cartList[
                                                                            index]
                                                                        .count
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          22.0 *
                                                                              0.7,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                                RoundedIconButton(
                                                                  icon:
                                                                      Icons.add,
                                                                  iconSize:
                                                                      22.0,
                                                                  onPress: () {
                                                                    ref
                                                                        .read(
                                                                            cartListProvider)
                                                                        .increment(
                                                                            index);
                                                                    setState(
                                                                        () {
                                                                      isEdit =
                                                                          true;
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          // Text(cartList[index].count.toString() ?? 'asdsad'),
                                                          // Text((_data.providerDetails.serviceLists![0]
                                                          //         .subCategory![index].price! * (cartList[index].count!)).toStringAsFixed(1) ),
                                                          Expanded(
                                                            child: FittedBox(
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                              child: Container(
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    '\u{20B9}' +
                                                                        (cartList[index].price! *
                                                                                (cartList[index].count!))
                                                                            .toStringAsFixed(1),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Work Sans',
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          // Text("Items (${cartList.length})"),
                                                          // Text("\$${totalAmount.toStringAsFixed(2)}"),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                              int index) =>
                                                          const Divider(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Price Details",
                                            style: TextStyle(
                                                fontFamily: 'Work Sans',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          margin: const EdgeInsets.only(top: 8),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFF6F7F9),
                                            border: Border.all(
                                              color: Color(0XFF6F7F9),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // Text("Items (${cartList.length})"),
                                                  // Text("\$${totalAmount.toStringAsFixed(2)}"),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Text("Shipping"),
                                                  Text("\u{20B9}00.00"),
                                                ],
                                              ),
                                              const Divider(
                                                  color: primaryColor),

                                              (discountRate != null)
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('Discount '),
                                                            Text(
                                                              '(${discountRate}% off)',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontFamily:
                                                                      'Work Sans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                            "- \u{20B9}${(totalAmount * discountRate / 100).toStringAsFixed(2)}",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Work Sans',
                                                                color: Colors
                                                                    .green))
                                                      ],
                                                    )
                                                  : Container(),
                                              const Divider(
                                                  color: primaryColor),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Coupon",
                                                    style: TextStyle(
                                                      fontFamily: 'Work Sans',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {
                                                            if (apply_coupon ==
                                                                "Apply Coupon") {
                                                              var customerCoupons =
                                                                  ref.watch(
                                                                      providerCustomerCouponProvider(
                                                                          widget
                                                                              .serviceName!));
                                                              late TextEditingController
                                                                  _wowCoupon =
                                                                  TextEditingController();
                                                              await showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                isScrollControlled:
                                                                    true,
                                                                enableDrag:
                                                                    true,
                                                                builder:
                                                                    (BuildContext
                                                                        builder) {
                                                                  return StatefulBuilder(
                                                                      builder:
                                                                          (context,
                                                                              setState) {
                                                                    return Container(
                                                                      width:
                                                                          100,
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          .8,
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        left:
                                                                            5.0,
                                                                        right:
                                                                            5.0,
                                                                        top:
                                                                            5.0,
                                                                        bottom:
                                                                            5.0,
                                                                      ),
                                                                      decoration: new BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: new BorderRadius.only(
                                                                              topLeft: const Radius.circular(10.0),
                                                                              topRight: const Radius.circular(10.0))),
                                                                      child: customerCoupons
                                                                          .when(
                                                                        data:
                                                                            (_data) {
                                                                          List<WowCustomerCoupons>
                                                                              coupons =
                                                                              _data.coupons;
                                                                          List<WowCustomerCoupons>
                                                                              referralCoupons =
                                                                              _data.referralCoupons;

                                                                          Set<WowCustomerCoupons>
                                                                              uniqueCoupons =
                                                                              Set<WowCustomerCoupons>.from(coupons);
                                                                          for (WowCustomerCoupons referralCoupon
                                                                              in referralCoupons) {
                                                                            uniqueCoupons.add(referralCoupon);
                                                                          }

                                                                          coupons =
                                                                              uniqueCoupons.toList();

                                                                          return SingleChildScrollView(
                                                                            child:
                                                                                Container(
                                                                              child: Column(
                                                                                children: [
                                                                                  Container(
                                                                                    padding: EdgeInsets.only(left: 20, right: 10),
                                                                                    width: double.infinity,
                                                                                    decoration: BoxDecoration(
                                                                                      shape: BoxShape.rectangle,
                                                                                      color: primaryColor,
                                                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                                                    ),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          "Coupons",
                                                                                          style: TextStyle(fontFamily: 'Work Sans', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                                                                        ),
                                                                                        Container(
                                                                                          alignment: FractionalOffset.topRight,
                                                                                          child: IconButton(
                                                                                            onPressed: () {
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            icon: const Icon(
                                                                                              Icons.clear,
                                                                                              color: Colors.white,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    padding: EdgeInsets.all(20),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: Container(
                                                                                                width: 100,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: Color(0XFFF6F7F9),
                                                                                                  border: Border.all(
                                                                                                    color: Color(0XFF6F7F9),
                                                                                                  ),
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                ),
                                                                                                child: TextFormField(
                                                                                                  controller: _wowCoupon,
                                                                                                  validator: (value) {
                                                                                                    if (value!.isEmpty) {
                                                                                                      return 'Please enter coupon code';
                                                                                                    }
                                                                                                  },
                                                                                                  onChanged: (value) {
                                                                                                    setState(() {
                                                                                                      // Trigger a rebuild when the text in _wowCoupon changes
                                                                                                    });
                                                                                                  },
                                                                                                  textCapitalization: TextCapitalization.characters,
                                                                                                  // Capitalize the text to uppercase
                                                                                                  decoration: InputDecoration(
                                                                                                    suffixIcon: IconButton(
                                                                                                      onPressed: () {
                                                                                                        setState(() {
                                                                                                          _wowCoupon.clear(); // Clear the text in _wowCoupon controller
                                                                                                        });
                                                                                                      },
                                                                                                      icon: Icon(Icons.clear),
                                                                                                    ),
                                                                                                    border: OutlineInputBorder(
                                                                                                      borderRadius: BorderRadius.circular(8),
                                                                                                      borderSide: BorderSide(
                                                                                                        style: BorderStyle.none,
                                                                                                      ),
                                                                                                    ),
                                                                                                    hintStyle: TextStyle(
                                                                                                      fontFamily: 'Work Sans',
                                                                                                      fontSize: 14,
                                                                                                      color: Color(0xff6C757D),
                                                                                                    ),
                                                                                                    hintText: "Enter Coupon Code",
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              margin: EdgeInsets.all(5),
                                                                                              child: ElevatedButton(
                                                                                                style: ElevatedButton.styleFrom(
                                                                                                  backgroundColor: Color(0Xff5F60B9),
                                                                                                  shape: RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                                  ),
                                                                                                  // Background color
                                                                                                ),
                                                                                                onPressed: _wowCoupon.text != null && _wowCoupon.text.isNotEmpty // Check if _wowCoupon.text is not empty
                                                                                                    ? () async {
                                                                                                        ValidateCouponRequest couponRequest = ValidateCouponRequest();
                                                                                                        couponRequest.couponCode = _wowCoupon.text;

                                                                                                        try {
                                                                                                          ValidateCouponResponse resp;
                                                                                                          if (_wowCoupon.text.toUpperCase().startsWith("WOW")) {
                                                                                                            resp = await ref.read(couponProvider).validateWowCoupon(_wowCoupon.text.toUpperCase(), widget.serviceName!);
                                                                                                          } else {
                                                                                                            resp = await ref.read(couponProvider).validateReferralCoupon(_wowCoupon.text.toUpperCase(), widget.serviceName!);
                                                                                                          }

                                                                                                          if (resp != null) {
                                                                                                            print(resp);

                                                                                                            WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                                                                                                                  print("hello");
                                                                                                                  print(discountRate);
                                                                                                                  print(resp.message);
                                                                                                                  print("hello");
                                                                                                                  discountRate = resp.discountRate;
                                                                                                                  apply_coupon = _wowCoupon.text.toUpperCase();
                                                                                                                }));
                                                                                                            setState(() {
                                                                                                              print("hello");
                                                                                                              print(discountRate);
                                                                                                              print(resp.message);
                                                                                                              print("hello");
                                                                                                              discountRate = resp.discountRate;
                                                                                                              // apply_coupon = "Applied";
                                                                                                              apply_coupon = _wowCoupon.text.toUpperCase();
                                                                                                            });

                                                                                                            // Navigator.pop(context, resp);
                                                                                                            Navigator.of(context).pop(resp);
                                                                                                          }
                                                                                                        } catch (e) {
                                                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                                                            SnackBar(content: Text('${_wowCoupon.text} is invalid coupon')),
                                                                                                          );
                                                                                                          Navigator.of(context).pop();
                                                                                                        }
                                                                                                      }
                                                                                                    : null,
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.all(15.0),
                                                                                                  child: Text(
                                                                                                    "APPLY",
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.white,
                                                                                                      fontSize: 16,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Align(
                                                                                          alignment: Alignment.topLeft,
                                                                                          child: Text(
                                                                                            "Available Coupons",
                                                                                            style: TextStyle(fontFamily: 'Work Sans', fontSize: 16),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  coupons.length > 0
                                                                                      ? Container(
                                                                                          child: ListView.separated(
                                                                                            physics: NeverScrollableScrollPhysics(),
                                                                                            shrinkWrap: true,
                                                                                            itemCount: coupons.length,
                                                                                            itemBuilder: (context, index) {
                                                                                              return Container(
                                                                                                width: double.infinity,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: Color(0XFFF6F7F9),
                                                                                                  border: Border.all(
                                                                                                    color: Color(0XFF6F7F9),
                                                                                                  ),
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                ),
                                                                                                child: Container(
                                                                                                  width: double.infinity,
                                                                                                  padding: EdgeInsets.all(20),
                                                                                                  child: Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            "COUPON:",
                                                                                                            style: TextStyle(fontFamily: 'Work Sans', color: primaryColor),
                                                                                                          ),
                                                                                                          SizedBox(
                                                                                                            width: 10,
                                                                                                          ),
                                                                                                          Text(coupons![index].couponCode)
                                                                                                        ],
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: 10,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        "Avail ${coupons[0].discountRate}% discount on total amount of your order",
                                                                                                        style: TextStyle(fontFamily: 'Work Sans', fontSize: 14, color: Colors.green, fontWeight: FontWeight.w800),
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: 30,
                                                                                                      ),
                                                                                                      Row(
                                                                                                        children: [
                                                                                                          Text("Expiry Date: "),
                                                                                                          Text(DateFormat('dd MMM yyyy').format(DateTime.parse(coupons[0].expiryTime)))
                                                                                                        ],
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              );
                                                                                            },
                                                                                            separatorBuilder: (context, index) => SizedBox(
                                                                                              height: 10,
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                      : Container(
                                                                                          width: double.infinity,
                                                                                          decoration: BoxDecoration(
                                                                                            color: Color(0XFFF6F7F9),
                                                                                            border: Border.all(
                                                                                              color: Color(0XFF6F7F9),
                                                                                            ),
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                          child: Container(
                                                                                            width: double.infinity,
                                                                                            padding: EdgeInsets.all(20),
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              children: [
                                                                                                Row(
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      "COUPON: ",
                                                                                                      style: TextStyle(fontFamily: 'Work Sans', color: primaryColor),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      "No Coupon found for this service type ",
                                                                                                      style: TextStyle(fontFamily: 'Work Sans', color: Colors.redAccent),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                        error: (err,
                                                                                s) =>
                                                                            Text(err.toString()),
                                                                        loading:
                                                                            () =>
                                                                                Center(
                                                                          child:
                                                                              CircularProgressIndicator(),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                                },
                                                              );
                                                              setState(() {});
                                                            } else {
                                                              setState(() {});
                                                            }
                                                          },
                                                          child: Text(
                                                            apply_coupon,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Work Sans',
                                                                fontSize: 14,
                                                                color:
                                                                    primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                          ),
                                                        ),
                                                        apply_coupon !=
                                                                "Apply Coupon"
                                                            ? Container(
                                                                child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    apply_coupon =
                                                                        "Apply Coupon";
                                                                    discountRate =
                                                                        0;
                                                                  });
                                                                },
                                                                child: Icon(
                                                                  Icons.clear,
                                                                ),
                                                              ))
                                                            : Container()
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              widget.serviceName!
                                                      .contains("AC Repair")
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: const [
                                                        Text(
                                                            "AC Repair Visiting Charge"),
                                                        Text(
                                                            "\u{20B9} ${AC_REPAIR_CHARGES}"),
                                                      ],
                                                    )
                                                  : Container(),
                                              const SizedBox(height: 8),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.spaceBetween,
                                              //   children: [
                                              //     const Text("GST (18%)"),
                                              //     Text(
                                              //         "\u{20B9}${(double.parse(_data[0].grossAmount) * 0.18).toStringAsFixed(2)}",
                                              //         style: const TextStyle(
                                              //             fontWeight: FontWeight.bold,
                                              //             color: primaryColor))
                                              //
                                              //     // Text("\u{20B9}${(totalAmount * 0.18).toStringAsFixed(2)}")
                                              //   ],
                                              // ),
                                              const SizedBox(height: 8),
                                              const Divider(
                                                  color: primaryColor),
                                              const SizedBox(height: 8),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    "Total Amount",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  widget.serviceName!
                                                          .contains("AC Repair")
                                                      ? Text(
                                                          "\u{20B9}${(double.parse(totalAmount.toStringAsFixed(2)) + AC_REPAIR_CHARGES - (totalAmount * discountRate / 100)).toStringAsFixed(2)}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  primaryColor))
                                                      : Text(
                                                          "\u{20B9}${double.parse(totalAmount.toStringAsFixed(2)) - (double.parse(totalAmount.toStringAsFixed(2)) * discountRate / 100)}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  primaryColor))
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              error: (err, s) => Text(err.toString()),
                              loading: () => Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.list),
      //   onPressed: switchStepsType,
      // ),
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step, FormState formKey) {
    formkey.currentState!.validate();
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
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

showConfirmBookDialog(context, confirmation, isApiCallProcess) {
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
                          isApiCallProcess
                              ? ElevatedButton(
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
                                )
                              : Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                            style:
                                                TextStyle(color: Colors.white),
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
