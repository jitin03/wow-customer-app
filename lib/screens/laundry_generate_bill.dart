import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mistry_customer/model/create_booking_order.dart';
import 'package:mistry_customer/model/customer_coupons_response.dart';
import 'package:mistry_customer/model/customer_review_request.dart';
import 'package:mistry_customer/model/notification_response.dart';
import 'package:mistry_customer/model/update_booking_request.dart';
import 'package:mistry_customer/model/validate_wow_coupon_request.dart';
import 'package:mistry_customer/model/validate_wow_coupon_response.dart';
import 'package:mistry_customer/provider/data_provider.dart';
import 'package:mistry_customer/services/coupons_service.dart';
import 'package:mistry_customer/utils/config.dart';
import 'package:mistry_customer/utils/images.dart';

import '../api/cferrorresponse/cferrorresponse.dart';
import '../api/cfpayment/cfdropcheckoutpayment.dart';
import '../api/cfpaymentcomponents/cfpaymentcomponent.dart';
import '../api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import '../api/cfsession/cfsession.dart';
import '../api/cftheme/cftheme.dart';
import '../model/customer_booking_response.dart';
import '../utils/cfenums.dart';
import '../utils/cfexceptions.dart';

enum PaymentOptions { Cash_only, online }

class LaundryGenerateBillScreen extends ConsumerStatefulWidget {
  final CustomerBookingResponse booking;
  final String serviceName;
  final String providername;

  const LaundryGenerateBillScreen(
      {super.key,
      required this.booking,
      required this.serviceName,
      required this.providername});

  @override
  ConsumerState<LaundryGenerateBillScreen> createState() =>
      _GenerateBillScreenState();
}

