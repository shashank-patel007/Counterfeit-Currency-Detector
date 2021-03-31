import 'package:flutter/material.dart';
import 'constants.dart';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'model.dart';

class ShowBanks extends StatefulWidget {
  @override
  _ShowBanksState createState() => _ShowBanksState();
}

class _ShowBanksState extends State<ShowBanks> {
  @override
  Widget build(BuildContext context) {
    final data = bankDataFromJson(jsonEncode(sample_data).toString());
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Color(0xff885566),
        centerTitle: true,
        title: Text(
          "Counterfeit Currency Detector",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 23,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (ctx, i) {
                return Container(
                  width: MediaQuery.of(ctx).size.width,
                  child: Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data[i].bank,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${data[i].distance} away",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              data[i].address,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
