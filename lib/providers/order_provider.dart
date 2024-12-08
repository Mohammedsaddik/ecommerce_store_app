import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_store_app/models/order_model.dart';
import 'package:ecommerce_store_app/models/product_model.dart';
import 'package:ecommerce_store_app/providers/product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class OrdersProvider with ChangeNotifier {
  final List<OrdersModelAdvanced> orders = [];
  List<OrdersModelAdvanced> get getOrders => orders;

  final usersDB = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;

  Future<List<OrdersModelAdvanced>> fetchOrder() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    var uid = user!.uid;
    try {
      await FirebaseFirestore.instance
          .collection("ordersAdanced")
          .get()
          .then((orderSnapshot) {
        orders.clear();
        for (var element in orderSnapshot.docs) {
          orders.insert(
            0,
            OrdersModelAdvanced(
              orderId: element.get('orderId'),
              productId: element.get('productId'),
              userId: element.get('userId'),
              price: element.get('price').toString(),
              productTitle: element.get('productTitle').toString(),
              quantity: element.get('quantity').toString(),
              imageUrl: element.get('imageUrl'),
              userName: element.get('userName'),
              orderDate: element.get('orderDate'),
            ),
          );
        }
      });
      return orders;
    } catch (e) {
      rethrow;
    }
  }

  double getTotalPrice({required ProductProvider productProvider}) {
    double total = 0.0;

    for (var order in orders) {
      final ProductModel? getProduct =
          productProvider.findByProdId(order.productId);

      if (getProduct != null) {
        double price = double.parse(getProduct.productPrice);
        total += price * double.parse(order.quantity.toString());
      }
    }

    return total;
  }

  Future<void> clearOrderFromFirebase({required String orderId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('ordersAdanced')
          .doc(orderId)
          .delete();
      orders.clear();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeOrderFromFirebase({
    required String orderId,
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    try {
      await FirebaseFirestore.instance
          .collection('ordersAdanced') // Replace with your collection name
          .doc(orderId) // Provide the document ID to delete
          .delete();
      orders.removeWhere((order) => order.orderId == orderId);
      await fetchOrder();
    } catch (e) {
      print('Error removing order: $e');
    }
    notifyListeners();
  }
}
