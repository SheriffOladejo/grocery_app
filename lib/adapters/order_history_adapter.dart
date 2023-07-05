import 'package:flutter/material.dart';
import 'package:grocery_app/models/order_detail.dart';
import 'package:grocery_app/utils/hex_color.dart';

class OrderHistoryAdapter extends StatefulWidget {

  OrderDetail order;

  OrderHistoryAdapter({
    this.order,
  });

  @override
  State<OrderHistoryAdapter> createState() => _OrderHistoryAdapterState();

}

class _OrderHistoryAdapterState extends State<OrderHistoryAdapter> {

  int selectedItems = 0;

  @override
  Widget build(BuildContext context) {

    Color statusColor;
    if (widget.order.status == 'processing') {
      statusColor = Colors.grey;
    }
    else if (widget.order.status == 'cancelled') {
      statusColor = Colors.red;
    }
    else if (widget.order.status == 'delivered') {
      statusColor = Colors.green;
    }

    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Container(
        margin: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Image.asset("assets/images/lettuce.png", width: 60, height: 50,),
            Container(width: 15,),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Selected items (${selectedItems.toString()})", style: TextStyle(
                  color: HexColor("#808080"),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  fontFamily: 'inter-medium',
                ),),
                Container(height: 15,),
                Text("Delivery", style: TextStyle(
                  color: HexColor("#808080"),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  fontFamily: 'inter-medium',
                ),),
                Container(height: 15,),
                Text("Order total", style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'inter-medium',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),),
                Container(height: 15,),
                Container(
                  height: 15,
                  width: 40,
                  alignment: Alignment.center,
                  color: statusColor,
                  child: Text(
                    widget.order.status,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'inter-medium',
                      fontWeight: FontWeight.w500,
                      fontSize: 6
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("\$ ${widget.order.totalItemsCost.toStringAsFixed(2)}", style: TextStyle(
                  color: HexColor("#808080"),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  fontFamily: 'inter-medium',
                ),),
                Container(height: 15,),
                Text("\$ ${widget.order.deliveryPrice.toStringAsFixed(2)}", style: TextStyle(
                  color: HexColor("#808080"),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  fontFamily: 'inter-medium',
                ),),
                Container(height: 15,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("\$", style: TextStyle(
                      color: HexColor("#808080"),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      fontFamily: 'inter-medium',
                    ),),
                    Text("${widget.order.orderTotal.toStringAsFixed(1)}", style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'inter-medium',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),),
                  ],
                ),

              ],
            )
          ],
        ),
      ),
    );
  }

}
