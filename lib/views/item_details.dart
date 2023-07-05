import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/adapters/item_adapter.dart';
import 'package:grocery_app/models/item.dart';
import 'package:grocery_app/utils/hex_color.dart';

class ItemDetails extends StatefulWidget {

  Item item;
  bool showWholesalePrice;

  ItemDetails({this.item, this.showWholesalePrice});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();

}

class _ItemDetailsState extends State<ItemDetails> {

  int cartCount;

  int selectedCount = 0;

  List<Item> relatedProducts = [];

  String stock = "";
  bool inStock = false;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.black,),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset("assets/images/cart.png",),
              cartCount == 0 ? Container(width: 0, height: 0,) : Container(
                width: 30,
                height: 30,
                alignment: Alignment.topRight,
                child: Container(
                  alignment: Alignment.center,
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: HexColor("#66906A"),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(
                    "2",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontFamily: 'inter-medium',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(width: 20,),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(right: 5),
                alignment: Alignment.centerRight,
                child: Icon(widget.item.favorite == "true" ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                  color: widget.item.favorite == "true" ? Colors.red : Colors.grey,),
              ),
              Container(height: 5,),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/images/lettuce.png", width: 330, height: 235,)
              ),
              Container(height: 10,),
              Text(widget.item.itemName, style: TextStyle(
                color: Colors.black,
                fontFamily: 'inter-bold',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),),
              Container(height: 5,),
              Text("\$${widget.item.retailPrice}", style: TextStyle(
                color: Colors.black,
                fontFamily: 'inter-bold',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                decoration: widget.showWholesalePrice ? TextDecoration.lineThrough : TextDecoration.none,
              ),),
              Container(height: 5,),
              widget.showWholesalePrice ? Text("\$${widget.item.wholesalePrice}", style: TextStyle(
                color: Colors.black,
                fontFamily: 'inter-bold',
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),) : Container(width: 0, height: 0,),
              Container(height: 8,),
              Text(stock, style: TextStyle(
                color: inStock ? Colors.green : Colors.red,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
                fontSize: 8,
              )),
              Container(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (selectedCount != 0) {
                        if (widget.showWholesalePrice) {
                          selectedCount = int.parse((selectedCount - widget.item.wholesaleUnit).toString());
                        }
                        else {
                          selectedCount--;
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
                        color: selectedCount == 0 ? Colors.grey : Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Icon(CupertinoIcons.minus, color: Colors.white, size: 20,),
                    ),
                  ),
                  Text("$selectedCount", style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'inter-bold',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),),
                  GestureDetector(
                    onTap: () {
                      if (selectedCount != widget.item.stockCount) {
                        if (widget.showWholesalePrice) {
                          selectedCount = int.parse((selectedCount + widget.item.wholesaleUnit).toString());
                        }
                        else {
                          selectedCount++;
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
                        color: selectedCount == widget.item.stockCount ? Colors.grey : Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Icon(CupertinoIcons.plus, color: Colors.white, size: 20,),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 35,
                    alignment: Alignment.center,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: MaterialButton(
                      color: HexColor("#66906A"),
                      onPressed: () {
                        // add to cart
                      },
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                      elevation: 5,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset("assets/images/cart_.png", width: 24, height: 24,),
                          const Text("Add to cart", style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'inter-medium',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(height: 10,),
              Text("Related products", style: TextStyle(
                color: Colors.black,
                fontFamily: 'inter-bold',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),),
              Container(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: isLoading ? Center(child: CircularProgressIndicator(),) : ListView.builder(
                    shrinkWrap: true,
                    itemCount: relatedProducts.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) => ItemAdapter(item: relatedProducts[index], showWholesalePrice: widget.showWholesalePrice,),
              ),
              )],
          ),
        ),
      ),
    );
  }

  Future<void> init() async {
    setState(() {
      isLoading = true;
    });
    for (var i = 0; i < 12; i++) {
      relatedProducts.add(Item(
        itemName: "Lettuce plant",
        stockCount: 7,
        category: "Vegetables",
        image: "assets/images/lettuce.png",
        discount: 10,
        wholesalePrice: 25,
        wholesaleUnit: 5,
        retailPrice: 27,
        favorite: "true",
      ));
    }
    if (widget.item.stockCount > 5) {
      stock = "In stock";
      inStock = true;
    }
    else if (widget.item.stockCount <= 5) {
      stock = "${widget.item.stockCount} left";
      inStock = false;
    }
    else if (widget.item.stockCount == 0) {
      stock = "Out of stock";
      inStock = false;
      // delete item from db
    }
    //relatedProducts = await getRelatedProducts(widget.item.category);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

}
