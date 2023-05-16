import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mistry_customer/components/service_types.dart';
import 'package:mistry_customer/model/provider_by_category_list_response.dart';
import 'package:mistry_customer/provider/data_provider.dart';

import 'package:mistry_customer/utils/config.dart';
import 'package:mistry_customer/utils/images.dart';

class MaidServiceDetailScreen extends StatefulWidget {
  final Object? serviceName;

  MaidServiceDetailScreen({required this.serviceName});

  @override
  State<MaidServiceDetailScreen> createState() =>
      _MaidServiceDetailScreenState();
}

class _MaidServiceDetailScreenState extends State<MaidServiceDetailScreen> {
  List<String> maidServices = [
    "All",
    "On Demand Maid",
    "Subscription",
  ];
  int indexOfServiceName = -1;
  bool isSearchedEnabled = false;
  // String searchedService = "All";
  late String searchedService =
      widget.serviceName != 'All-Maids' ? widget.serviceName.toString() : "All";
  List<String> maidServicesIcons = [
    maid_all_demand,
    maid_on_demand,
    maid_subscription_demand,
  ];

  late String? serviceName;

  @override
  void initState() {
    super.initState();
    serviceName = widget.serviceName.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.topLeft,
            child: Text("Maid Service"),
          ),
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
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: Container(
                              height: 130,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: maidServices.length,
                                itemBuilder: (context, index) {
                                  return ServiceTypes(
                                    servicename: maidServices[index],
                                    iconName: maidServicesIcons[index],
                                    selectedSearch: () {
                                      setState(() {
                                        searchedService = maidServices[index];
                                        serviceName = searchedService == "All"
                                            ? "All-Maids"
                                            : searchedService;
                                      });
                                    },
                                    isSearchedEnabled:
                                        searchedService == maidServices[index]
                                            ? true
                                            : false,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(child: Consumer(builder: (context, ref, child) {
                      final _data = ref.watch(
                        categoryProvidersListDataProvider(serviceName!),
                      );
                      return _data.when(
                        data: (_data) {
                          List<ProvidersByCategoryResponse> providers =
                              _data.map((e) => e).toList();
                          if (providers != null && serviceName == 'All-Maids') {
                            return providers.length > 0
                                ? ListView.builder(
                                    itemCount: providers.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          itemCount: providers![index]
                                              .providerDetail
                                              .serviceLists
                                              .length,
                                          itemBuilder:
                                              (context, serviceListsIndex) {
                                            for (int i = 0;
                                                i <
                                                    providers[index]
                                                        .providerDetail
                                                        .serviceLists
                                                        .length;
                                                i++) {
                                              if (providers[index]
                                                      .providerDetail
                                                      .serviceLists[i]
                                                      .name ==
                                                  serviceName) {
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
                                                'On Demand Maid') {
                                              service_image =
                                                  on_demand_list_image;
                                            } else if (providers[index]
                                                    .providerDetail
                                                    .serviceLists[
                                                        serviceListsIndex]
                                                    .name ==
                                                maidServices[2]) {
                                              service_image =
                                                  subscription_maid_list_image;
                                            } else {
                                              service_image =
                                                  subscription_maid_list_image;
                                            }
                                            final _providerDetails = ref.watch(
                                                providerDetailsData(
                                                    providers[index]
                                                        .providerDetail
                                                        .id));
                                            var agg_rating = 0.0;
                                            if (_providerDetails.value !=
                                                null) {
                                              var total_reviews =
                                                  _providerDetails.value!
                                                      .providerReviews.length;

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
                                                agg_rating =
                                                    agg_rating / total_reviews;
                                              }
                                            }

                                            return Card(
                                              elevation: 10,
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
                                                      "serviceName": providers[
                                                      index]
                                                          .providerDetail
                                                          .serviceLists
                                                          .length >
                                                          1
                                                          ? providers[
                                                      index]
                                                          .providerDetail
                                                          .serviceLists[
                                                      serviceListsIndex]
                                                          .name
                                                          : providers[
                                                      index]
                                                          .providerDetail
                                                          .serviceLists[
                                                      serviceListsIndex]
                                                          .name
                                                    },
                                                        (route) => true,
                                                  );
                                                },
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(

                                                          height: 250,
                                                          decoration: BoxDecoration(
                                                            color: Color(0xffEFF0FF),
                                                            image: DecorationImage(
                                                              image: ExactAssetImage(
                                                                  service_image!),
                                                              fit: BoxFit.fitWidth,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius.circular(10),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Positioned(
                                                      top: 10,
                                                      right: 10,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: primaryColor.withOpacity(0.5),
                                                          // border: Border.all,
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        padding: EdgeInsets.all(5),
                                                        child:  ClipOval(
                                                          child: Material(
                                                            color: primaryColor.withOpacity(0.5),
                                                            child:
                                                            Ink.image(
                                                              image: AssetImage(
                                                                  providers[index].providerDetail.serviceLists[serviceListsIndex].name=='On Demand Maid' ? maid_on_demand: maid_subscription_demand),
                                                              fit: BoxFit
                                                                  .cover,
                                                              width: 30,
                                                              height: 30,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned.fill(
                                                      bottom: 0,
                                                      top: 180,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            begin: Alignment.bottomCenter,
                                                            end: Alignment.topCenter,
                                                            colors: [
                                                              Color(0xff7879CA).withOpacity(0.8),
                                                              Color(0xffA4A5DE).withOpacity(0.5),
                                                            ],
                                                          ),
                                                          // border: Border.all,
                                                          borderRadius:
                                                          BorderRadius.circular(10),
                                                        ),
                                                        padding: EdgeInsets.all(5),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    child: Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width: 10,
                                                                        ),
                                                                        RatingBarIndicator(
                                                                          unratedColor:
                                                                          Colors
                                                                              .white,
                                                                          rating:
                                                                          agg_rating ??
                                                                              0.0,
                                                                          itemBuilder:
                                                                              (context,
                                                                              index) =>
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Colors
                                                                                    .green,
                                                                              ),
                                                                          itemCount: 5,
                                                                          itemSize:
                                                                          15.0,
                                                                          direction: Axis
                                                                              .horizontal,
                                                                        ),
                                                                        SizedBox(
                                                                          width: 10,
                                                                        ),
                                                                        Text(
                                                                          agg_rating
                                                                              .toStringAsPrecision(
                                                                              2),
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize:
                                                                              16),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child: Text(
                                                                      '${providers[index].providerDetail.serviceLists[serviceListsIndex].name}',
                                                                      style: TextStyle(
                                                                          fontSize: 18,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                          color: Colors
                                                                              .white,
                                                                          fontFamily:
                                                                          'Work Sans'),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(

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
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                          border: Border
                                                                              .all(
                                                                              color:
                                                                              primaryColor),
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color: Colors
                                                                              .white),
                                                                      child: ClipOval(
                                                                        child: Material(
                                                                          color: Colors
                                                                              .transparent,
                                                                          child:
                                                                          Ink.image(
                                                                            image: AssetImage(
                                                                                male_default_profile_iamge),
                                                                            fit: BoxFit
                                                                                .cover,
                                                                            width: 30,
                                                                            height: 30,
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
                                                                      providers[index]
                                                                          .providerDetail
                                                                          .name,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                          'Work Sans',
                                                                          fontSize: 18,color: Colors.white,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                    ),
                                                                  )
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
                                            );
                                          },
                                        ),
                                      );
                                    })
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
                                        for (int i = 0;
                                            i <
                                                providers[index]
                                                    .providerDetail
                                                    .serviceLists
                                                    .length;
                                            i++) {
                                          if (providers[index]
                                                  .providerDetail
                                                  .serviceLists[i]
                                                  .name ==
                                              serviceName) {
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
                                                    indexOfServiceName]
                                                .name ==
                                            maidServices[1]) {
                                          service_image = on_demand_list_image;
                                        } else if (providers[index]
                                                .providerDetail
                                                .serviceLists[
                                                    indexOfServiceName]
                                                .name ==
                                            maidServices[2]) {
                                          service_image =
                                              subscription_maid_list_image;
                                        } else {
                                          service_image =
                                              subscription_maid_list_image;
                                        }
                                        final _providerDetails = ref.watch(
                                            providerDetailsData(providers[index]
                                                .providerDetail
                                                .id));
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

                                        return Card(
                                          elevation: 10,
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
                                                  "serviceName": providers[
                                                  index]
                                                      .providerDetail
                                                      .serviceLists
                                                      .length >
                                                      1
                                                      ? providers[index]
                                                      .providerDetail
                                                      .serviceLists[
                                                  indexOfServiceName]
                                                      .name
                                                      : providers[index]
                                                      .providerDetail
                                                      .serviceLists[0]
                                                      .name
                                                },
                                                    (route) => true,
                                              );
                                            },
                                            child: Stack(
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(

                                                      height: 250,
                                                      decoration: BoxDecoration(
                                                        color: Color(0xffEFF0FF),
                                                        image: DecorationImage(
                                                          image: ExactAssetImage(
                                                              service_image!),
                                                          fit: BoxFit.fitWidth,
                                                        ),
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Positioned(
                                                  top: 10,
                                                  right: 10,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: primaryColor.withOpacity(0.5),
                                                      // border: Border.all,
                                                      borderRadius: BorderRadius.circular(50),
                                                    ),
                                                    padding: EdgeInsets.all(5),
                                                    child:  ClipOval(
                                                      child: Material(
                                                        color: primaryColor.withOpacity(0.5),
                                                        child:
                                                        Ink.image(
                                                          image: AssetImage(
                                                              providers[index].providerDetail.serviceLists[indexOfServiceName].name=='On Demand Maid' ? maid_on_demand: maid_subscription_demand),
                                                          fit: BoxFit
                                                              .cover,
                                                          width: 30,
                                                          height: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned.fill(
                                                  bottom: 0,
                                                  top: 180,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment.bottomCenter,
                                                        end: Alignment.topCenter,
                                                        colors: [
                                                          Color(0xff7879CA).withOpacity(0.8),
                                                          Color(0xffA4A5DE).withOpacity(0.5),
                                                        ],
                                                      ),
                                                      // border: Border.all,
                                                      borderRadius:
                                                          BorderRadius.circular(10),
                                                    ),
                                                    padding: EdgeInsets.all(5),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    RatingBarIndicator(
                                                                      unratedColor:
                                                                          Colors
                                                                              .white,
                                                                      rating:
                                                                          agg_rating ??
                                                                              0.0,
                                                                      itemBuilder:
                                                                          (context,
                                                                                  index) =>
                                                                              Icon(
                                                                        Icons.star,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                      itemCount: 5,
                                                                      itemSize:
                                                                          15.0,
                                                                      direction: Axis
                                                                          .horizontal,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      agg_rating
                                                                          .toStringAsPrecision(
                                                                              2),
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
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
                                                                      fontSize: 18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'Work Sans'),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(

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
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                      border: Border
                                                                          .all(
                                                                              color:
                                                                                  primaryColor),
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .white),
                                                                  child: ClipOval(
                                                                    child: Material(
                                                                      color: Colors
                                                                          .transparent,
                                                                      child:
                                                                          Ink.image(
                                                                        image: AssetImage(
                                                                            male_default_profile_iamge),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        width: 30,
                                                                        height: 30,
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
                                                                  providers[index]
                                                                      .providerDetail
                                                                      .name,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Work Sans',
                                                                      fontSize: 18,color: Colors.white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              )
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
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(
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
