import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/storeitem.dart';
import '/page/additem.dart';
import '/page/edititem.dart';
import 'package:flutter/material.dart';
import '../services/inventory_firebase_crud.dart';

class ItemListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListPage();
  }
}

class _ListPage extends State<ItemListPage> {
  // Reference to the Firestore collection
  final Stream<QuerySnapshot> collectionReference =
      FirebaseCrud.readStoreItem();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Inventory Details"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => AddItem(),
                ),
                (route) => false, // Disable back feature if necessary
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView(
                children: snapshot.data!.docs.map((e) {
                  // Retrieve createdAt and updatedAt
                  DateTime createdAt = (e['createdAt'] as Timestamp).toDate();
                  DateTime updatedAt = (e['updatedAt'] as Timestamp).toDate();

                  // Ensure quantities are correctly parsed as Map<String, int>
                  Map<String, int> sizes = Map<String, int>.from(e['quantities'] ?? {
                    'S': 0,
                    'M': 0,
                    'L': 0,
                    'XL': 0,
                    'XXL': 0
                  });

                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(e["itemname"]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Displaying item image
                              e['imageUrl'] != null
                                  ? Image.network(
                                      e['imageUrl'],
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 100,
                                      width: 100,
                                      color: Colors.grey,
                                      child: Icon(Icons.image, size: 50),
                                    ),
                              SizedBox(height: 10),
                              Text("Category: " + e['category'],
                                  style: const TextStyle(fontSize: 14)),
                              Text("Item Type: " + e['itemtype'],
                                  style: const TextStyle(fontSize: 14)),
                              Text("Price: Rs. " + e['price'].toString(),
                                  style: const TextStyle(fontSize: 12)),
                              Text("Quantities by Size: ",
                                  style: const TextStyle(fontSize: 12)),
                              Text(
                                  "S: ${sizes['S']}, M: ${sizes['M']}, L: ${sizes['L']}, XL: ${sizes['XL']}, XXL: ${sizes['XXL']}",
                                  style: const TextStyle(fontSize: 12)),
                              // Displaying description
                              Text("Description: " + e['description'],
                                  style: const TextStyle(fontSize: 12)),
                              Text("Created At: " + createdAt.toString(),
                                  style: const TextStyle(fontSize: 10)),
                              Text("Updated At: " + updatedAt.toString(),
                                  style: const TextStyle(fontSize: 10)),
                            ],
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(5.0),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              child: const Text('Edit'),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) => EditItem(
                                      storeitem: StoreItem(
                                        uid: e.id,
                                        itemname: e["itemname"],
                                        category: e["category"],
                                        itemtype: e["itemtype"],
                                        quantities: sizes,  // <-- Pass sizes here
                                        price: e["price"],
                                        description: e["description"],
                                        imageUrl: e["imageUrl"],
                                        name: null,
                                      ),
                                    ),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(5.0),
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              child: const Text('Delete'),
                              onPressed: () async {
                                var storeItemResponse =
                                    await FirebaseCrud.deleteStoreItem(
                                        docId: e.id);
                                if (storeItemResponse.code != 200) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(storeItemResponse.message
                                            .toString()),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
