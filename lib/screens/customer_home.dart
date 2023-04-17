import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mistry_customer/components/slider_screen.dart';
import 'package:mistry_customer/provider/data_provider.dart';
import 'package:mistry_customer/screens/dashboard_screen.dart';
import 'package:mistry_customer/screens/vehicle_service_detail_screen.dart';
import 'package:mistry_customer/utils/config.dart';
import 'package:mistry_customer/utils/images.dart';

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
    if ( isLoggedIn!=null &&!isLoggedIn) {
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
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: InkWell(
                                    onTap: () {
                                      ref.invalidate(
                                          categoryProvidersListDataProvider);
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/laundry-service',
                                        arguments: "All-Laundry",
                                        (route) => true,
                                      );
                                    },
                                    child: ClipRect(
                                      child: ServiceWidget(
                                        iconName:
                                            "assets/icons/ic_laundry_service.png",
                                        serviceName: "Laundry",
                                        icon_color: primaryColor,
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        ref.invalidate(
                                            categoryProvidersListDataProvider);
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/vehicle-service',
                                          arguments: "All-Vehicles",
                                          (route) => true,
                                        );
                                      },
                                      child: ClipRect(
                                        child: ServiceWidget(
                                          iconName:
                                              "assets/icons/ic_car_services.png",
                                          serviceName: "Vehicle Service",
                                          icon_color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
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
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: Container(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ClipRect(
                      child: Text(
                        "Don't find your service? Don't worry,",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    ClipRect(
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
                          children: [
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
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          ref.invalidate(
                                              categoryProvidersListDataProvider);
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/laundry-service',
                                            arguments: "All-Laundry",
                                            (route) => true,
                                          );
                                        },
                                        child: ClipRect(
                                          child: ServiceWidget(
                                            iconName:
                                                "assets/icons/ic_laundry_service.png",
                                            serviceName: "Laundry",
                                            icon_color: primaryColor,
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            ref.invalidate(
                                                categoryProvidersListDataProvider);
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              '/vehicle-service',
                                              arguments: "All-Vehicles",
                                              (route) => true,
                                            );
                                          },
                                          child: ClipRect(
                                            child: ServiceWidget(
                                              iconName:
                                                  "assets/icons/ic_car_services.png",
                                              serviceName: "Vehicle Service",
                                              icon_color: primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
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
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  child: Container(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ClipRect(
                          child: Text(
                            "Don't find your service? Don't worry,",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        ClipRect(
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
                                arguments: response.value!.id,
                                (route) => true,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
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
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

class ServiceWidget extends StatelessWidget {
  String iconName;
  String serviceName;
  Color icon_color;
  ServiceWidget({
    required this.iconName,
    required this.serviceName,
    required this.icon_color,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0XFFEBEBEB)),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ImageIcon(
                AssetImage(iconName),
                color: icon_color,
                size: 50,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                serviceName,
                style: TextStyle(color: Color(0XFF1C1F34), fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      margin: EdgeInsets.all(10),
    );
  }
}



Future<bool> whereToGo() async {
  var isLoggedIn = await SharedService.isLoggedIn();

  return isLoggedIn;
}
