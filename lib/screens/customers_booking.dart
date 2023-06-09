import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mistry_customer/components/booking_item.dart';
import 'package:mistry_customer/model/customer_booking_response.dart';
import 'package:mistry_customer/model/update_booking_request.dart';
import 'package:mistry_customer/provider/data_provider.dart';
import 'package:mistry_customer/screens/laundry_generate_bill.dart';
import 'package:mistry_customer/utils/config.dart';
import 'package:mistry_customer/utils/images.dart';

import '../services/shared_service.dart';
import 'auth/landing_screen.dart';
import 'dashboard_screen.dart';

class CustomerBookings extends ConsumerStatefulWidget {
  const CustomerBookings({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomerBookings> createState() => _CustomerBookingsState();
}

class _CustomerBookingsState extends ConsumerState<CustomerBookings> {
  var isLoggedIn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    whereToGo();
    initializeLoginStatus();
  }

  Future<void> initializeLoginStatus() async {
    bool loginStatus = await isUserLoggedInd();
    setState(() {
      isLoggedIn = loginStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn != null && isLoggedIn) {
      final _data = ref.watch(bookingServiceDataProvider);
      BookingStatusUpdateRequest bookingStatus = BookingStatusUpdateRequest();
      return RefreshIndicator(
        onRefresh: () async {
          ref.refresh(bookingServiceDataProvider);
        },
        child: Container(
          child: _data.when(
            data: (_data) {
              List<CustomerBookingResponse> bookings =
                  _data.map((e) => e).toList();
              print(bookings.length);
              return (bookings.length > 0)
                  ? Column(
                      children: [
                        Container(
                            child: Expanded(
                          child: ListView.builder(
                              itemCount: bookings.length,
                              itemBuilder: (context, index) {
                                if (bookings[index].status == "New") {
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: ReusableCard(
                                      cardChild: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Color(
                                                              0XFFF6F7F9)),
                                                      shape: BoxShape.circle,
                                                      color: Color(0XFFF6F7F9)),
                                                  child: buildImageIcon(
                                                      bookings[index]
                                                          .serviceLists[0]
                                                          .name),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 20),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 2,
                                                                  ),
                                                                  color: Colors
                                                                      .orangeAccent
                                                                      .withOpacity(
                                                                          0.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    bookings[index].status ==
                                                                            "New"
                                                                        ? "Pending"
                                                                        : "",
                                                                    style: TextStyle(
                                                                        color: Colors.orange[
                                                                            800],
                                                                        fontFamily:
                                                                            'Work Sans',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
// margin: EdgeInsets.all(10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    // Container(
                                                                    //   child:
                                                                    //       ImageIcon(
                                                                    //     AssetImage(
                                                                    //         ic_edit),
                                                                    //   ),
                                                                    // ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      '#${bookings[index].bookingId.toString()}',
                                                                      style: TextStyle(
                                                                          color:
                                                                              primaryColor,
                                                                          fontFamily:
                                                                              'Work Sans',
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                bookings[index]
                                                                    .serviceLists[
                                                                        0]
                                                                    .name,
                                                                style: TextStyle(
                                                                    color:
                                                                        primaryColor,
                                                                    fontFamily:
                                                                        'Work Sans',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0XFFF6F7F9),
                                                  border: Border.all(
                                                    color: Color(0XFF6F7F9),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                              child: Text(
                                                                  "Date and Time :")),
                                                          Expanded(
                                                            child: FittedBox(
                                                              child: Text(bookings[
                                                                      index]
                                                                  .bookingTime),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Divider(
                                                        height: 2,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("Provider"),
                                                          Text(bookings[index]
                                                              .providerName[0]),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 2,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) {
                                                                return LaundryGenerateBillScreen(
                                                                    booking:
                                                                        bookings[
                                                                            index],
                                                                    serviceName: bookings[
                                                                            index]
                                                                        .serviceLists[
                                                                            0]
                                                                        .name,
                                                                    providername:
                                                                        bookings[index]
                                                                            .providerName[0]);
                                                              }));
                                                            },
                                                            child: Text(
                                                              "ORDER PREVIEW",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Work Sans',
                                                                  color:
                                                                      primaryColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0XffF6F7F9),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                                  // Background color
                                                ),
                                                onPressed: () {
                                                  showDeclineFunc(context, () {
                                                    bookingStatus.status =
                                                        "Rejected";
                                                    var bookingOrderProvider_response = ref
                                                        .read(
                                                            bookingOrderProvider)
                                                        .updateBookingStatus(
                                                            bookingStatus,
                                                            bookings[index]
                                                                .bookingId
                                                                .toString());
                                                    if (bookingOrderProvider_response !=
                                                        null) {
                                                      ref.invalidate(
                                                          bookingServiceDataProvider);
                                                      Navigator
                                                          .pushNamedAndRemoveUntil(
                                                        context,
                                                        '/bookings',
                                                            (route) => false,
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'Something went wrong!')),
                                                      );
                                                    }
                                                  });
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(15.0),
                                                  child: Text(
                                                    "CANCEL",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff1C1F34),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "Work Sans"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                width: double.infinity,
                                                child: Column(
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
                                                      "You will asked for payment once your booking is completed by us!",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Work Sans',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xff6C757D),
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (bookings[index].status ==
                                        "Accepted" ||
                                    bookings[index].status == "Completed" ||
                                    bookings[index].status == "Done") {
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: ReusableCard(
                                      cardChild: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Color(
                                                              0XFFF6F7F9)),
                                                      shape: BoxShape.circle,
                                                      color: Color(0XFFF6F7F9)),
                                                  child: buildImageIcon(
                                                      bookings[index]
                                                          .serviceLists[0]
                                                          .name),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 20),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 2,
                                                                  ),
                                                                  color: Colors
                                                                      .greenAccent
                                                                      .withOpacity(
                                                                          0.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    bookings[
                                                                            index]
                                                                        .status,
                                                                    style: TextStyle(
                                                                        color: Colors.green[
                                                                            800],
                                                                        fontFamily:
                                                                            'Work Sans',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
// margin: EdgeInsets.all(10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    // Container(
                                                                    //   child:
                                                                    //       ImageIcon(
                                                                    //     AssetImage(
                                                                    //         ic_edit),
                                                                    //   ),
                                                                    // ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      '#${bookings[index].bookingId.toString()}',
                                                                      style: TextStyle(
                                                                          color:
                                                                              primaryColor,
                                                                          fontFamily:
                                                                              'Work Sans',
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                bookings[index]
                                                                    .serviceLists[
                                                                        0]
                                                                    .name,
                                                                style: TextStyle(
                                                                    color:
                                                                        primaryColor,
                                                                    fontFamily:
                                                                        'Work Sans',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0XFFF6F7F9),
                                                  border: Border.all(
                                                    color: Color(0XFF6F7F9),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                                "Date and Time :"),
                                                          ),
                                                          Expanded(
                                                            child: FittedBox(
                                                              child: Text(bookings[
                                                                      index]
                                                                  .bookingTime),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Divider(
                                                        height: 2,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("Provider"),
                                                          Text(bookings[index]
                                                              .providerName[0]),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 2,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Payment Status"),
                                                          bookings[index]
                                                                      .status ==
                                                                  'Done'
                                                              ? Text(
                                                                  'Paid',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontFamily:
                                                                          'Work Sans'),
                                                                )
                                                              : Text("Pending"),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 2,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) {
                                                                return LaundryGenerateBillScreen(
                                                                    booking:
                                                                        bookings[
                                                                            index],
                                                                    serviceName: bookings[
                                                                            index]
                                                                        .serviceLists[
                                                                            0]
                                                                        .name,
                                                                    providername:
                                                                        bookings[index]
                                                                            .providerName[0]);
                                                              }));
                                                            },
                                                            child: Text(
                                                              "ORDER PREVIEW",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Work Sans',
                                                                  color:
                                                                      primaryColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (bookings[index].status ==
                                    "Rejected") {
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: ReusableCard(
                                      cardChild: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Color(
                                                              0XFFF6F7F9)),
                                                      shape: BoxShape.circle,
                                                      color: Color(0XFFF6F7F9)),
                                                  child: buildImageIcon(
                                                      bookings[index]
                                                          .serviceLists[0]
                                                          .name),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 20),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 2,
                                                                  ),
                                                                  color: Colors
                                                                      .redAccent
                                                                      .withOpacity(
                                                                          0.5),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    bookings[
                                                                            index]
                                                                        .status,
                                                                    style: TextStyle(
                                                                        color: Colors.red[
                                                                            800],
                                                                        fontFamily:
                                                                            'Work Sans',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    // Container(
                                                                    //   child:
                                                                    //       ImageIcon(
                                                                    //     AssetImage(
                                                                    //         ic_edit),
                                                                    //   ),
                                                                    // ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      '#${bookings[index].bookingId.toString()}',
                                                                      style: TextStyle(
                                                                          color:
                                                                              primaryColor,
                                                                          fontFamily:
                                                                              'Work Sans',
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                bookings[index]
                                                                    .serviceLists[
                                                                        0]
                                                                    .name,
                                                                style: TextStyle(
                                                                    color:
                                                                        primaryColor,
                                                                    fontFamily:
                                                                        'Work Sans',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0XFFF6F7F9),
                                                  border: Border.all(
                                                    color: Color(0XFF6F7F9),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Date and Time :"),
                                                          Expanded(
                                                            child: FittedBox(
                                                              child: Text(bookings[
                                                                      index]
                                                                  .bookingTime),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Divider(
                                                        height: 2,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("Provider"),
                                                          Text(bookings[index]
                                                              .providerName[0]),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 2,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) {
                                                                return LaundryGenerateBillScreen(
                                                                    booking:
                                                                        bookings[
                                                                            index],
                                                                    serviceName: bookings[
                                                                            index]
                                                                        .serviceLists[
                                                                            0]
                                                                        .name,
                                                                    providername:
                                                                        bookings[index]
                                                                            .providerName[0]);
                                                              }));
                                                            },
                                                            child: Text(
                                                              "ORDER PREVIEW",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Work Sans',
                                                                  color:
                                                                      primaryColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              width: double.infinity,
                                              child: Column(
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
                                                    "You will asked for payment once your booking is completed by us!",
                                                    style: TextStyle(
                                                        fontFamily: 'Work Sans',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff6C757D),
                                                        fontSize: 12),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }),
                        ))
                      ],
                    )
                  : Center(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 100.0, right: 100),
                              child: Image(
                                image: AssetImage(no_data_found),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("No Booking Found"),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Looks like you haven't tried our service",
                            ),
                            Text(
                              "yet!",
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
      );
    } else {
      return Center(
        child: Container(
          margin: EdgeInsets.all(20),
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF0F0FA),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              // Background color
            ),
            onPressed: () async {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/sigin',
                (route) => true,
              );
            },
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageIcon(AssetImage(calling)),
                  Container(
                    margin: EdgeInsets.only(right: 100),
                    child: Text(
                      "Please sign in",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Work Sans',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget buildImageIcon(serviceType) {
    if (serviceType == 'Washing') {
      return Image.asset(
        ic_laundry_washing,
        width: 50,
        height: 50,
      );
    } else if (serviceType == 'Ironing') {
      return Image.asset(
        ic_ironing,
        width: 50,
        height: 50,
      );
    } else if (serviceType == "Dry Cleaning") {
      return Image.asset(
        ic_dry_cleaning,
        width: 50,
        height: 50,
      );
    } else if (serviceType == "Washing+Ironing") {
      return Image.asset(
        ic_laundry_washing_iron,
        width: 50,
        height: 50,
      );
    } else if (serviceType == "AC Clean Service(window)") {
      return Image.asset(
        ic_ac_window_clean,
        width: 50,
        height: 50,
      );
    } else if (serviceType == "AC Clean Service(split)") {
      return Image.asset(
        ic_ac_split_clean,
        width: 50,
        height: 50,
      );
    } else if (serviceType == "AC Repair(Split/window)") {
      return Image.asset(
        ic_ac_split_repair,
        width: 50,
        height: 50,
      );
    } else {
      return Image.asset(
        ic_ac_split_repair,
        width: 50,
        height: 50,
      );
    }
  }

  Future<bool> isUserLoggedInd() async {
    var isLoggedIn = await SharedService.isLoggedIn();

    return isLoggedIn;
  }

  Future<void> whereToGo() async {
    var isLoggedIn = await SharedService.isLoggedIn();
    // var isLoggedIn = false;
    if (isLoggedIn != null) {
      if (isLoggedIn) {
        // Navigator.pop(context); // Navigate back to previous screen
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LandingScreen(),
          ),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LandingScreen(),
        ),
      );
    }
  }
}

showDeclineFunc(context, confirmDecline) {
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
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.4),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ImageIcon(AssetImage(pricing_plan_reject)),
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
                            child: Text(
                              "Are you sure to cancel this request? ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0Xff5F60B9),
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
                                      "NO",
                                      style: TextStyle(color: Colors.white),
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
                                  onPressed: confirmDecline,
                                  child: const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text(
                                      "YES",
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
