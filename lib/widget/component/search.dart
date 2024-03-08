import 'package:black_book/constant.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchBuilder extends StatelessWidget {
  Function? searchAgian;
  Function? searchValue;

  SearchBuilder({super.key, this.searchAgian, this.searchValue});

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
                          hintText: "Барааны код",
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
          InkWell(
              onTap: () {
                // setState(() {
                //   searchAgian = true;
                //   _agianSearch();
                // });
                searchAgian?.call(true);
              },
              child: Container(
                  width: 80,
                  height: 38,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 3,
                            offset: const Offset(2, 2))
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                      child: Text("Хайх", style: TextStyle(color: kWhite)))))
        ]));
  }
}
