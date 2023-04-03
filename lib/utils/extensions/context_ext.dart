import 'package:flutter/material.dart';
import 'package:mistry_customer/locale/base_language.dart';


extension ContextExt on BuildContext {
  Languages get translate => Languages.of(this);
}
