import 'package:flutter/material.dart';
import 'package:grocery_app/adapters/stock_adapter.dart';
import 'package:grocery_app/models/item.dart';
import 'package:grocery_app/utils/db_helper.dart';
import 'package:grocery_app/utils/hex_color.dart';
import 'package:grocery_app/utils/methods.dart';
import 'package:grocery_app/views/add_item.dart';

class StockManagementScreen extends StatefulWidget {

  const StockManagementScreen({Key key}) : super(key: key);

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();

}

class _StockManagementScreenState extends State<StockManagementScreen> {

  List<Item> stockList = [];
  var db_helper = DbHelper();

  var search_controller = TextEditingController();
  List<Item> searchList = [];

  Future<void> search (String search) async {
    searchList.clear();
    if (search.isNotEmpty) {
      for (var i = 0; i < stockList.length; i++) {
        if (stockList[i].itemName.contains(search)) {
          searchList.add(stockList[i]);
        }
      }
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Stock management", style: TextStyle(
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
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey[500],
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      onChanged: (val) async {
                        await search(search_controller.text);
                      },
                      controller: search_controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 15,),
            Container(
              height: 500,
              child: ListView.builder(
                itemCount: searchList.isNotEmpty ? searchList.length : stockList.length,
                shrinkWrap: true,
                controller: ScrollController(),
                itemBuilder: (context, index) {
                  return StockAdapter(
                    item: searchList.isNotEmpty ? searchList[index] : stockList[index],
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor("#66906A"),
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: () {
          Navigator.push(context, slideLeft(AddItem()));
        },
      ),
    );
  }

  Future<void> init () async {
    stockList = await db_helper.getItems();
    setState(() {

    });
  }

  @override
  void initState () {
    super.initState();
    init();
  }

}
