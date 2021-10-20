import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vantypesapp/features/domain/entities/picture.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  void test() async {
    var test = await firebaseFirestore.collection('pictures').get();
    // var test = await firebaseFirestore
    //     .collection('pictures')
    //     .where('type', isEqualTo: "box")
    //     .get();
    print(test.docs[0].data());
    test.docs.forEach((result) {
      print(result.data());
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          ElevatedButton(
            onPressed: () {
              //test();
              Navigator.of(context).pushNamed('/category', arguments: "panel");
            },
            child: Text(
              "Panel van",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/category', arguments: "minibus");
            },
            child: Text(
              "Minibus",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/category', arguments: "dropside");
            },
            child: Text(
              "Dropside",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/category', arguments: "box");
            },
            child: Text(
              "Box van",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
