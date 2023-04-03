import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mistry_customer/provider/data_provider.dart';
import 'package:mistry_customer/screens/booking_screen.dart';
import 'package:mistry_customer/screens/dashboard_screen.dart';
import 'package:mistry_customer/services/shared_service.dart';
import 'package:mistry_customer/utils/config.dart';
import 'package:mistry_customer/utils/images.dart';
import 'package:intl/intl.dart';

class ProviderDetailScreen extends ConsumerStatefulWidget {
  // final Object? providerName;
  // final Object? serviceName;
  //
  // ProviderDetailScreen({this.providerName, this.serviceName});

  @override
  ConsumerState<ProviderDetailScreen> createState() =>
      _ProviderDetailScreenState();
}

class _ProviderDetailScreenState extends ConsumerState<ProviderDetailScreen> {
  late String providerId;
  late String serviceName;
  int indexOfServiceName = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    providerId = arguments['providerId'] ?? '';
    serviceName = arguments['serviceName'] ?? '';
    print(providerId);
  }

  @override
  void initState() {
    super.initState();

    // print("asdasd");
    // print(widget.providerName);
    // print("asdasd");
    // print(widget.serviceName);
  }

  @override
  Widget build(BuildContext context) {
    // final _data = ref.watch(providerDetailDataProvider(providerId));
    final _providerDetails = ref.watch(providerDetailsData(providerId!));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: _providerDetails.when(
              data: (_data) {
                print("test");
                print(_data);
                var agg_rating = 0.0;
                if (_providerDetails.value != null) {
                  var total_reviews =
                      _providerDetails.value!.providerReviews.length;

                  if (total_reviews > 0) {
                    for (int i = 0;
                        i < _providerDetails.value!.providerReviews.length;
                        i++) {
                      agg_rating = agg_rating +
                          double.parse(_providerDetails
                              .value!.providerReviews[i].rating!);
                    }
                    agg_rating = agg_rating / total_reviews;
                  }
                }

                for (int i = 0;
                    i < _data.providerDetails.serviceLists.length;
                    i++) {
                  if (_data.providerDetails.serviceLists[i].name ==
                      serviceName) {
                    indexOfServiceName = i;
                    break;
                  } else {
                    indexOfServiceName = 0;
                  }
                }
                return Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Color(0XFFF6F7F9),
                                        border: Border.all(
                                          color: Color(0XFF6F7F9),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/default_image.png"),
                                      ),
                                    ),

                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 10, top: 10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Color(0XFFF6F7F9),
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Icon(
                                              Icons.arrow_back_ios,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Text(
                                          "Service Summary",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Work Sans',
                                              fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      Container(
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: _data
                                              .providerDetails
                                              .serviceLists![indexOfServiceName]
                                              .subCategory!
                                              .length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      _data
                                                          .providerDetails
                                                          .serviceLists![
                                                              indexOfServiceName]
                                                          .subCategory![index]
                                                          .name!,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Work Sans',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                        '\u{20B9} ${_data.providerDetails.serviceLists![indexOfServiceName].subCategory![index].price!}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Work Sans',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))
                                                  ],
                                                ));
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFF6F7F9),
                                    border: Border.all(
                                      color: Color(0XFF6F7F9),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: primaryColor),
                                                      shape: BoxShape.circle,
                                                      color: Colors.white),
                                                  child: Stack(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: ImageIcon(
                                                          AssetImage(
                                                              ic_fill_profile),
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  child: Text(
                                                    _data.providerDetails.name,
                                                    style: TextStyle(
                                                        fontFamily: 'Work Sans',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  ic_message,
                                                  height: 15,
                                                  width: 15,
                                                  color: Color(0xFF6C757D),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  _data.providerDetails.email,
                                                  style: TextStyle(
                                                      fontFamily: 'Work Sans',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  ic_location,
                                                  height: 15,
                                                  width: 15,
                                                  color: Color(0xFF6C757D),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    _data
                                                            .providerDetails
                                                            .address[0]
                                                            .address1 +
                                                        ' ' +
                                                        _data
                                                            .providerDetails
                                                            .address[0]
                                                            .address2 +
                                                        ' ' +
                                                        _data.providerDetails
                                                            .address[0].city +
                                                        ' ' +
                                                        _data.providerDetails
                                                            .address[0].state +
                                                        ' ' +
                                                        _data.providerDetails
                                                            .address[0].pincode,
                                                    style: TextStyle(
                                                        fontFamily: 'Work Sans',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  calling,
                                                  height: 15,
                                                  width: 15,
                                                  color: Color(0xFF6C757D),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "+91-${_data.providerDetails.phonenumber}",
                                                  style: TextStyle(
                                                      fontFamily: 'Work Sans',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          "Reviews (${_data.providerReviews!.length})",
                                          style: TextStyle(
                                              fontFamily: 'Work Sans',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 20),
                                        child: InkWell(
                                          onTap: (){
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              '/customer-reviews',
                                              arguments: _data.providerDetails.id,
                                                  (route) => true,
                                            );
                                          },
                                          child: Text("View All"),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _data.providerReviews.length > 4
                                        ? 3
                                        : _data.providerReviews.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          decoration: BoxDecoration(
                                            color: Color(0XFFF6F7F9),
                                            border: Border.all(
                                              color: Color(0XFF6F7F9),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20),
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 10,
                                              bottom: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: primaryColor),
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
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        _data
                                                            .providerReviews[0]
                                                            .customerProfile!
                                                            .name!,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Work Sans',
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(DateFormat(
                                                              'dd MMM yyyy')
                                                          .format(DateTime
                                                              .parse(_data
                                                                  .providerReviews[
                                                                      index]
                                                                  .createDate!))),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        _data
                                                            .providerReviews[
                                                                index]
                                                            .reviewMessage!,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              // SizedBox(
                                              //   width: 10,
                                              // ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    RatingBarIndicator(
                                                      rating: double.parse(
                                                          _data!
                                                              .providerReviews[
                                                                  index]
                                                              .rating!),
                                                      itemBuilder:
                                                          (context, index) =>
                                                              Icon(
                                                        Icons.star,
                                                        color: Colors.green,
                                                      ),
                                                      itemCount: 5,
                                                      itemSize: 15.0,
                                                      direction:
                                                          Axis.horizontal,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      _data!
                                                          .providerReviews[
                                                              index]
                                                          .rating
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'Work Sans',
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ));
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 20,
                                      );
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.all(10),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0Xff5F60B9),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        // Background color
                                      ),
                                      onPressed: () async {
                                        var customerId =
                                            await SharedService.getCustomerId();
                                        print(customerId);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return BookingScreen(
                                            serviceName: serviceName,
                                            providerId:
                                                _data.providerDetails.id,
                                            customerId: customerId,
                                          );
                                        }));
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Text(
                                          "BOOK NOW",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 310,
                            left: 20,
                            right: 20,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 300,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          serviceName,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontFamily: 'Work Sans',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Rating',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xff6C757D),
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: 'Work Sans')),
                                          Container(
                                            child: Row(
                                              children: [
                                                RatingBarIndicator(
                                                  rating: agg_rating,
                                                  itemBuilder:
                                                      (context, index) => Icon(
                                                    Icons.star,
                                                    color: Colors.green,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 15.0,
                                                  direction: Axis.horizontal,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    agg_rating
                                                        .toStringAsPrecision(2),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontFamily:
                                                            'Work Sans'))
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              error: (err, s) => Text("asd" + err.toString()),
              loading: () => Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}