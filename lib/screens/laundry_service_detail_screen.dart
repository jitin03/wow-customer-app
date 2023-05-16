import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mistry_customer/components/service_types.dart';
import 'package:mistry_customer/model/provider_by_category_list_response.dart';
import 'package:mistry_customer/provider/data_provider.dart';
import 'package:mistry_customer/screens/dashboard_screen.dart';
import 'package:mistry_customer/screens/provider_detail_screen.dart';
import 'package:mistry_customer/utils/config.dart';
import 'package:mistry_customer/utils/images.dart';

class LaundryServiceDetailScreen extends StatefulWidget {
  final Object? serviceName;

  LaundryServiceDetailScreen({required this.serviceName});

  @override
  State<LaundryServiceDetailScreen> createState() =>
      _LaundryServiceDetailScreenState();
}

class _LaundryServiceDetailScreenState
    extends State<LaundryServiceDetailScreen> {
  List<String> laundryServices = [
    "All",
    "Ironing",
    "Dry Cleaning",
    "Washing",
    "Washing+Ironing"
  ];
  int indexOfServiceName = -1;
  bool isSearchedEnabled = false;

  late String searchedService= widget.serviceName !='All-Laundry' ? widget.serviceName.toString(): "All";

  List<String> laundryServicesIcons = [
    maid_all_demand,
    ic_ironing,
    ic_dry_cleaning,
    ic_laundry_washing,
    ic_laundry_washing,
  ];

  late String? serviceName;

  @override
  void initState() {
    super.initState();
    print(widget.serviceName.toString());
    serviceName = widget.serviceName.toString();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Laundry Services"),
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
          child: Container(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Service Types",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Work Sans'),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: Container(
                            height: 130,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: laundryServices.length,
                              itemBuilder: (context, index) {
                                return ServiceTypes(
                                  servicename: laundryServices[index],
                                  iconName: laundryServicesIcons[index],
                                  selectedSearch: () {
                                    setState(() {
                                      searchedService = laundryServices[index];
                                      serviceName = searchedService == "All"
                                          ? "All-Laundry"
                                          : searchedService;
                                    });
                                  },
                                  isSearchedEnabled:
                                  searchedService == laundryServices[index]
                                      ? true
                                      : false,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(child: Consumer(builder: (context, ref, child) {
                      print(serviceName);
                      final _data = ref.watch(
                        categoryProvidersListDataProvider(serviceName!),
                      );
                      return _data.when(
                        data: (_data) {
                          List<ProvidersByCategoryResponse> providers =
                          _data.map((e) => e).toList();
                          print("serviceName" + serviceName!);
                          if ( providers !=null &&serviceName == 'All-Laundry') {
                            return providers.length > 0
                                ? Container(
                                child: ListView.builder(
                                    itemCount: providers.length ,
                                    itemBuilder: (context, index) {
                                      print(providers[index]
                                          .providerDetail
                                          .serviceLists
                                      [0].name);
                                      return Container(
                                        child:
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          itemCount: providers![index]
                                              .providerDetail
                                              .serviceLists
                                              .length,
                                          itemBuilder:
                                              (context, serviceListsIndex) {
                                            // return Text(providers[index].providerDetail.serviceLists[serviceListsIndex].name);
                                            for (int i = 0; i < providers[index].providerDetail.serviceLists.length; i++) {
                                              if (providers[index].providerDetail.serviceLists[i].name == serviceName) {
                                                indexOfServiceName = i;
                                                break;
                                              } else {
                                                indexOfServiceName = 0;
                                              }
                                            }
                                            print(indexOfServiceName);

                                            var service_image;
                                            if (providers[index]
                                                .providerDetail
                                                .serviceLists[
                                            serviceListsIndex]
                                                .name ==
                                                'Ironing') {
                                              service_image =
                                                  img_default_laundry_ironing_placeholder;
                                            } else if (providers[index]
                                                .providerDetail
                                                .serviceLists[
                                            serviceListsIndex]
                                                .name ==
                                                'Washing') {
                                              service_image =
                                                  img_default_laundry_placeholder;
                                            } else if (providers[index]
                                                .providerDetail
                                                .serviceLists[
                                            serviceListsIndex]
                                                .name ==
                                                'Washing+Ironing') {
                                              service_image =
                                                  img_default_laundry_washing_iron_placeholder;
                                            } else {
                                              service_image =
                                                  img_default_laundry_ironing_placeholder;
                                            }
                                            final _providerDetails = ref
                                                .watch(providerDetailsData(
                                                providers[index]
                                                    .providerDetail
                                                    .id));
                                            var agg_rating = 0.0;
                                            if (_providerDetails.value !=
                                                null) {
                                              var total_reviews =
                                                  _providerDetails
                                                      .value!
                                                      .providerReviews
                                                      .length;

                                              if (total_reviews > 0) {
                                                for (int i = 0;
                                                i <
                                                    _providerDetails
                                                        .value!
                                                        .providerReviews
                                                        .length;
                                                i++) {
                                                  agg_rating = agg_rating +
                                                      double.parse(
                                                          _providerDetails
                                                              .value!
                                                              .providerReviews[
                                                          i]
                                                              .rating!);
                                                }
                                                agg_rating = agg_rating /
                                                    total_reviews;
                                              }
                                            }

                                            return Padding(
                                              padding: const EdgeInsets.all(
                                                  10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Card(
                                                    elevation:10,
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator
                                                            .pushNamedAndRemoveUntil(
                                                          context,
                                                          '/provider-detail',
                                                          arguments: {
                                                            "providerId":
                                                            providers[
                                                            index]
                                                                .providerDetail
                                                                .id,
                                                            "serviceName": providers[index].providerDetail.serviceLists.length > 1
                                                                ? providers[index].providerDetail.serviceLists[serviceListsIndex].name
                                                                : providers[index].providerDetail.serviceLists[0].name
                                                          },
                                                              (route) => true,
                                                        );
                                                      },
                                                      child: Material(
                                                        elevation: 10,
                                                        child: Container(
                                                          decoration:
                                                          BoxDecoration(
                                                            border: Border.all(
                                                                color: Color(
                                                                    0XFFF6F7F9)),
                                                            shape: BoxShape
                                                                .circle,
                                                            color: Color(
                                                                0XFFF6F7F9),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                // height: 200,
                                                                color: Colors
                                                                    .white,
                                                                child: Image(
                                                                  image: AssetImage(
                                                                      service_image),
                                                                  // fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(
                                                                    left: 10, right: 10),
                                                                child: Text(
                                                                  "Available At:",
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontFamily: 'Work Sans',
                                                                      fontSize: 14),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10,),
                                                              Container(
                                                                height: 30,
                                                                child: Container(
                                                                  // width: 300,
                                                                  margin: EdgeInsets.only(left: 10),
                                                                  child: ListView.separated(
                                                                    scrollDirection: Axis.horizontal,
                                                                    itemCount: providers![index].providerDetail!.addaAreas.length,
                                                                    itemBuilder: (context, addaIndex) {

                                                                      return   Container(
                                                                        decoration: BoxDecoration(
                                                                          color: primaryColor,
                                                                          // border: Border.all,
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                        padding: EdgeInsets.all(5),
                                                                        child: Text(
                                                                          providers![index].providerDetail.addaAreas[addaIndex],
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontFamily: 'Work Sans',
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      );
                                                                    },
                                                                    separatorBuilder:
                                                                        (BuildContext context, int index) {
                                                                      return SizedBox(
                                                                        width: 20,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 20,),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                    right:
                                                                    20),
                                                                child:
                                                                Container(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            RatingBarIndicator(
                                                                              rating: agg_rating ?? 0.0,
                                                                              itemBuilder: (context, index) => Icon(
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
                                                                              agg_rating.toStringAsPrecision(2),
                                                                              style: TextStyle(fontSize: 16),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                        Text(
                                                                          '${providers[index].providerDetail.serviceLists[serviceListsIndex].name}',
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w800,
                                                                              fontFamily: 'Work Sans'),
                                                                        ),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    left:
                                                                    10,
                                                                    bottom:
                                                                    10,
                                                                    top:
                                                                    10),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          border:
                                                                          Border.all(color: primaryColor),
                                                                          shape: BoxShape.circle,
                                                                          color: Colors.white),
                                                                      child:
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                            border: Border.all(color: primaryColor),
                                                                            shape: BoxShape.circle,
                                                                            color: Colors.white),
                                                                        child:
                                                                        ClipOval(
                                                                          child:
                                                                          Material(
                                                                            color: Colors.transparent,
                                                                            child: Ink.image(
                                                                              image: AssetImage(male_default_profile_iamge),
                                                                              fit: BoxFit.cover,
                                                                              width: 30,
                                                                              height: 30,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                      10,
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                      Text(
                                                                        providers[index]
                                                                            .providerDetail
                                                                            .name,
                                                                        style: TextStyle(
                                                                            fontFamily: 'Work Sans',
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.w800),
                                                                      ),
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }))
                                : Center(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
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
                                    Text(
                                        "No services found for your search"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return providers.length > 0
                                ? Container(
                              child: ListView.builder(
                                itemCount: providers.length,
                                itemBuilder: (context, index) {
                                  for (int i = 0; i < providers[index].providerDetail.serviceLists.length; i++) {
                                    print("debugging1");
                                    print(providers[index].providerDetail.name);
                                    print(providers[index].providerDetail.serviceLists[i].name);
                                    print("debugging1");
                                    if (providers[index].providerDetail.serviceLists[i].name == serviceName) {
                                      indexOfServiceName = i;
                                      break;
                                    } else {
                                      indexOfServiceName = 0;
                                    }
                                  }
                                  print("debugging");
                                  print(indexOfServiceName);
                                  print("debugging");

                                  var service_image;
                                  if (providers[index]
                                      .providerDetail
                                      .serviceLists[
                                  indexOfServiceName]
                                      .name ==
                                      'Ironing') {
                                    service_image =
                                        img_default_laundry_ironing_placeholder;
                                  } else if (providers[index]
                                      .providerDetail
                                      .serviceLists[
                                  indexOfServiceName]
                                      .name ==
                                      'Washing') {
                                    service_image =
                                        img_default_laundry_placeholder;
                                  } else if (providers[index]
                                      .providerDetail
                                      .serviceLists[indexOfServiceName]
                                      .name ==
                                      'Washing+Ironing') {
                                    service_image =
                                        img_default_laundry_washing_iron_placeholder;
                                  } else {
                                    service_image =
                                        img_default_laundry_ironing_placeholder;
                                  }
                                  final _providerDetails = ref.watch(providerDetailsData(providers[index].providerDetail.id));
                                  var agg_rating = 0.0;
                                  if (_providerDetails.value != null) {
                                    var total_reviews = _providerDetails
                                        .value!.providerReviews.length;

                                    if (total_reviews > 0) {
                                      for (int i = 0;
                                      i <
                                          _providerDetails.value!
                                              .providerReviews.length;
                                      i++) {
                                        agg_rating = agg_rating +
                                            double.parse(_providerDetails
                                                .value!
                                                .providerReviews[i]
                                                .rating!);
                                      }
                                      agg_rating =
                                          agg_rating / total_reviews;
                                    }
                                  }

                                  return Container(

                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Card(
                                            elevation:10,
                                            child: InkWell(
                                              onTap: () {

                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                  context,
                                                  '/provider-detail',
                                                  arguments: {
                                                    "providerId":
                                                    providers[index]
                                                        .providerDetail
                                                        .id,
                                                    "serviceName":serviceName

                                                    // "serviceName": providers[index].providerDetail.serviceLists.length > 1
                                                    //     ? providers[index].providerDetail.serviceLists[indexOfServiceName].name
                                                    //     : providers[index].providerDetail.serviceLists[0].name
                                                  },
                                                      (route) => true,
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(
                                                          0XFFF6F7F9)),
                                                  shape: BoxShape.circle,
                                                  color: Color(0XFFF6F7F9),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      // height: 200,
                                                      color: Colors.white,
                                                      child: Image(
                                                        image: AssetImage(
                                                            service_image),
                                                        // fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: Text(
                                                        "Available At:",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: 'Work Sans',
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Container(
                                                      height: 30,
                                                      child: Container(
                                                        // width: 300,
                                                        margin: EdgeInsets.only(left: 10),
                                                        child: ListView.separated(
                                                          scrollDirection: Axis.horizontal,
                                                          itemCount: providers![index].providerDetail!.addaAreas.length,
                                                          itemBuilder: (context, addaIndex) {

                                                            return   Container(
                                                              decoration: BoxDecoration(
                                                                color: primaryColor,
                                                                // border: Border.all,
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              padding: EdgeInsets.all(5),
                                                              child: Text(
                                                                providers![index].providerDetail.addaAreas[addaIndex],
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontFamily: 'Work Sans',
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w500),
                                                              ),
                                                            );
                                                          },
                                                          separatorBuilder:
                                                              (BuildContext context, int index) {
                                                            return SizedBox(
                                                              width: 20,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(height: 20,),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          right: 20),
                                                      child: Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [

                                                            Container(
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width:
                                                                    10,
                                                                  ),
                                                                  RatingBarIndicator(
                                                                    rating: agg_rating ??
                                                                        0.0,
                                                                    itemBuilder:
                                                                        (context, index) =>
                                                                        Icon(
                                                                          Icons
                                                                              .star,
                                                                          color:
                                                                          Colors.green,
                                                                        ),
                                                                    itemCount:
                                                                    5,
                                                                    itemSize:
                                                                    15.0,
                                                                    direction:
                                                                    Axis.horizontal,
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                    10,
                                                                  ),
                                                                  Text(
                                                                    agg_rating
                                                                        .toStringAsPrecision(2),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        16),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                '${providers[index].providerDetail.serviceLists[indexOfServiceName].name}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    16,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                    fontFamily:
                                                                    'Work Sans'),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                      EdgeInsets.only(
                                                          left: 10,
                                                          bottom: 10,
                                                          top: 10),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color:
                                                                    primaryColor),
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .white),
                                                            child:
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color:
                                                                      primaryColor),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .white),
                                                              child:
                                                              ClipOval(
                                                                child:
                                                                Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child: Ink
                                                                      .image(
                                                                    image: AssetImage(
                                                                        male_default_profile_iamge),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width:
                                                                    30,
                                                                    height:
                                                                    30,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            child: Text(
                                                              providers[
                                                              index]
                                                                  .providerDetail
                                                                  .name,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                  'Work Sans',
                                                                  fontSize:
                                                                  16,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                                : Center(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
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
                                    Text(
                                        "No services found for your search"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                        },
                        error: (err, s) => Text(err.toString()),
                        loading: () => Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    })),
                  ]),
            ),
          ),
        ));
  }
}
