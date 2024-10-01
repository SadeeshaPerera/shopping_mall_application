import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/promotion.dart';
import '/page/addpromotion.dart';
import '/page/editpromotion.dart';
import 'package:flutter/material.dart';

import '../services/promotion_firebase_crud.dart';

class PromotionListPage extends StatefulWidget {
  const PromotionListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ListPage();
  }
}

class _ListPage extends State<PromotionListPage> {
  final Stream<QuerySnapshot> collectionReference =
      FirebaseCrud.readPromotion();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("List of Promotion"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.app_registration,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => AddPromotion(),
                ),
                (route) =>
                    false, //if you want to disable back feature set to false
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

              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int gridColumns = constraints.maxWidth > 1200
                      ? 4
                      : constraints.maxWidth > 800
                          ? 3
                          : constraints.maxWidth > 600
                              ? 2
                              : 1;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridColumns,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.2,
                    ),

                    // OverflowBar(
                    //   alignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     TextButton(
                    //       style: TextButton.styleFrom(
                    //         padding: const EdgeInsets.all(5.0),
                    //         // primary: const Color.fromARGB(255, 143, 133, 226),
                    //         textStyle: const TextStyle(fontSize: 20),
                    //       ),
                    //       child: const Text('Edit'),
                    //       onPressed: () {
                    //         Navigator.pushAndRemoveUntil<dynamic>(
                    //           context,
                    //           MaterialPageRoute<dynamic>(
                    //             builder: (BuildContext context) =>
                    //                 PromotionEditPage(
                    //               promotion: Promotion(
                    //                   uid: e.id,
                    //                   promotionname: e["promotion_name"],
                    //                   position: e["position"],
                    //                   contactno: e["contact_no"]),
                    //             ),
                    //           ),
                    //           (route) =>
                    //               false, //if you want to disable back feature set to false
                    //         );
                    //       },
                    //       ),)

                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var e = snapshot.data!.docs[index];
                      return Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15.0)),
                              child: e["picture_url"] != null
                                  ? Image.network(
                                      e["picture_url"],
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 150,
                                      width: double.infinity,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image, size: 80),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Shop: " + e['shop_name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    "Date: " + e['date'],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      textStyle: const TextStyle(fontSize: 14),
                                    ),
                                    child: const Text('Edit'),
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil<dynamic>(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context) =>
                                              PromotionEditPage(
                                            promotion: Promotion(
                                              uid: e.id,
                                              shopName: e["shop_name"],
                                              date: e["date"],
                                              pictureUrl: e["picture_url"],
                                            ),
                                          ),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      textStyle: const TextStyle(fontSize: 14),
                                    ),
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          context, e.id);
                                    },
                                  ),
                                ],
                              ),
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
                                builder: (BuildContext context) =>
                                    PromotionEditPage(
                                  promotion: Promotion(
                                      uid: e.id,
                                      promotionname: e["promotion_name"],
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
                            var promotionresponse =
                                await FirebaseCrud.deletePromotion(docId: e.id);
                            if (promotionresponse.code != 200) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                          promotionresponse.message.toString()),
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

          return Container();
        },
      ),
    );
  }


  void _showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this promotion?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                var promotionresponse =
                    await FirebaseCrud.deletePromotion(docId: docId);
                Navigator.of(context).pop(); // Close the dialog

                // Show success or error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(promotionresponse.message.toString()),
                  ),
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

}
