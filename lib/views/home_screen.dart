import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/adapters/category_adapter.dart';
import 'package:grocery_app/adapters/item_adapter.dart';
import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/models/item.dart';
import 'package:grocery_app/utils/hex_color.dart';
import 'package:grocery_app/utils/methods.dart';
import 'package:grocery_app/views/cart_screen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  var searchController = TextEditingController();

  List<Category> categoryList = [];
  List<Item> itemList = [];

  bool showRetail = true;

  int cartCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Image.asset("assets/images/home_location.png"),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Deliver to", style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontFamily: 'inter-medium',
              fontSize: 14,
            ),),
            Container(height: 5,),
            InkWell(
              onTap: () {

              },
              child: Row(
                children: [
                  Text("Sector 7, OONI layout", style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'inter-medium',
                    fontWeight: FontWeight.w500,
                  ),),
                  Container(width: 5,),
                  Icon(CupertinoIcons.chevron_down, color: Colors.black, size: 12,),
                ],
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, slideLeft(const CartScreen()));
            },
            child: Stack(
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
          ),
          Container(width: 20,),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'inter-medium',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            Container(height: 15,),
            Text("Categories", style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'inter-bold',
            ),),
            Container(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 11,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CategoryAdapter();
                  }),
            ),
            Container(height: 15,),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        if (!showRetail) {
                          showRetail = true;
                        }
                        setState(() {

                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        width: (MediaQuery.of(context).size.width - 50) / 2,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          color: showRetail ? HexColor("#66906A") : HexColor("#1A66906A"),
                        ),
                        child: Text("Retail", style: TextStyle(
                          color: showRetail ? Colors.white : HexColor("#66906A"),
                          fontFamily: 'inter-medium',
                          fontSize: 14,
                        )),
                      ),
                    ),
                    Container(width: 5,),
                    InkWell(
                      onTap: () {
                        if (showRetail) {
                          showRetail = false;
                        }
                        setState(() {

                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: (MediaQuery.of(context).size.width - 50) / 2,
                        alignment: Alignment.center,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          color: !showRetail ? HexColor("#66906A") : HexColor("#1A66906A"),
                        ),
                        child: Text("Wholesale", style: TextStyle(
                          color: !showRetail ? Colors.white : HexColor("#66906A"),
                          fontFamily: 'inter-medium',
                          fontSize: 14,
                        )),
                      ),
                    ),
                  ]
              ),
            ),
            Container(height: 15,),
            Container(
              height: MediaQuery.of(context).size.height - 410,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: showRetail ? 230 : 240),
                itemBuilder: (_, index) => ItemAdapter(item: itemList[index], showWholesalePrice: !showRetail,),
                itemCount: itemList.length,
              ),
            )
          ],
        )
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 12; i++) {
      itemList.add(Item(
        itemName: "Lettuce plant",
        stockCount: 15,
        category: "Vegetables",
        image: "assets/images/lettuce.png",
        wholesaleImage: "assets/images/lettuce.png",
        discount: 10.0,
        wholesalePrice: 750.0,
        wholesaleUnit: 5,
        retailPrice: 200.0,
        favorite: "true",
      ));
    }
  }

}
