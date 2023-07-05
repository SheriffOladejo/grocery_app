class OrderDetail {

  int orderID;
  int timestamp;
  double deliveryPrice;
  double totalItemsCost;
  double orderTotal;
  String ownerEmail;
  String status;
  String desc;
  String selectedItems;

  OrderDetail({
    this.orderID,
    this.ownerEmail,
    this.timestamp,
    this.status,
    this.desc,
    this.orderTotal,
    this.totalItemsCost,
    this.deliveryPrice,
    this.selectedItems,
  });

}