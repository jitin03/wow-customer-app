import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/cart.dart';
import '../model/preferences.dart';
import 'data_provider.dart';


final totalAmountProvider = StateProvider((ref) {
  final cartItems = ref.watch(cartListProvider).list;
  double totalAmount = 0.0;
  for (var item in cartItems) {
    totalAmount += item.price! * item.count!;
  }
  return totalAmount;
  // return ref
  //     .watch(cartListProvider)
  //     .list
  //     .map((e) => Tuple2(double.parse(e.price.toString()), e.count!))
  //     .fold<double>(
  //     0.0,
  //         (previousValue, element) =>
  //     previousValue + element.item1 * element.item2);
});

final refreshCart = StateProvider((ref) => false);

final cartListProvider = ChangeNotifierProvider((ref) {
  return CartList(ref);
});

class CartList extends ChangeNotifier {
  List<Cart> list = [];
  Ref ref;

  CartList(this.ref) {
    refresh();
  }

  void refresh() {
    list = ref
        .read(sharedPreferencesHelper)
        .getObjectList(Preferences.cart, (v) => Cart.fromJson(v));
    notifyListeners();
  }

  void increment(int index) {

    list[index].count = list[index].count! + 1;
    
    notifyListeners();
  }

  void decrement(int index) {
    if (list[index].count! > 0) {
      list[index].count = list[index].count! - 1;
      notifyListeners();
    }
  }
}
