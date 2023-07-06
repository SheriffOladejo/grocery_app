import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/models/item.dart';

class CartAdapter extends StatefulWidget {

  Item item;
  CartAdapter({
    this.item
  });

  @override
  State<CartAdapter> createState() => _CartAdapterState();
}

class _CartAdapterState extends State<CartAdapter> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      elevation: 3,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
        color: Colors.white,
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Image.network(widget.item, width: 90, height: 75,),
            Container(width: 15,),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(widget.item.itemName, style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'inter-medium',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),),
                ),
                Container(height: 5,),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("\$${widget.item.retailPrice}", style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'inter-bold',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    decoration: widget.item.isBuyingWholesale == "true" ? TextDecoration.lineThrough : TextDecoration.none,
                  ),),
                ),
                Container(height: 5,),
                widget.item.isBuyingWholesale == "true" ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("\$${widget.item.wholesalePrice}", style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'inter-bold',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),),
                ) : Container(width: 0, height: 0,),
                Container(height: 5,),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.item.buyingCount != 0) {
                            if (widget.item.isBuyingWholesale == "true") {
                              widget.item.buyingCount = int.parse((widget.item.buyingCount - widget.item.wholesaleUnit).toString());
                            }
                            else {
                              widget.item.buyingCount--;
                            }
                            setState(() {

                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: widget.item.buyingCount == 0 ? Colors.grey : Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Icon(CupertinoIcons.minus, color: Colors.white, size: 20,),
                        ),
                      ),
                      Container(width: 15,),
                      Text("${widget.item.buyingCount}", style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'inter-bold',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),),
                      Container(width: 15,),
                      GestureDetector(
                        onTap: () {
                          if (widget.item.buyingCount != widget.item.stockCount) {
                            if (widget.item.isBuyingWholesale == 'true') {
                              widget.item.buyingCount = int.parse((widget.item.buyingCount + widget.item.wholesaleUnit).toString());
                            }
                            else {
                              widget.item.buyingCount++;
                            }
                            setState(() {

                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: widget.item.buyingCount == widget.item.stockCount ? Colors.grey : Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Icon(CupertinoIcons.plus, color: Colors.white, size: 20,),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              child: Image.asset("assets/images/trash.png")
            )
          ],
        ),
      ),
    );
  }
}
