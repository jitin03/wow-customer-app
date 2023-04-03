import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mistry_customer/components/service_types.dart';
import 'package:mistry_customer/model/provider_by_category_list_response.dart';
import 'package:mistry_customer/provider/data_provider.dart';
import 'package:mistry_customer/screens/dashboard_screen.dart';
import 'package:mistry_customer/screens/provider_detail_screen.dart';
import 'package:mistry_customer/utils/config.dart';
import 'package:mistry_customer/utils/images.dart';

class VehicleServiceDetailScreen extends ConsumerStatefulWidget {
  final Object? serviceName;

  VehicleServiceDetailScreen({required this.serviceName});

  @override
  ConsumerState<VehicleServiceDetailScreen> createState() =>
      _VehicleServiceDetailScreenState();
}

class _VehicleServiceDetailScreenState
    extends ConsumerState<VehicleServiceDetailScreen> {
  List<String> vehicleServices = ["All", "Car Cleaning"];
  bool isSearchedEnabled = false;
  late String searchedService = "All";
  List<String> vehicleServicesIcons = [icon_all_services, icon_car_clearning];

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
          title: Text("Vehicle Services"),
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
                            itemCount: vehicleServices.length,
                            itemBuilder: (context, index) {
                              return ServiceTypes(
                                servicename: vehicleServices[index],
                                iconName: vehicleServicesIcons[index],
                                selectedSearch: () {
                                  setState(() {
                                    searchedService = vehicleServices[index];
                                    serviceName = searchedService == "All"
                                        ? "All-Vehicles"
                                        : searchedService;
                                  });
                                },
                                isSearchedEnabled:
                                    searchedService == vehicleServices[index]
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
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final _data = ref.watch(
                          categoryProvidersListDataProvider(serviceName!),
                        );
                        return _data.when(
                          data: (_data) {
                            List<ProvidersByCategoryResponse> providers =
                                _data.map((e) => e).toList();
                            print(providers.length);
                            return providers.length > 0
                                ? Container(
                                    child: ListView.builder(
                                      itemCount: providers.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Card(
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator
                                                        .pushNamedAndRemoveUntil(
                                                      context,
                                                      '/provider-detail',
                                                      arguments:
                                                          providers[index]
                                                              .providerDetail
                                                              .id,
                                                      (route) => true,
                                                    );
                                                  },
                                                  child: Container(
                                                    child: Column(
                                                      children: [
                                                        Image(
                                                            image: AssetImage(
                                                                img_default_laundry_placeholder)),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
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
                                                                      Wrap(
                                                                        children:
                                                                            List.generate(
                                                                          5,
                                                                          (index) =>
                                                                              ImageIcon(
                                                                            AssetImage(ic_star_fill),
                                                                            size:
                                                                                16,
                                                                            color:
                                                                                Color(0XFFFFBD00),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        "5.0",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                    '\u{20B9}${providers[index].providerDetail.serviceLists[0].price}',
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
                                                                child: Stack(
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                      child:
                                                                          ImageIcon(
                                                                        AssetImage(
                                                                            ic_fill_profile),
                                                                        size:
                                                                            30,
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
                                              image: AssetImage(coming_soon),
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
                          },
                          error: (err, s) => Text(err.toString()),
                          loading: () => Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   final _data = ref.watch( categoryProvidersListDataProvider(serviceName!));
  //
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Vehicle Services"),
  //       leading: GestureDetector(
  //         child: Icon( Icons.arrow_back_ios, color: Colors.black,  ),
  //         onTap: () {
  //           Navigator.pop(context);
  //         } ,
  //       ) ,
  //       backgroundColor: primaryColor,
  //       titleTextStyle: TextStyle(
  //           color: Colors.white,
  //           fontFamily: "Work Sans",
  //           fontSize: 18,
  //           fontWeight: FontWeight.w800),
  //     ),
  //     body: SafeArea(
  //       child: Container(
  //         child: _data.when(
  //           data: (_data) {
  //             List<ProvidersByCategoryResponse> providers =
  //                 _data.map((e) => e).toList();
  //             print(providers.length);
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   SizedBox(
  //                     height: 20,
  //                   ),
  //                   Align(
  //                     alignment: Alignment.topLeft,
  //                     child: Text(
  //                       "Service Types",
  //                       style: TextStyle(
  //                           fontSize: 20,
  //                           fontWeight: FontWeight.w800,
  //                           fontFamily: 'Work Sans'),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 5,
  //                   ),
  //                   Container(
  //                     child: Container(
  //                       height: 130,
  //                       child: ListView(
  //                         scrollDirection: Axis.horizontal,
  //                         children: [
  //                           ServiceTypes(
  //                             servicename: vehicleServices[0],
  //                             iconName: vehicleServicesIcons[0],
  //                             selectedSearch: () {
  //                               setState(() {
  //                                 searchedService = vehicleServices[0];
  //                                 serviceName= searchedService;
  //                               });
  //                             },
  //                             isSearchedEnabled:
  //                                 searchedService == vehicleServices[0]
  //                                     ? true
  //                                     : false,
  //                           ),
  //                           ServiceTypes(
  //                             servicename: vehicleServices[1],
  //                             iconName: vehicleServicesIcons[1],
  //                             selectedSearch: () {
  //                               setState(() {
  //                                 searchedService = vehicleServices[1];
  //                                 serviceName= searchedService;
  //                               });
  //                             },
  //                             isSearchedEnabled:
  //                                 searchedService == vehicleServices[1]
  //                                     ? true
  //                                     : false,
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 20,
  //                   ),
  //                   Expanded(
  //                       child: ListView.builder(
  //                     itemCount: providers.length,
  //                     itemBuilder: (context, index) {
  //                       return Padding(
  //                         padding: const EdgeInsets.all(10.0),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Card(
  //                               child: InkWell(
  //                                 onTap: () {
  //                                   Navigator.push(context,
  //                                       MaterialPageRoute(builder: (context) {
  //                                     return ProviderDetailScreen();
  //                                   }));
  //                                 },
  //                                 child: Container(
  //                                   child: Column(
  //                                     children: [
  //                                       Image(
  //                                           image: AssetImage(
  //                                               img_default_laundry_placeholder)),
  //                                       SizedBox(
  //                                         height: 20,
  //                                       ),
  //                                       Padding(
  //                                         padding: const EdgeInsets.only(right: 20),
  //                                         child: Container(
  //                                           child: Row(
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment.spaceBetween,
  //                                             children: [
  //                                               Container(
  //                                                 child: Row(
  //                                                   children: [
  //                                                     SizedBox(
  //                                                       width: 10,
  //                                                     ),
  //                                                     Wrap(
  //                                                       children: List.generate(
  //                                                         5,
  //                                                         (index) => ImageIcon(
  //                                                           AssetImage(
  //                                                               ic_star_fill),
  //                                                           size: 16,
  //                                                           color:
  //                                                               Color(0XFFFFBD00),
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //                                                     SizedBox(
  //                                                       width: 10,
  //                                                     ),
  //                                                     Text(
  //                                                       "5.0",
  //                                                       style:
  //                                                           TextStyle(fontSize: 16),
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                               Container(
  //                                                 child: Text(
  //                                                   '\u{20B9}${providers[index].providerDetail.serviceLists[0].price}',
  //                                                   style: TextStyle(
  //                                                       fontSize: 16,
  //                                                       fontWeight: FontWeight.w800,
  //                                                       fontFamily: 'Work Sans'),
  //                                                 ),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       Container(
  //                                         child: Row(
  //                                           children: [
  //                                             Container(
  //                                               decoration: BoxDecoration(
  //                                                   border: Border.all(
  //                                                       color: primaryColor),
  //                                                   shape: BoxShape.circle,
  //                                                   color: Colors.white),
  //                                               child: Stack(
  //                                                 children: [
  //                                                   Align(
  //                                                     alignment: Alignment.topLeft,
  //                                                     child: ImageIcon(
  //                                                       AssetImage(ic_fill_profile),
  //                                                       size: 30,
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                             SizedBox(
  //                                               width: 10,
  //                                             ),
  //                                             Container(
  //                                               child: Text(
  //                                                 providers[index]
  //                                                     .providerDetail
  //                                                     .name,
  //                                                 style: TextStyle(
  //                                                     fontFamily: 'Work Sans',
  //                                                     fontSize: 16,
  //                                                     fontWeight: FontWeight.w800),
  //                                               ),
  //                                             )
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       );
  //                     },
  //                   ))
  //                 ],
  //               ),
  //             );
  //           },
  //           error: (err, s) => Text(err.toString()),
  //           loading: () => Center(
  //             child: CircularProgressIndicator(),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
