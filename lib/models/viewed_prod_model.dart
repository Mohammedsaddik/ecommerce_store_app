import 'package:flutter/foundation.dart';

class ViewedProdModel with ChangeNotifier {
  final String id;
  final String productId;

  ViewedProdModel({
    required this.id,
    required this.productId,
  });
}
