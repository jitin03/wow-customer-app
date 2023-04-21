import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../provider/data_provider.dart';
import '../utils/config.dart';
import '../utils/images.dart';

class CustomerReviews extends ConsumerStatefulWidget {
  late Object? providerId;
  CustomerReviews({required this.providerId});

  @override
  ConsumerState<CustomerReviews> createState() => _CustomerReviewsState();
}

class _CustomerReviewsState extends ConsumerState<CustomerReviews> {
  @override
  Widget build(BuildContext context) {
    final providerDetails =
        ref.watch(providerDetailsData(widget.providerId.toString()));
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
          title: Text(
            "Customer Reviews",
          ),
          backgroundColor: primaryColor,
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontFamily: "Work Sans",
              fontSize: 18,
              fontWeight: FontWeight.w800),
        ),
        body: providerDetails.when(
          data: (_data) {
            return Container(
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                shape: BoxShape.circle,
                                color: Colors.white),
                            child: ClipOval(
                              child: Material(
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

                          Flexible(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          _data.providerReviews[index].customerProfile!
                                              .name!,
                                          style: TextStyle(
                                              fontFamily: 'Work Sans',
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(

                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            RatingBarIndicator(
                                              rating: double.parse(
                                                  _data!.providerReviews[index].rating!),
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
                                              _data!.providerReviews[index].rating
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Work Sans',
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(DateFormat('dd MMM yyyy').format(
                                        DateTime.parse(_data
                                            .providerReviews[index]
                                            .createDate!))),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      _data.providerReviews[index].reviewMessage!,
                                      // overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: 10,
                          // ),

                        ],
                      ));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 20,
                  );
                },
              ),
            );
          },
          error: (err, s) => Text("asd" + err.toString()),
          loading: () => Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}
