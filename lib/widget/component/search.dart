import 'package:black_book/constant.dart';
import 'package:black_book/widget/alert/component/buttons.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchBuilder extends StatelessWidget {
  Function? searchAgian;
  Function? searchValue;
  String? searchText;

  SearchBuilder(
      {super.key,
      this.searchAgian,
      this.searchValue,
      this.searchText = "Барааны код"});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        child: Row(children: [
          Expanded(
              child: SizedBox(
                  height: 35,
                  child: TextField(
                      onChanged: (value) {
                        searchValue?.call(value);
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.black26, width: 1)),
                          hoverColor: Colors.black12,
                          focusColor: Colors.black12,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.black26, width: 1)),
                          fillColor: kWhite,
                          hintText: searchText,
                          filled: true,
                          contentPadding: const EdgeInsets.all(10),
                          prefixIcon:
                              const Icon(Icons.search, color: kPrimaryColor),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          hintStyle: const TextStyle(
                              fontSize: 13, color: Colors.grey))))),
          const SizedBox(width: 10),
          BlackBookButton(
            height: 38,
            width: 80,
            borderRadius: 14,
            onPressed: () {
              searchAgian?.call(true);
            },
            color: kPrimaryColor,
            child: const Center(
              child: Text("Хайх"),
            ),
          ),
        ]));
  }
}
