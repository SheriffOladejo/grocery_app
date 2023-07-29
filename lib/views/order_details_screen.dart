import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/adapters/order_details_adapter.dart';
import 'package:grocery_app/models/app_user.dart';
import 'package:grocery_app/models/order_detail.dart';
import 'package:grocery_app/utils/db_helper.dart';

class OrderDetailsScreen extends StatefulWidget {

  const OrderDetailsScreen({Key key}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();

}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  List<OrderDetail> orderList = [];

  var db_helper = DbHelper();

  bool is_loading = false;
  AppUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Order details", style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: 'inter-bold',
        ),),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              await getOrderUpdate();
            },
            child: Icon(Icons.refresh, color: Colors.black,),
          ),
          Container(width: 15,),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(15),
        child: is_loading ? Center(child: CircularProgressIndicator(),) : ListView.builder(
          itemCount: orderList.length,
          shrinkWrap: true,
          controller: ScrollController(),
          itemBuilder: (context, index) {
            return OrderDetailsAdapter(
              order: orderList[index],
            );
          },
        ),
      ),
    );
  }

  Future<void> getOrderUpdate () async {
    setState(() {
      is_loading = true;
    });
    orderList.clear();
    await db_helper.clearOrderTable();
    final order = await FirebaseDatabase.instance.ref().child('data/orders').get();
    if (order != null) {
      final orderValues = order.children;
      orderValues.forEach((element) async {
        String orderID = element.child("orderID").value;
        int timestamp = int.parse(element.child("orderTimestamp").value.toString());
        double deliveryPrice = double.parse(element.child("deliveryPrice").value.toString());
        double totalItemsCost = double.parse(element.child("totalItemsCost").value.toString());
        double orderTotal = double.parse(element.child("orderTotal").value.toString());
        String ownerID = element.child("ownerID").value;
        String paymentStatus = element.child("paymentStatus").value;
        String desc = element.child("desc").value;
        String selectedItems = element.child("selectedItems").value;
        String invoiceID = element.child("invoiceID").value;
        String deliveryStatus = element.child("deliveryStatus").value;
        OrderDetail order = OrderDetail(
            orderID: orderID,
            orderTotal: orderTotal,
            timestamp: timestamp,
            deliveryStatus: deliveryStatus,
            deliveryPrice: deliveryPrice,
            totalItemsCost: totalItemsCost,
            ownerID: ownerID,
            paymentStatus: paymentStatus,
            desc: desc,
            selectedItems: selectedItems,
            invoice_id: invoiceID
        );
        if (ownerID == user.phoneNumber) {
          await db_helper.saveOrder(order, true, false);
          print("OwnerID: $ownerID and user phone: ${user.phoneNumber}");
        }
      });
    }
    await init();
    setState(() {
      is_loading = false;
    });
  }

  Future<void> init () async {
    orderList.clear();
    setState(() {
      is_loading = true;
    });
    orderList = await db_helper.getOrders();
    if (orderList.isEmpty) {
      final order = await FirebaseDatabase.instance.ref().child('data/orders').get();
      if (order != null) {
        final orderValues = order.children;
        orderValues.forEach((element) async {
          String orderID = element.child("orderID").value;
          int timestamp = int.parse(element.child("orderTimestamp").value.toString());
          double deliveryPrice = double.parse(element.child("deliveryPrice").value.toString());
          double totalItemsCost = double.parse(element.child("totalItemsCost").value.toString());
          double orderTotal = double.parse(element.child("orderTotal").value.toString());
          String ownerID = element.child("ownerID").value;
          String paymentStatus = element.child("paymentStatus").value;
          String desc = element.child("desc").value;
          String selectedItems = element.child("selectedItems").value;
          String invoiceID = element.child("invoiceID").value;
          String deliveryStatus = element.child("deliveryStatus").value;
          OrderDetail order = OrderDetail(
              orderID: orderID,
              orderTotal: orderTotal,
              timestamp: timestamp,
              deliveryStatus: deliveryStatus,
              deliveryPrice: deliveryPrice,
              totalItemsCost: totalItemsCost,
              ownerID: ownerID,
              paymentStatus: paymentStatus,
              desc: desc,
              selectedItems: selectedItems,
              invoice_id: invoiceID
          );
          if (ownerID == user.phoneNumber) {
            orderList.add(order);
          }
        });
      }
    }
    user = await db_helper.getUser();
    setState(() {
      is_loading = false;
    });
  }

  @override
  void initState () {
    super.initState();
    init();
  }

}
