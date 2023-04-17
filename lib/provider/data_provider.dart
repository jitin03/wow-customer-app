import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mistry_customer/model/billing_response_model.dart';
import 'package:mistry_customer/model/booking_request.dart';
import 'package:mistry_customer/model/create_booking_order.dart';
import 'package:mistry_customer/model/create_booking_order_response.dart';
import 'package:mistry_customer/model/customer_booking_response.dart';
import 'package:mistry_customer/model/customer_profile_response_bck.dart';
import 'package:mistry_customer/model/customer_review_request.dart';
import 'package:mistry_customer/model/customer_reviews_response.dart';
import 'package:mistry_customer/model/login_response_model.dart';
import 'package:mistry_customer/model/notification_response.dart';
import 'package:mistry_customer/model/provider_by_category_list_response.dart';
import 'package:mistry_customer/model/provider_detail_response.dart';
import 'package:mistry_customer/model/request_otp_response.dart';
import 'package:mistry_customer/model/update_booking_status.dart';
import 'package:mistry_customer/model/user_model.dart';
import 'package:mistry_customer/services/auth_service.dart';
import 'package:mistry_customer/services/booking_service.dart';
import 'package:mistry_customer/services/category_service.dart';
import 'package:mistry_customer/services/customer_service.dart';
import 'package:mistry_customer/services/notifications_service.dart';
import 'package:mistry_customer/services/shared_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/shared_preference_helper.dart';
import '../model/update_booking_request.dart';
import '../services/review_service.dart';

final categoryProvidersListDataProvider = FutureProvider.autoDispose
    .family<List<ProvidersByCategoryResponse>, String>(
        (ref, categoryName) async {
  return ref
      .watch(categoryServiceProvider)
      .getProvidersByCategory(categoryName);
});
final sharedPreferences =
FutureProvider((_) async => await SharedPreferences.getInstance());
final sharedPreferencesHelper = Provider(
        (ref) => SharedPreferencesHelper(ref.watch(sharedPreferences).maybeWhen(
      data: (value) => value,
      orElse: () => null,
    )));

final bookingDetailDataProvider = FutureProvider.autoDispose
    .family<List<BookingResponse>, String>((ref, id) async {
  return ref.watch(bookingServiceProvider).getCustomerBooking(id);
});

final bookingServiceDataProvider =
    FutureProvider.autoDispose<List<CustomerBookingResponse>>((ref) async {
  return ref.watch(bookingServiceProvider).getCustomerBookings();
});

final customerServiceDataProvider =
    FutureProvider.autoDispose<CustomerProfileRequest>((ref) async {
  return ref.watch(customerServiceProvider).getCustomerProfileByPhoneNo();
});

final customerProfileDataProvider =
    FutureProvider.autoDispose<CustomerProfileRequest>((ref) async {
  return ref.watch(customerServiceProvider).getCustomerProfileById();
});

final providerDetailDataProvider = FutureProvider.autoDispose
    .family<ProviderDetailResponse, String>((ref, id) async {
  return ref.watch(categoryServiceProvider).getProviderById(id);
});

class CustomerReviewNotifier extends ChangeNotifier {
  CustomerReviewNotifier(this.ref) : super();
  final Ref ref;

  Future<String> createCustomerReview(CustomerReviewRequest request) async {
    final service = ref.read(reviewServiceProvider);
    late String resp;

    resp = await service.createCustomerReview(request);
    return resp;
  }
  Future<String> createCustomerFeedback(CustomerFeedbackRequest request) async {
    final service = ref.read(reviewServiceProvider);
    late String resp;

    resp = await service.createCustomerFeedback(request);
    return resp;
  }
}


class BookingNotificationNotifier extends ChangeNotifier {
  BookingNotificationNotifier(this.ref) : super();
  final Ref ref;
  Future<List<NotificationResponse>> getNotifications(String  bookingId) async {
    final service = ref.read(notificationServiceProvider);
    late List<NotificationResponse> resp;

    resp = await service.getBookingNotification(bookingId);
    return resp;
  }

}
final notificationProvider = ChangeNotifierProvider.autoDispose((ref) {
  return BookingNotificationNotifier(ref);
});



