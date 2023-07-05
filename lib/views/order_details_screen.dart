import 'package:flutter/material.dart';
import 'package:grocery_app/adapters/order_details_adapter.dart';
import 'package:grocery_app/models/order_detail.dart';

class OrderDetailsScreen extends StatefulWidget {

  const OrderDetailsScreen({Key key}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();

}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  List<OrderDetail> orderList = [];

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
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
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

}
