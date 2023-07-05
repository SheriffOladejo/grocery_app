import 'package:flutter/material.dart';
import 'package:grocery_app/models/order_detail.dart';
import 'package:grocery_app/utils/hex_color.dart';
import 'package:intl/intl.dart';

class OrderDetailsAdapter extends StatefulWidget {

  OrderDetail order;
  OrderDetailsAdapter({this.order});

  @override
  State<OrderDetailsAdapter> createState() => _OrderDetailsAdapterState();

}

class _OrderDetailsAdapterState extends State<OrderDetailsAdapter> {

  @override
  Widget build(BuildContext context) {

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(widget.order.timestamp);
    DateFormat formatter = DateFormat('d MMM y');
    String formattedDate = formatter.format(dateTime);

    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      elevation: 3,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedDate, style: TextStyle(
              color: HexColor("#808080"),
              fontWeight: FontWeight.w500,
              fontSize: 12,
              fontFamily: 'inter-medium',
            ),),
            Container(height: 8,),
            Text(widget.order.status, style: TextStyle(
              color: Colors.black,
              fontFamily: 'inter-medium',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),),
            Container(height: 8,),
            Text(widget.order.desc, style: TextStyle(
              color: HexColor("#808080"),
              fontWeight: FontWeight.w500,
              fontSize: 12,
              fontFamily: 'inter-medium',
            ),),
          ],
        ),
      ),
    );
  }

}
