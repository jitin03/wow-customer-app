import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mistry_customer/components/slider_screen.dart';
import 'package:mistry_customer/provider/data_provider.dart';
import 'package:mistry_customer/utils/config.dart';
import '../services/shared_service.dart';

class CustomerHomeFragment extends ConsumerStatefulWidget {
  const CustomerHomeFragment({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomerHomeFragment> createState() =>
      _CustomerHomeFragmentState();
}

class _CustomerHomeFragmentState extends ConsumerState<CustomerHomeFragment> {
  var isLoggedIn;
  @override
  void initState() {
    super.initState();
    initializeLoginStatus();
  }

  Future<void> initializeLoginStatus() async {
    bool loginStatus = await whereToGo();
    setState(() {
      isLoggedIn = loginStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn != null && !isLoggedIn) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  const SliderScreen(),
                  Column(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: const [
                                Text(
                                  "Services",
                                  style: TextStyle(
                                      fontFamily: 'Work Sans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Container(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: WOW_SERVICES.length,
                                itemBuilder: (context, index) {
                                  String serviceKey =
                                      WOW_SERVICES.keys.elementAt(index);
                                  Map<String, String> service =
                                      WOW_SERVICES[serviceKey]!;
                                  return ServiceWidget(
                                    iconName: service!['serviceIcon'],
                                    serviceName: service!['serviceName'],
                                    icon_color: primaryColor,
                                    routeArg: service['routeArgument'],
                                    routePath: service['servicePath'],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0XFFF6F7F9),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: double.infinity,
                              child: Row(
                                children: const [
                                  Text(
                                    "Featured",
                                    style: TextStyle(
                                        fontFamily: 'Work Sans',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: Container(
                                height: 200,
                                margin: EdgeInsets.only(left: 10),
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: WOW_FEATURED_SERVICES.length,
                                  itemBuilder: (context, index) {
                                    String serviceKey = WOW_FEATURED_SERVICES
                                        .keys
                                        .elementAt(index);
                                    Map<String, String> service =
                                        WOW_FEATURED_SERVICES[serviceKey]!;
                                    return FeaturedServiceWidget(
                                      iconName: service!['serviceIcon'],
                                      serviceName: service!['serviceName'],
                                      featureServiceName:
                                          service!['featuredServiceName'],
                                      icon_color: primaryColor,
                                      routeArg: service['routeArgument'],
                                      routePath: service['servicePath'],
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
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: primaryColor,
                            border: Border.all(color: primaryColor),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20))),
                        child: Container(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const ClipRect(
                                child: Text(
                                  "Don't find your service? Don't worry,",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                              const ClipRect(
                                child: Text(
                                  " You can share your service request",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              Container(
                                // width: double.infinity,
                                // margin: EdgeInsets.only(left: 40, right: 40),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/suggestion',
                                      arguments: "anonymous",
                                      (route) => true,
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Icon(
                                        Icons.add,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "NEW SERVICE REQUEST",
                                            style:
                                                TextStyle(color: primaryColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      var response = ref.watch(customerServiceDataProvider);
      return response.when(
        data: (_data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      const SliderScreen(),
                      Column(
                        children: [
                          Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  children: const [
                                    Text(
                                      "Services",
                                      style: TextStyle(
                                          fontFamily: 'Work Sans',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Container(
                                  height: 120,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: WOW_SERVICES.length,
                                    itemBuilder: (context, index) {
                                      String serviceKey =
                                      WOW_SERVICES.keys.elementAt(index);
                                      Map<String, String> service =
                                      WOW_SERVICES[serviceKey]!;
                                      return ServiceWidget(
                                        iconName: service!['serviceIcon'],
                                        serviceName: service!['serviceName'],
                                        icon_color: primaryColor,
                                        routeArg: service['routeArgument'],
                                        routePath: service['servicePath'],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0XFFF6F7F9),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Row(
                                    children: const [
                                      Text(
                                        "Featured",
                                        style: TextStyle(
                                            fontFamily: 'Work Sans',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: Container(
                                    height: 200,
                                    margin: EdgeInsets.only(left: 10),
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: WOW_FEATURED_SERVICES.length,
                                      itemBuilder: (context, index) {
                                        String serviceKey = WOW_FEATURED_SERVICES
                                            .keys
                                            .elementAt(index);
                                        Map<String, String> service =
                                        WOW_FEATURED_SERVICES[serviceKey]!;
                                        return FeaturedServiceWidget(
                                          iconName: service!['serviceIcon'],
                                          serviceName: service!['serviceName'],
                                          featureServiceName:
                                          service!['featuredServiceName'],
                                          icon_color: primaryColor,
                                          routeArg: service['routeArgument'],
                                          routePath: service['servicePath'],
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
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: primaryColor,
                                border: Border.all(color: primaryColor),
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20))),
                            child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const ClipRect(
                                        child: Text(
                                          "Don't find your service? Don't worry,",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 18),
                                        ),
                                      ),
                                      const ClipRect(
                                        child: Text(
                                          " You can share your service request",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 18),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      Container(
                                        // width: double.infinity,
                                        // margin: EdgeInsets.only(left: 40, right: 40),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10.0)),
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              '/suggestion',
                                              arguments: "anonymous",
                                                  (route) => true,
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: const [
                                              Icon(
                                                Icons.add,
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    "NEW SERVICE REQUEST",
                                                    style:
                                                    TextStyle(color: primaryColor),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        error: (err, s) => Text(err.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

class ServiceWidget extends ConsumerWidget {
  String? iconName;
  String? serviceName;
  Color? icon_color;
  String? routeArg;
  String? routePath;
  ServiceWidget(
      {required this.iconName,
      required this.serviceName,
      required this.icon_color,
      required this.routeArg,
      required this.routePath});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ImageProvider<Object> image;

    image = AssetImage(iconName!);
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              ref.invalidate(categoryProvidersListDataProvider);
              Navigator.pushNamedAndRemoveUntil(
                context,
                routePath!,
                arguments: routeArg,
                (route) => true,
              );
            },
            child: Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0XFFAFB3D3)),
                shape: BoxShape.circle,
                color: Color(0XFFF6F7F9),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ImageIcon(
                      AssetImage(iconName!),
                      size: 50,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(serviceName!),
        ],
      ),
    );
  }
}

class FeaturedServiceWidget extends ConsumerWidget {
  String? iconName;
  String? serviceName;
  String? featureServiceName;
  Color? icon_color;
  String? routeArg;
  String? routePath;
  FeaturedServiceWidget(
      {required this.iconName,
      required this.serviceName,
      required this.featureServiceName,
      required this.icon_color,
      required this.routeArg,
      required this.routePath});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: (){
        ref.invalidate(categoryProvidersListDataProvider);
        Navigator.pushNamedAndRemoveUntil(
          context,
          routePath!,
          arguments: routeArg,
              (route) => true,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage(iconName!),
                      fit: BoxFit.fitHeight,
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,top: 10),
                  child: Text(featureServiceName!,style: TextStyle(fontFamily: 'Work Sans',fontWeight: FontWeight.w500),),
                ),
              ],
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  // border: Border.all,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(5),
                child: Text(
                  serviceName!.toUpperCase(),
                  style: TextStyle(
                      color: primaryColor,
                      fontFamily: 'Work Sans',
                      fontSize: 8,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // return Container(
    //   decoration: BoxDecoration(
    //       color: Colors.white,
    //       border: Border.all(color: Colors.grey),
    //       borderRadius: BorderRadius.circular(10)),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Container(
    //           width: 200,
    //           height: 150,
    //           decoration: new BoxDecoration(
    //               image: new DecorationImage(
    //                 image: ExactAssetImage(iconName!),
    //                 fit: BoxFit.fitHeight,
    //               ),
    //               borderRadius: BorderRadius.only(
    //                   topRight: Radius.circular(10),
    //                   topLeft: Radius.circular(10)))),
    //       SizedBox(
    //         height: 10,
    //       ),
    //       Container(
    //         margin: EdgeInsets.only(left: 10),
    //         child: Text(featureServiceName!),
    //       )
    //     ],
    //   ),
    // );
  }
}

Future<bool> whereToGo() async {
  var isLoggedIn = await SharedService.isLoggedIn();

  return isLoggedIn;
}
