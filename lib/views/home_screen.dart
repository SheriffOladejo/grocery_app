import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/adapters/category_adapter.dart';
import 'package:grocery_app/adapters/item_adapter.dart';
import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/models/item.dart';
import 'package:grocery_app/utils/db_helper.dart';
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
  List<Item> retailList = [];
  List<Item> wholesaleList = [];

  bool showRetail = true;

  int cartCount = 0;

  var db_helper = DbHelper();

  bool isLoading = false;

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
                      "${cartCount.toString()}",
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
        child: isLoading ? Center(child: CircularProgressIndicator(),) : Column(
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
                  itemCount: categoryList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CategoryAdapter(category: categoryList[index],);
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
                itemBuilder: (_, index) => ItemAdapter(item: showRetail ? retailList[index] : wholesaleList[index], showWholesalePrice: !showRetail,),
                itemCount: showRetail ? retailList.length : wholesaleList.length,
              ),
            )
          ],
        )
      ),
    );
  }

  Future<void> init () async {
    categoryList = await db_helper.getCategories();
    itemList = await db_helper.getItems();
    if (itemList.isEmpty) {
      await getItems();
    }
    if (categoryList.isEmpty) {
      await getCategories();
    }
    retailList = await db_helper.getRetailItems();
    wholesaleList = await db_helper.getWholesaleItems();
    List<Item> cart = await db_helper.getCart();
    cartCount = cart.length;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getCategories () async {
    setState(() {
      isLoading = true;
    });
    final snapshot = await FirebaseDatabase.instance.ref().child('data/categories/').get();
    final list = snapshot.children;
    list.forEach((element) async {
      var c = Category(
        id: int.parse(element.child("id").value.toString()),
        title: element.child("title").value,
        image: element.child("image").value,
      );
      print("saving ${c.title}");
      await db_helper.saveCategory(c);
    });
    categoryList = await db_helper.getCategories();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getItems () async {
    setState(() {
      isLoading = true;
    });
    final snapshot = await FirebaseDatabase.instance.ref().child('data/items/').get();
    final list = snapshot.children;
    list.forEach((element) async {
      var i = Item(
        id: int.parse(element.child("id").value.toString()),
        stockCount: element.child("stockCount").value,
        itemName: element.child("itemName").value,
        description: element.child("description").value,
        category: element.child("category").value,
        image: element.child("image").value,
        isBuyingWholesale: element.child("isBuyingWholesale").value,
        wholesaleImage: element.child("image").value,
        favorite: element.child("favorite").value,
        wholesalePrice: double.parse(element.child("wholesalePrice").value.toString()),
        wholesaleUnit: element.child("wholesaleUnit").value,
        buyingCount: element.child("buyingCount").value,
        retailPrice: double.parse(element.child("retailPrice").value.toString()),
        discount: double.parse(element.child("discount").value.toString()),
      );
      print("saving ${i.itemName}");
      await db_helper.saveItem(i);
    });
    itemList = await db_helper.getItems();
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
