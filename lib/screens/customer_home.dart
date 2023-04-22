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
      return Stack(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      SliderScreen(),
                      Container(
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Container(
                              width: double.infinity,
                              child: Row(
                                children: const [

                                  Text(
                                    "Services",
                                    style: TextStyle(
                                        fontFamily: 'Work Sans',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800),
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
                            )
                           ,
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
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
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const ClipRect(
                      child: Text(
                        " You can share your service request",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                              borderRadius: BorderRadius.circular(10.0)),
// Background color
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
                                  style: TextStyle(color: primaryColor),
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
          )
        ],
      );
    } else {
      var response = ref.watch(customerServiceDataProvider);
      return response.when(
        data: (_data) {
          return Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          SliderScreen(),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Row(
                                      children: [Text("Services")],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    child: Container(
                                      height: 230,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: WOW_SERVICES.length,
                                        itemBuilder: (context, index) {
                                          String serviceKey = WOW_SERVICES.keys
                                              .elementAt(index);
                                          Map<String, String> service =
                                              WOW_SERVICES[serviceKey]!;
                                          return ServiceWidget(
                                            iconName: service!['serviceIcon'],
                                            serviceName:
                                                service!['serviceName'],
                                            icon_color: primaryColor,
                                            routeArg: service['routeArgument'],
                                            routePath: service['servicePath'],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
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
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        const ClipRect(
                          child: Text(
                            " You can share your service request",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Container(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/suggestion',
                                arguments: response.value!.id,
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
                                      style: TextStyle(color: primaryColor),
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
              )
            ],
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

Future<bool> whereToGo() async {
  var isLoggedIn = await SharedService.isLoggedIn();

  return isLoggedIn;
}
