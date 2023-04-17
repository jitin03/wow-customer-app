

class Cart {
  Cart({
    this.id,
    this.title,
    this.price,

    this.count = 1,
  });

  Cart.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];

    count = 1;
  }

  int? id;
  String? title;
  double? price;
  int? count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['price'] = price;

    return map;
  }

  Cart copyWith({
    int? id,
    String? title,

  }) {
    return Cart(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,

    );
  }
}
