import 'package:flutter/material.dart';

import 'package:jellyflut/providers/search/search_provider.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';

class ClearIcon extends StatefulWidget {
  final TextEditingController searchController;
  ClearIcon({Key? key, required this.searchController}) : super(key: key);

  @override
  _ClearIconState createState() => _ClearIconState();
}

class _ClearIconState extends State<ClearIcon> {
  late final FocusNode _node;
  late final SearchProvider searchProvider;

  @override
  void initState() {
    _node = FocusNode();
    searchProvider = SearchProvider();
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        node: _node,
        onPressed: () {
          widget.searchController.clear();
          searchProvider.clearSearchResult();
          if (!_node.hasFocus) {
            setState(() {
              searchProvider.hideResult();
            });
          }
        },
        shape: CircleBorder(),
        child: Icon(
          Icons.close_outlined,
          color: Colors.white,
          size: 28,
        ));
  }
}
