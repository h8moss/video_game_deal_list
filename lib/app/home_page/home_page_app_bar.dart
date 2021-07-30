import 'package:flutter/material.dart';

class HomePageAppBar extends AppBar {
  HomePageAppBar({
    Key? key,
    this.label: '',
    this.searchFieldController,
    required this.isSearching,
    required this.hasFilter,
    required this.hasSearch,
    required this.onBackPressed,
    required this.onFilterPressed,
    required this.onSearchPressed,
    required this.onSearchSubmit,
  }) : super(
          title: isSearching
              ? TextField(
                  onSubmitted: onSearchSubmit,
                  autofocus: true,
                  controller: searchFieldController,
                )
              : Text(label),
          actions: [
            if (hasFilter)
              TextButton(
                onPressed: onFilterPressed,
                child: Icon(
                  Icons.filter_list,
                  color: Colors.black,
                ),
              ),
            if (hasSearch)
              TextButton(
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: onSearchPressed,
              )
          ],
          centerTitle: true,
          leading: isSearching
              ? TextButton(
                  onPressed: onBackPressed,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ))
              : null,
        );

  final String label;
  final TextEditingController? searchFieldController;
  final bool isSearching;
  final bool hasSearch;
  final bool hasFilter;

  final ValueChanged<String>? onSearchSubmit;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onBackPressed;
}