class _GenerateBillScreenState
    extends ConsumerState<LaundryGenerateBillScreen> {
  int value = 0;
  int discountRate = 0;
  String apply_coupon = "Apply Coupon";
  bool isSelect_OnlinePaymentSelected = false;
  bool isSelect_CashOnly = false;
  bool isSelect_UPIOnly = false;
  bool isApiCallProcess = false;
  PaymentOptions? _character = PaymentOptions.Cash_only;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  static final ValueNotifier<List<int>> quantity = ValueNotifier([0]);
  var cfPaymentGatewayService = CFPaymentGatewayService();

  void initState() {
    super.initState();
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
  }

  @override
  Widget build(BuildContext context) {
    int indexOfServiceName = -1;

    final _billing_data = ref
        .watch(bookingDetailDataProvider(widget.booking.bookingId.toString()));
    var _notifications = ref.watch(
        providerNotificationDataProvider(widget.booking.bookingId.toString()));

    var customerCoupons = ref.watch(providerCustomerCouponProvider(widget.serviceName));

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
        title: Text("Booking details",
            style: TextStyle(

                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.white)),
        actions: <Widget>[
          InkWell(
            onTap: () async {
              ref.invalidate(providerNotificationDataProvider);
              _bottomSheetMore(
                  context, widget.booking.bookingId.toString(), ref);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                'Check Status',
                style: TextStyle(
                    fontFamily: 'Work Sans',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
          ),
        ],
        backgroundColor: primaryColor,
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: "Work Sans",
            fontSize: 18,
            fontWeight: FontWeight.w800),
      ),
      body: _billing_data.when(
        data: (_data) {
          if (_data!.length > 0) {
            for (int i = 0; i < _data[0].serviceLists!.length; i++) {
              if (_data[0].serviceLists![i].name == widget.serviceName) {
                indexOfServiceName = i;
                break;
              }
            }
          }
          return Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 25, right: 25),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Booking ID",
                              style: TextStyle(
                                  fontFamily: 'Work Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          Text('#' + widget.booking.bookingId.toString(),
                              style: TextStyle(
                                  fontFamily: 'Work Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(height: 2, thickness: 2),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("About Provider",
                                style: TextStyle(
                                    fontFamily: 'Work Sans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0XFFF6F7F9),
                                border: Border.all(
                                  color: Color(0XFF6F7F9),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.only(top: 20, bottom: 20),
                              padding:
                                  const EdgeInsets.fromLTRB(10, 20, 40, 20),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: primaryColor),
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: primaryColor),
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: ClipOval(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Ink.image(
                                            image: AssetImage(
                                                male_default_profile_iamge),
                                            fit: BoxFit.cover,
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    child: Text(
                                      widget.providername,
                                      style: TextStyle(
                                          fontFamily: 'Work Sans',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Order Details",
                          style: TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 5,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor),
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4))),
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount:
                              _data[0].serviceLists![0].subCategories!.length,
                          itemBuilder: (context, index) {
                            return Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Expanded(
                                      child: Text(
                                        softWrap: true,
                                        _data[0]
                                                .serviceLists[
                                                    indexOfServiceName]
                                                .subCategories[index]
                                                .name +
                                            ' (${_data[0].serviceLists![indexOfServiceName].subCategories![index].price} per piece)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Work Sans',
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      softWrap: true,
                                      '(\u{20B9} ${_data[0].serviceLists![indexOfServiceName].subCategories![index].price.toString()!} * ${_data[0].serviceLists![indexOfServiceName].subCategories![index].count})',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'Work Sans',
                                          color: primaryColor,
                                          fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Text(
                                      softWrap: true,
                                      '\u{20B9}' +
                                          (_data[0]
                                                      .serviceLists![
                                                          indexOfServiceName]
                                                      .subCategories![index]
                                                      .price! *
                                                  double.parse(_data[0]
                                                      .serviceLists![
                                                          indexOfServiceName]
                                                      .subCategories![index]
                                                      .count!))
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Work Sans',
                                          color: Color(0Xff6C757D),
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      ),
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Text("Items (${cartList.length})"),
                                // Text("\$${totalAmount.toStringAsFixed(2)}"),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("Shipping"),
                                Text("\u{20B9}00.00"),
                              ],
                            ),
                            const Divider(color: primaryColor),

                            (discountRate != null)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Discount '),
                                          Text(
                                            '(${_data[0].discountRate}% off)',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontFamily: 'Work Sans',
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Text(
                                          "- \u{20B9}${_data[0].discountPrice.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Work Sans',
                                              color: Colors.green))
                                    ],
                                  )
                                : Container(),
                            const Divider(color: primaryColor),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        _data[0].couponCode,
                                        style: TextStyle(
                                            fontFamily: 'Work Sans',
                                            fontSize: 14,
                                            color: primaryColor,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            widget.serviceName.contains("AC Repair")
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text("AC Repair Visiting Charge"),
                                      Text("\u{20B9} ${AC_REPAIR_CHARGES}"),
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
                            const Divider(color: primaryColor),
                            const SizedBox(height: 8),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Amount",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                widget.serviceName.contains("AC Repair")
                                    ? Text(
                                        "\u{20B9}${(double.parse(_data[0].grossAmount) + AC_REPAIR_CHARGES - (double.parse(_data[0].grossAmount) * discountRate / 100)).toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor))
                                    : Text(
                                        "\u{20B9}${(double.parse(_data[0].grossAmount!)) - (double.parse(_data[0].grossAmount) * discountRate / 100)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor))
                              ],
                            ),
                            const SizedBox(height: 8),
                            (_data[0].paymentStatus == 'Paid')
                                ? Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          color: Colors.greenAccent
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20),
                                          child: Text(
                                            _data[0].paymentStatus!,
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontFamily: 'Work Sans',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showReviewDialog(
                                              context,
                                              widget.booking.bookingId
                                                  .toString(),
                                              ref,
                                              _data[0].providerId[0],
                                              _data[0].customerId[0]);
                                        },
                                        child: Text(
                                          "Write Review",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Work Sans'),
                                        ),
                                      )
                                    ],
                                  )
                                : Container()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              (_data!.length > 0 && _data[0].paymentStatus != 'Paid')
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 10),
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0Xff5F60B9),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          onPressed: _data!.length > 0
                              ? () async {
                                  return showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (builder) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return SingleChildScrollView(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2,
                                            decoration: BoxDecoration(
                                              // color: Color(0xFFF0F0FA),  //
                                              color: Color(0xFFF0F0FA),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 20),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            if (isSelect_CashOnly ==
                                                                false) {
                                                              isSelect_CashOnly =
                                                                  true;
                                                              isSelect_OnlinePaymentSelected =
                                                                  false;
                                                              isSelect_UPIOnly =
                                                                  false;
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 10),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20 /
                                                                              4),
                                                              color: Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                            .grey[
                                                                        200]!,
                                                                    blurRadius:
                                                                        5,
                                                                    spreadRadius:
                                                                        1)
                                                              ]),
                                                          child: ListTile(
                                                            // leading: Radio<PaymentOptions>(
                                                            //   value: PaymentOptions.Cash_only,
                                                            //   groupValue: _character,
                                                            //   onChanged: (PaymentOptions? value) {
                                                            //     setState(() {
                                                            //       _character = value;
                                                            //     });
                                                            //   },
                                                            // ),
                                                            title: Text(
                                                              "Cash only",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Work Sans',
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            subtitle: Text(
                                                              'you pay after task is completed',
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Work Sans',
                                                                color: Theme.of(
                                                                        context)
                                                                    .disabledColor,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            trailing:
                                                                isSelect_CashOnly
                                                                    ? Icon(
                                                                        Icons
                                                                            .check_circle,
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                      )
                                                                    : null,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: null,
                                                        //     () {
                                                        //   setState(() {
                                                        //     if (isSelect_OnlinePaymentSelected ==
                                                        //         false) {
                                                        //       isSelect_OnlinePaymentSelected =
                                                        //           true;
                                                        //       isSelect_CashOnly =
                                                        //           false;
                                                        //       isSelect_UPIOnly =
                                                        //       false;
                                                        //     }
                                                        //   });
                                                        // },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 10),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20 /
                                                                              4),
                                                              color: Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                            .grey[
                                                                        200]!,
                                                                    blurRadius:
                                                                        5,
                                                                    spreadRadius:
                                                                        1)
                                                              ]),
                                                          child: ListTile(
                                                            // leading: Radio<PaymentOptions>(
                                                            //   value: PaymentOptions.online,
                                                            //   groupValue: _character,
                                                            //   onChanged: (PaymentOptions? value) {
                                                            //     setState(() {
                                                            //       _character = value;
                                                            //     });
                                                            //   },
                                                            // ),
                                                            title: Text(
                                                              'Pay online',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Work Sans',
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            subtitle: Text(
                                                              'safest and quickest way',
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Work Sans',
                                                                color: Theme.of(
                                                                        context)
                                                                    .disabledColor,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            trailing:
                                                                isSelect_OnlinePaymentSelected
                                                                    ? Icon(
                                                                        Icons
                                                                            .check_circle,
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                      )
                                                                    : null,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          "Disclaimer:",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Work Sans',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                      Text(
                                                        "Please choose COD as of now, soon we will enable online payment!",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Work Sans',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xff6C757D),
                                                            fontSize: 12),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Color(0Xff5F60B9),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0)),
                                                      // Background color
                                                    ),
                                                    onPressed: () async {
                                                      CustomerDetails
                                                          customerDetails =
                                                          CustomerDetails();
                                                      // customerDetails
                                                      //         .customerId =
                                                      //     _data[0]
                                                      //         .customerId[0];
                                                      customerDetails
                                                              .customerEmail =
                                                          _data[0]!
                                                              .customerEmail[0];
                                                      customerDetails
                                                              .customerPhone =
                                                          '+${_data[0].customerPhoneNo[0].toString()}';
                                                      CreateBookingOrder
                                                          bookingOrder =
                                                          CreateBookingOrder();
                                                      bookingOrder.orderAmount =
                                                          double.parse(_data[0]
                                                              .grossAmount);
                                                      bookingOrder
                                                              .orderCurrency =
                                                          'INR';
                                                      bookingOrder
                                                              .customerDetails =
                                                          customerDetails;
                                                      bookingOrder
                                                          .orderNote = _data[
                                                              0]
                                                          .serviceLists[
                                                              indexOfServiceName]
                                                          .name;

                                                      if (isSelect_OnlinePaymentSelected) {
                                                        setState(() {
                                                          isApiCallProcess =
                                                              true;
                                                        });

                                                        var response = await ref
                                                            .read(
                                                                bookingOrderProvider)
                                                            .createBookingOrder(
                                                                bookingOrder);

                                                        Navigator.pop(context);
                                                        String orderId =
                                                            response!.orderId
                                                                .toString();
                                                        String
                                                            paymentSessionId =
                                                            response
                                                                .paymentSessionId
                                                                .toString();
                                                        CFEnvironment
                                                            environment =
                                                            CFEnvironment
                                                                .SANDBOX;
                                                        try {
                                                          var session =
                                                              createSession(
                                                                  environment,
                                                                  orderId,
                                                                  paymentSessionId);
                                                          List<CFPaymentModes>
                                                              components =
                                                              <CFPaymentModes>[];
                                                          var paymentComponent =
                                                              CFPaymentComponentBuilder()
                                                                  .setComponents(
                                                                      components)
                                                                  .build();

                                                          var theme = CFThemeBuilder()
                                                              .setNavigationBarBackgroundColorColor(
                                                                  "#5F60B9")
                                                              .setPrimaryFont(
                                                                  "Menlo")
                                                              .setBackgroundColor(
                                                                  "#5F60B9")
                                                              .setSecondaryFont(
                                                                  "Futura")
                                                              .build();

                                                          var cfDropCheckoutPayment =
                                                              CFDropCheckoutPaymentBuilder()
                                                                  .setSession(
                                                                      session!)
                                                                  .setPaymentComponent(
                                                                      paymentComponent)
                                                                  .setTheme(
                                                                      theme)
                                                                  .build();

                                                          cfPaymentGatewayService
                                                              .doPayment(
                                                                  cfDropCheckoutPayment);
                                                          setState(() {
                                                            isApiCallProcess =
                                                                false;
                                                          });
                                                          BookingStatusUpdateRequest
                                                              updateRequest =
                                                              BookingStatusUpdateRequest(
                                                                  status:
                                                                      "Done");
                                                          var bookingOrderProvider_response = ref
                                                              .read(
                                                                  bookingOrderProvider)
                                                              .updateBookingStatus(
                                                                  updateRequest,
                                                                  widget.booking
                                                                      .bookingId
                                                                      .toString());

                                                          if (bookingOrderProvider_response !=
                                                              null) {
                                                            showConfirmBookDialog(
                                                                context,
                                                                widget.booking
                                                                    .bookingId
                                                                    .toString(),
                                                                ref,
                                                                _data[0].providerId[
                                                                    0],
                                                                _data[0]
                                                                    .customerId[0]);
                                                          }
                                                        } on CFException catch (e) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                                content: Text(
                                                                    'Something went wrong!')),
                                                          );
                                                        }
                                                      } else if (isSelect_UPIOnly) {
                                                        BookingPaymentUpdateRequest
                                                        updateRequest =
                                                        BookingPaymentUpdateRequest(
                                                            paymentMode:
                                                            "PAY VIA UPI");
                                                        var bookingOrderProvider_response = ref
                                                            .read(
                                                            bookingOrderProvider)
                                                            .updateBookingPaymentMode(
                                                            updateRequest,
                                                            widget
                                                                .booking
                                                                .bookingId
                                                                .toString());
                                                        if(bookingOrderProvider_response !=null){

                                                          Navigator.pushNamedAndRemoveUntil(
                                                            context,
                                                            '/bookings',
                                                                (route) => false,
                                                          );
                                                        }else{
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                                content: Text(
                                                                    'Something went wrong!')),
                                                          );
                                                          Navigator.pushNamedAndRemoveUntil(
                                                            context,
                                                            '/bookings',
                                                                (route) => false,
                                                          );
                                                        }
                                                      } else {
                                                        BookingPaymentUpdateRequest
                                                            updateRequest =
                                                            BookingPaymentUpdateRequest(
                                                                paymentMode:
                                                                    "Cash");
                                                        var bookingOrderProvider_response = ref
                                                            .read(
                                                                bookingOrderProvider)
                                                            .updateBookingPaymentMode(
                                                                updateRequest,
                                                                widget.booking
                                                                    .bookingId
                                                                    .toString());
                                                        if (bookingOrderProvider_response !=
                                                            null) {
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
                                                          Navigator
                                                              .pushNamedAndRemoveUntil(
                                                            context,
                                                            '/bookings',
                                                            (route) => false,
                                                          );
                                                        }
                                                      }
                                                    },
                                                    child: isApiCallProcess
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "Loading...",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Work Sans',
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Transform.scale(
                                                                scale: 0.5,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white,
                                                                  strokeWidth:
                                                                      2,
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        : const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15.0),
                                                            child: Text(
                                                              "PROCEED",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                  );
                                }
                              : null,
                          child: const Text(
                            'PAY NOW',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Work Sans'),
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          );
        },
        error: (err, s) => Text(err.toString()),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

