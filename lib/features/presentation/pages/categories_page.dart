import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key key}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextStyle textStyle = TextStyle(fontWeight: FontWeight.bold);

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
              Navigator.of(context).pushNamed('/category', arguments: "panel");
            },
            child: Text(
              "panel".tr(),
              style: textStyle,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/category', arguments: "minibus");
            },
            child: Text(
              "minibus".tr(),
              style: textStyle,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/category', arguments: "dropside");
            },
            child: Text(
              "dropside".tr(),
              style: textStyle,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/category', arguments: "box");
            },
            child: Text(
              "box".tr(),
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
