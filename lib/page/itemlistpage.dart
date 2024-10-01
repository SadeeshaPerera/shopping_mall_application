import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../services/inventory_firebase_crud.dart';
import '../models/storeitem.dart';

import '/page/additem.dart';
import '/page/edititem.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ListPage();
  }
}

class _ListPage extends State<ItemListPage> {
  final Stream<QuerySnapshot> collectionReference =
      FirebaseCrud.readStoreItem();
  //FirebaseFirestore.instance.collection('StoreItem').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("List of StoreItem"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(

            icon: const Icon(
              Icons.add,

              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => const AddItem(),
                ),

                (route) => false,

              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.picture_as_pdf,
              color: Colors.white,
            ),
            onPressed: () {}, // Call the PDF generation function
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
                  DateTime createdAt = (e['createdAt'] as Timestamp).toDate();
                  DateTime updatedAt = (e['updatedAt'] as Timestamp).toDate();
                  Map<String, int> sizes = Map<String, int>.from(
                      e['quantities'] ??
                          {'S': 0, 'M': 0, 'L': 0, 'XL': 0, 'XXL': 0});

                  return Card(

                    child: Column(
                      children: [
                        ListTile(
                          title: Text(e["itemname"]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
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
                                      child: const Icon(Icons.image, size: 50),
                                    ),
                              const SizedBox(height: 10),
                              Text("Category: " + e['category'],
                                  style: const TextStyle(fontSize: 14)),
                              Text("Item Type: " + e['itemtype'],
                                  style: const TextStyle(fontSize: 14)),
                              Text("Price: Rs. ${e['price']}",
                                  style: const TextStyle(fontSize: 12)),
                              const Text("Quantities by Size: ",
                                  style: TextStyle(fontSize: 12)),
                              Text(
                                  "S: ${sizes['S']}, M: ${sizes['M']}, L: ${sizes['L']}, XL: ${sizes['XL']}, XXL: ${sizes['XXL']}",
                                  style: const TextStyle(fontSize: 12)),
                              Text("Description: " + e['description'],
                                  style: const TextStyle(fontSize: 12)),
                              Text("Created At: $createdAt",
                                  style: const TextStyle(fontSize: 10)),
                              Text("Updated At: $updatedAt",
                                  style: const TextStyle(fontSize: 10)),
                            ],
                          ),
                        ),
                        OverflowBar(
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
                                        quantities: sizes,
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
                                } else if (storeItemResponse.code == 200) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(
                                          storeItemResponse.message.toString()),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),

                          ],
                        )),
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(5.0),
                            // primary: const Color.fromARGB(255, 143, 133, 226),
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
                                      storeitemname: e["storeitem_name"],
                                      position: e["position"],
                                      contactno: e["contact_no"]),
                                ),
                              ),
                              (route) =>
                                  false, //if you want to disable back feature set to false
                            );
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(5.0),
                            // primary: const Color.fromARGB(255, 143, 133, 226),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text('Delete'),
                          onPressed: () async {
                            var storeitemresponse =
                                await FirebaseCrud.deleteStoreItem(docId: e.id);
                            if (storeitemresponse.code != 200) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                          storeitemresponse.message.toString()),
                                    );
                                  });
                            }
                          },
                        ),
                      ],
                    ),
                  ]));
                }).toList(),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());

        },
      ),
    );
  }
}