CFSession? createSession(environment, orderId, paymentSessionId) {
  try {
    var session = CFSessionBuilder()
        .setEnvironment(environment)
        .setOrderId(orderId)
        .setPaymentSessionId(paymentSessionId)
        .build();
    return session;
  } on CFException catch (e) {}
  return null;
}

void verifyPayment(String orderId) {
  print("Verify Payment");
}

void onError(CFErrorResponse errorResponse, String orderId) {
  print(errorResponse.getMessage());
  print("Error while making payment");
}

showConfirmBookDialog(BuildContext context, String bookingId, WidgetRef ref,
    String providerId, String customerId) {
  return showDialog(
    barrierDismissible: false,
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
            height: 400,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                    child: ImageIcon(
                      AssetImage(icon_check),
                      color: primaryColor,
                      size: 50,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Payment is successful",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Work Sans'),
                          ),
                          Expanded(
                            child: Text(
                              "for #${bookingId}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Work Sans'),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Please provide your valuable feeback",
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Work Sans'),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    showReviewDialog(
                                        context,
                                        bookingId.toString(),
                                        ref,
                                        providerId,
                                        customerId);
                                  },
                                  child: Text(
                                    "Write Review",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Work Sans'),
                                  ),
                                )
                              ],
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
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/dashboard',
                                      (route) => false,
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Back To Home",
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

