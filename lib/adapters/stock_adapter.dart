import 'package:flutter/material.dart';
import 'package:grocery_app/models/item.dart';
import 'package:grocery_app/utils/hex_color.dart';
import 'package:grocery_app/utils/methods.dart';
import 'package:grocery_app/views/add_item.dart';

class StockAdapter extends StatefulWidget {

  Item item;
  StockAdapter({
    this.item,
  });

  @override
  State<StockAdapter> createState() => _StockAdapterState();

}

class _StockAdapterState extends State<StockAdapter> {

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      elevation: 3,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        margin: const EdgeInsets.all(15),
        child: Row(
          children: [
            Image.network(widget.item.image),
            Container(width: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.item.itemName.replaceRange(0, 1, widget.item.itemName.substring(0, 1).toUpperCase()), style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'inter-medium',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),),
                Container(height: 8,),
                Text("You have ${widget.item.stockCount.toString()} in stock", style: TextStyle(
                  color: HexColor("#808080"),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  fontFamily: 'inter-medium',
                ),),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () async {
                Navigator.push(context, slideLeft(AddItem(item: widget.item,)));
              },
              child: Icon(Icons.edit, color: HexColor("#66906A"),)
            ),
          ],
        ),
      ),
    );
  }

}