final providerReviewDataProvider = FutureProvider.autoDispose
    .family<List<CustomerReviewsResponse>, String>((ref, id) async {
  return ref.watch(reviewServiceProvider).getProviderReviews(id);
});


final providerNotificationDataProvider = FutureProvider.autoDispose
    .family<List<NotificationResponse>, String>((ref, id) async {
  return ref.watch(notificationServiceProvider).getBookingNotification(id);
});

final shareServiceDataProvider = FutureProvider.autoDispose<void>((ref) async {
  return ref.read(sharedServiceProvider).logout();
});

final providerDetailsData = FutureProvider.autoDispose
    .family<ProviderDetailsData, String>((ref, providerId) async {
  final providerReview =
      ref.watch(reviewServiceProvider).getProviderReviews(providerId);

  final providerDetails =
      ref.watch(categoryServiceProvider).getProviderById(providerId);

  return ProviderDetailsData(
    providerReviews: await providerReview,
    providerDetails: await providerDetails,
  );
});

class ProviderDetailsData {
  final List<CustomerReviewsResponse> providerReviews;
  final ProviderDetailResponse providerDetails;
  ProviderDetailsData(
      {required this.providerReviews, required this.providerDetails});
}

class CustomerBookingNotifier extends ChangeNotifier {
  CustomerBookingNotifier(this.ref) : super();
  final Ref ref;

  Future<double> saveCustomerBooking(BookingRequest request) async {
    final service = ref.read(bookingServiceProvider);
    late double resp;

    resp = await service.saveBooking(request);
    return resp;
  }
}

final reviewProvider = ChangeNotifierProvider.autoDispose((ref) {
  return CustomerReviewNotifier(ref);
});

class PaymentOptionButtonState extends StateNotifier<bool> {
  PaymentOptionButtonState(bool isSelected) : super(isSelected);

  void setSelected(bool value) {
    state = value;
  }
}

final paymentOptionButtonsProvider =
    StateProvider<List<PaymentOptionButtonState>>((ref) => [
          PaymentOptionButtonState(false),
          PaymentOptionButtonState(false),
        ]);

final customerBookingProvider = ChangeNotifierProvider.autoDispose((ref) {
  return CustomerBookingNotifier(ref);
});

class BookingOrder extends ChangeNotifier {
  BookingOrder(this.ref) : super();
  final Ref ref;
  Future<CreateBookingOrderResponse> createBookingOrder(
      CreateBookingOrder request) async {
    final service = ref.read(bookingServiceProvider);
    late CreateBookingOrderResponse resp;

    resp = await service.createBookingCashFreeOder(request);
    return resp;
  }

  Future<BookingStatusUpdateResponse> updateBookingStatus(
      BookingStatusUpdateRequest request, String bookingId) async {
    final service = ref.read(bookingServiceProvider);
    late BookingStatusUpdateResponse resp;

    resp = await service.updateBookingStatus(request, bookingId);
    return resp;
  }

  Future<BookingStatusUpdateResponse> updateBookingPaymentMode(
      BookingPaymentUpdateRequest request, String bookingId) async {
    final service = ref.read(bookingServiceProvider);
    late BookingStatusUpdateResponse resp;

    resp = await service.updateBookingPaymentMode(request, bookingId);
    return resp;
  }
}

final bookingOrderProvider = ChangeNotifierProvider.autoDispose((ref) {
  return BookingOrder(ref);
});

class AuthOtpNotifier extends ChangeNotifier {
  AuthOtpNotifier(this.ref) : super();
  final Ref ref;

  Future<RequestOtpResponse> requestOtp(String phoneNo) async {
    final service = ref.read(authServiceProvider);
    late RequestOtpResponse resp;

    resp = await service.getRequestOtp(phoneNo);
    return resp;
  }

  Future<VerifyOtpResonseModel> verifyOtpCode(UserModel request) async {
    final service = ref.read(authServiceProvider);
    late VerifyOtpResonseModel resp;

    resp = await service.verifyUserWithOtp(request);
    return resp;
  }
}

final authOtpProvider = ChangeNotifierProvider.autoDispose((ref) {
  return AuthOtpNotifier(ref);
});