// showCouponDialog(
//   BuildContext context,
//   String bookingId,
//   WidgetRef ref,
// ) {
//   late TextEditingController _reviewMessage = TextEditingController();
//   late TextEditingController _wowCoupon = TextEditingController();
//   // late TextEditingController _rating = TextEditingController();
//   CustomerReviewRequest customerReviewRequest = CustomerReviewRequest();
//   return showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (context) {
//       return Center(
//         child: Material(
//           type: MaterialType.transparency,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.white,
//             ),
//             // padding: EdgeInsets.all(15),
//             height: MediaQuery.of(context).size.height * 0.3,
//             width: MediaQuery.of(context).size.width * 0.7,
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.only(left: 20, right: 10),
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     color: primaryColor,
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10)),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Coupons",
//                         style: TextStyle(
//                             fontFamily: 'Work Sans',
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500),
//                       ),
//                       Container(
//                         alignment: FractionalOffset.topRight,
//                         child: IconButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(
//                             Icons.clear,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Color(0XFFF6F7F9),
//                           border: Border.all(
//                             color: Color(0XFF6F7F9),
//                           ),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: TextFormField(
//                           controller: _wowCoupon,
//                           maxLines: 1,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter coupon code';
//                             }
//                           },
//                           decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: BorderSide(
//                                   width: 0,
//                                   style: BorderStyle.none,
//                                 ),
//                               ),
//                               hintStyle: TextStyle(
//                                   fontFamily: 'Work Sans',
//                                   fontSize: 14,
//                                   color: Color(0xff6C757D)),
//                               hintText: "Enter Coupon Code:"),
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(top: 10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 // Background color
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: const Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Text(
//                                   "CANCEL",
//                                   style: TextStyle(color: Colors.black),
//                                 ),
//                               ),
//                             ),
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Color(0Xff5F60B9),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 // Background color
//                               ),
//                               onPressed: () async {
//                                 ValidateCouponRequest couponRequest =
//                                     ValidateCouponRequest();
//                                 couponRequest.couponCode = _wowCoupon.text;
//                                 var resp = await ref
//                                     .read(couponProvider)
//                                     .validateWowCoupon(_wowCoupon.text!,);
//
//                                 Navigator.of(context).pop(resp.discountRate);
//                               },
//                               child: const Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Text(
//                                   "SUBMIT",
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

// couponbottomSheet(BuildContext context, String bookingId, WidgetRef ref,String serviceName) {
//   var customerCoupons = ref.watch(providerCustomerCouponProvider(serviceName));
//   late TextEditingController _wowCoupon = TextEditingController();
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     enableDrag: true,
//     builder: (builder) {
//       return StatefulBuilder(builder: (context, setState) {
//         return Container(
//           width: 100,
//           height: MediaQuery.of(context).size.height * .8,
//           padding: EdgeInsets.only(
//             left: 5.0,
//             right: 5.0,
//             top: 5.0,
//             bottom: 5.0,
//           ),
//           decoration: new BoxDecoration(
//               color: Colors.white,
//               borderRadius: new BorderRadius.only(
//                   topLeft: const Radius.circular(10.0),
//                   topRight: const Radius.circular(10.0))),
//           child: customerCoupons.when(
//             data: (_data) {
//               List<WowCustomerCoupons> coupons = _data;
//
//               return Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.only(left: 20, right: 10),
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.rectangle,
//                       color: primaryColor,
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(10),
//                           topRight: Radius.circular(10)),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Coupons",
//                           style: TextStyle(
//                               fontFamily: 'Work Sans',
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         Container(
//                           alignment: FractionalOffset.topRight,
//                           child: IconButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             icon: const Icon(
//                               Icons.clear,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(20),
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 width: 100,
//                                 decoration: BoxDecoration(
//                                   color: Color(0XFFF6F7F9),
//                                   border: Border.all(
//                                     color: Color(0XFF6F7F9),
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: TextFormField(
//                                   controller: _wowCoupon,
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       return 'Please enter coupon code';
//                                     }
//                                   },
//                                   onChanged: (value) {
//                                     setState(() {
//                                       // Trigger a rebuild when the text in _wowCoupon changes
//                                     });
//                                   },
//                                   textCapitalization: TextCapitalization
//                                       .characters, // Capitalize the text to uppercase
//                                   decoration: InputDecoration(
//                                     suffixIcon: IconButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           _wowCoupon
//                                               .clear(); // Clear the text in _wowCoupon controller
//                                         });
//                                       },
//                                       icon: Icon(Icons.clear),
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                       borderSide: BorderSide(
//                                         style: BorderStyle.none,
//                                       ),
//                                     ),
//                                     hintStyle: TextStyle(
//                                       fontFamily: 'Work Sans',
//                                       fontSize: 14,
//                                       color: Color(0xff6C757D),
//                                     ),
//                                     hintText: "Enter Coupon Code",
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               margin: EdgeInsets.all(5),
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Color(0Xff5F60B9),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   // Background color
//                                 ),
//                                 onPressed: _wowCoupon.text != null &&
//                                         _wowCoupon.text
//                                             .isNotEmpty // Check if _wowCoupon.text is not empty
//                                     ? () async {
//                                         ValidateCouponRequest couponRequest =
//                                             ValidateCouponRequest();
//                                         couponRequest.couponCode =
//                                             _wowCoupon.text;
//                                         ValidateCouponResponse resp = await ref
//                                             .read(couponProvider)
//                                             .validateWowCoupon(
//                                                 _wowCoupon.text.toUpperCase());
//
//                                         if (resp != null) {
//                                           print(resp.discountRate);
//                                           setState(() {});
//                                           Navigator.pop(context, resp);
//                                         }
//                                       }
//                                     : null,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(15.0),
//                                   child: Text(
//                                     "APPLY",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Align(
//                                 alignment: Alignment.topLeft,
//                                 child: Text(
//                                   "Avaliable Coupons",
//                                   style: TextStyle(
//                                       fontFamily: 'Work Sans', fontSize: 16),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Container(
//                                 child: ListView.builder(
//                                   scrollDirection: Axis.vertical,
//                                   shrinkWrap: true,
//                                   itemCount: coupons.length,
//                                   itemBuilder: (context, index) {
//                                     return Container(
//                                       width: double.infinity,
//                                       decoration: BoxDecoration(
//                                         color: Color(0XFFF6F7F9),
//                                         border: Border.all(
//                                           color: Color(0XFF6F7F9),
//                                         ),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: Container(
//                                         width: double.infinity,
//                                         padding: EdgeInsets.all(20),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   "COUPON:",
//                                                   style: TextStyle(
//                                                       fontFamily: 'Work Sans',
//                                                       color: primaryColor),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 Text(coupons![index].couponCode)
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Text(
//                                               "Avail ${coupons[0].discountRate}% discount on total amount of your order",
//                                               style: TextStyle(
//                                                   fontFamily: 'Work Sans',
//                                                   fontSize: 14,
//                                                   color: Colors.green,
//                                                   fontWeight: FontWeight.w800),
//                                             ),
//                                             SizedBox(
//                                               height: 30,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text("Expiry Date: "),
//                                                 Text(DateFormat('dd MMM yyyy')
//                                                     .format(DateTime.parse(
//                                                         coupons[0].expiryTime)))
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               );
//             },
//             error: (err, s) => Text(err.toString()),
//             loading: () => Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),
//         );
//       });
//     },
//   );
// }

showReviewDialog(BuildContext context, String bookingId, WidgetRef ref,
    String providerId, String customerId) {
  late TextEditingController _reviewMessage = TextEditingController();
  // late TextEditingController _rating = TextEditingController();
  CustomerReviewRequest customerReviewRequest = CustomerReviewRequest();
  return showDialog(
    barrierDismissible: false,
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
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Review",
                        style: TextStyle(
                            fontFamily: 'Work Sans',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
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
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0XFFF6F7F9),
                          border: Border.all(
                            color: Color(0XFF6F7F9),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Your Rating:",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Work Sans',
                                    color: Color(0xff6C757D)),
                              ),
                            ),
                            Expanded(
                              child: FittedBox(
                                child: RatingBar(
                                    initialRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 5,
                                    ratingWidget: RatingWidget(
                                        full: const Icon(Icons.star,
                                            color: Colors.orange),
                                        half: const Icon(
                                          Icons.star_half,
                                          color: Colors.orange,
                                        ),
                                        empty: const Icon(
                                          Icons.star_outline,
                                          color: Colors.orange,
                                        )),
                                    onRatingUpdate: (value) {
                                      customerReviewRequest.rating =
                                          value.toString();
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0XFFF6F7F9),
                          border: Border.all(
                            color: Color(0XFF6F7F9),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: _reviewMessage,
                          maxLines: 3,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide your feedback';
                            }
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              hintStyle: TextStyle(
                                  fontFamily: 'Work Sans',
                                  fontSize: 14,
                                  color: Color(0xff6C757D)),
                              hintText: "Your Reviews (Optional)"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0Xff5F60B9),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                // Background color
                              ),
                              onPressed: () async {
                                customerReviewRequest.reviewMessage =
                                    _reviewMessage.text! ?? "None";
                                customerReviewRequest.customerBookingId =
                                    int.parse(bookingId);
                                customerReviewRequest.providerId = providerId;
                                customerReviewRequest.customerId = customerId;

                                var response = await ref
                                    .read(reviewProvider)
                                    .createCustomerReview(
                                        customerReviewRequest);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/dashboard',
                                  (route) => false,
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "SUBMIT",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                // Background color
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "CANCEL",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

void _bottomSheetMore(BuildContext context, String bookingId, WidgetRef ref) {
  int _currentStep = 0;
  var _notifications = ref.watch(providerNotificationDataProvider(bookingId));
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    builder: (builder) {
      return StatefulBuilder(builder: (context, setState) {
        return Container(
          height: MediaQuery.of(context).size.height * 2 / 5,
          padding: EdgeInsets.only(
            left: 5.0,
            right: 5.0,
            top: 5.0,
            bottom: 5.0,
          ),
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0))),
          child: _notifications.when(
            data: (_data) {
              List<NotificationResponse> notifications = _data;
              return Wrap(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Track Order",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Work Sans'),
                                ),
                                Text(
                                  "ID: #" + bookingId,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Work Sans',
                                      color: primaryColor),
                                )
                              ],
                            ),
                          ),
                        ),
                        new Divider(
                          height: 10.0,
                        ),
                        Stepper(
                          steps: notifications.length > 0
                              ? notifications.map((notification) {
                                  return Step(
                                    content: Container(),
                                    title: FittedBox(
                                      child: Column(
                                        children: [
                                          Text(notification.message),
                                          Text(DateFormat('hh:mm a dd MMM')
                                              .format(DateTime.parse(
                                                  notification.createTime!))),
                                        ],
                                      ),
                                    ),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 0
                                        ? StepState.complete
                                        : StepState.disabled,
                                  );
                                }).toList()
                              : <Step>[
                                  Step(
                                    title: const Text(
                                        'History is missing for this order'),
                                    content: Container(),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 0
                                        ? StepState.error
                                        : StepState.disabled,
                                  ),
                                ],
                          type: StepperType.vertical,
                          controlsBuilder: (context, controller) {
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            error: (err, s) => Text(err.toString()),
            loading: () => Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      });
    },
  );
}
