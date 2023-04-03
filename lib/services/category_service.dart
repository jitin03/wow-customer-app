
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mistry_customer/model/provider_by_category_list_response.dart';
import 'package:mistry_customer/model/provider_detail_response.dart';
import 'package:mistry_customer/services/auth_service.dart';
import 'package:mistry_customer/services/shared_service.dart';
import 'package:mistry_customer/utils/config.dart';


class CategoryService{
  static var client = http.Client();


  Future<List<ProvidersByCategoryResponse>> getProvidersByCategory(String categoryName) async {

    var loginDetails = await SharedService.loginDetails();

    print(await SharedService.getCustomerId());

    final queryParameters = {
      'categoryName': categoryName,
    };
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer ${loginDetails!.accessToken}'
    };
    var url = Uri.http(
        Config.apiURL,
        Config.providersForCategoryAPI,queryParameters
    );
    print(url);
    Response response = await http.get(url,headers: requestHeaders);

    if (response.statusCode == 200) {
      return providersByCategoryResponseFromJson(response.body);
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }

  Future<ProviderDetailResponse> getProviderById(String id) async {

    var loginDetails = await SharedService.loginDetails();




    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer ${loginDetails!.accessToken}'
    };
    var url = Uri.http(
        Config.apiURL,
        Config.providerDetailByIdAPI+id
    );

    Response response = await http.get(url,headers: requestHeaders);
    print(response.body);
    if (response.statusCode == 200) {
      // await SharedService.setCustomerId(
      //   provideProfileFromJson(response.body).id.toString(),
      // );
      return provideProfileFromJson(response.body);
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }
}
final categoryServiceProvider =
Provider<CategoryService>((ref) => CategoryService());