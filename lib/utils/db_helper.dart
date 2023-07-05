import 'package:grocery_app/models/app_user.dart';
import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/models/item.dart';
import 'package:grocery_app/utils/methods.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {

  DbHelper._createInstance();

  String db_name = "grocery_app.db";

  static Database _database;
  static DbHelper helper;

  String category_table = "category_table";
  String col_cat_id = "id";
  String col_cat_title = "title";
  String col_cat_image = "image";

  String item_table = "item_table";
  String col_item_id = "id";
  String col_item_name = "name";
  String col_item_desc = "description";
  String col_item_category = "category";
  String col_item_image = "image";
  String col_item_wholesale_image = "wholesale_image";
  String col_item_stock_count = "stock_count";
  String col_item_wholesale_price = "wholesale_price";
  String col_wholesale_unit = "unit";
  String col_retail_price = "retail_price";

  String user_table = "user_table";
  String col_email = "email";
  String col_userID = "userID";
  String col_deliveryAddress = "deliveryAddress";
  String col_phoneNumber = "phoneNumber";
  String col_favorites = "favorites";

  Future createDb(Database db, int version) async {

    String create_category_table = "create table $category_table ("
        "$col_cat_id integer primary key,"
        "$col_cat_title varchar(20),"
        "$col_cat_image text)";

    String create_user_table = "create table $user_table ("
        "$col_userID text,"
        "$col_deliveryAddress text,"
        "$col_phoneNumber text,"
        "$col_email text,"
        "$col_favorites text)";

    String create_items_table = "create table $item_table ("
        "$col_item_name varchar(20),"
        "$col_item_id integer primary key,"
        "$col_item_desc text,"
        "$col_item_category varchar(20),"
        "$col_item_image text,"
        "$col_item_wholesale_image text,"
        "$col_item_wholesale_price double,"
        "$col_wholesale_unit integer,"
        "$col_retail_price double,"
        "$col_item_stock_count integer)";

    await db.execute(create_category_table);
    await db.execute(create_items_table);
    await db.execute(create_user_table);
  }

  Future<void> saveCategory (Category cat) async {
    Database db = await database;
    String query = "insert into $category_table ($col_cat_id, $col_cat_image, $col_cat_title) values ("
        "${cat.id}, '${cat.image}', '${cat.title}')";
    try {
      await db.execute(query);
    }
    catch(e) {
      print("db_helper.saveCategory error: ${e.toString()}");
      showToast("Category not saved");
    }
  }

  Future<List<Category>> getCategories () async {
    List<Category> list = [];
    Database db = await database;
    String query = "select * from $category_table";
    List<Map<String, Object>> result = await db.rawQuery(query);
    for (int i = 0; i < result.length; i++) {
      Category cat = Category(
        id: result[i][col_cat_id],
        image: result[i][col_cat_image],
        title: result[i][col_cat_title],
      );
      list.add(cat);
    }
    return list;
  }

  Future<AppUser> getUser () async {
    Database db = await database;
    String query = "select * from $user_table";
    List<Map<String, Object>> result = await db.rawQuery(query);
    AppUser user;
    for (int i = 0; i < result.length; i++) {
      user = AppUser(
        userID: result[i][col_userID].toString(),
        email: result[i][col_email].toString(),
        phoneNumber: result[i][col_phoneNumber].toString(),
        deliveryAddress: result[i][col_deliveryAddress].toString()
      );
    }
    return user;
  }

  Future<void> saveUser (AppUser user) async {
    Database db = await database;
    String query = "insert into $user_table ($col_userID, $col_deliveryAddress, $col_phoneNumber, "
        "$col_email) values ('${user.userID}', '${user.deliveryAddress}', "
        "'${user.phoneNumber}', '${user.email}')";
    try {
      await db.execute(query);
    }
    catch(e) {
      print("db_helper.saveUser error: ${e.toString()}");
      showToast("User not saved");
    }
  }

  Future<void> updateAddress (AppUser user) async {
    Database db = await database;
    String query = "update $user_table set $col_deliveryAddress = '${user.deliveryAddress}'";
    await db.execute(query);
  }

  Future<void> saveItem (Item item) async {
    Database db = await database;
    String query = "insert into $item_table ($col_item_name, $col_item_desc, $col_item_category, "
        "$col_item_image, $col_item_wholesale_image, $col_item_stock_count, $col_item_wholesale_price, $col_wholesale_unit, "
        "$col_retail_price) values ('${item.itemName}', '${item.description}', '${item.category}', "
        "'${item.image}', '${item.wholesaleImage}', '${item.stockCount}', '${item.wholesalePrice}', '${item.wholesaleUnit}', "
        "'${item.retailPrice}')";
    try {
      await db.execute(query);
    }
    catch(e) {
      print("db_helper.saveItem error: ${e.toString()}");
      showToast("Item not saved");
    }
  }

  Future<List<Item>> getItems() async {
    List<Item> list = [];
    Database db = await database;
    String query = "select * from $item_table";
    List<Map<String, Object>> result = await db.rawQuery(query);
    for (int i = 0; i < result.length; i++) {
      Item item = Item(
        favorite: '',
        discount: 0,
        buyingCount: 0,
        retailPrice: result[i][col_retail_price],
        wholesaleUnit: result[i][col_wholesale_unit],
        wholesalePrice: result[i][col_item_wholesale_price],
        id: result[i][col_item_id],
        isBuyingWholesale: "",
        wholesaleImage: result[i][col_item_wholesale_image],
        itemName: result[i][col_item_name],
        description: result[i][col_item_desc],
        category: result[i][col_item_category],
        image: result[i][col_item_image],
        stockCount: result[i][col_item_stock_count],
      );
      list.add(item);
    }
    return list;
  }

  factory DbHelper(){
    if(helper == null){
      helper = DbHelper._createInstance();
    }
    return helper;
  }

  Future<Database> get database async {
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async{
    final db_path = await getDatabasesPath();
    final path = join(db_path, db_name);
    return await openDatabase(path, version: 1, onCreate: createDb);
  }

}