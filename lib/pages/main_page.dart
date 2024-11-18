import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:draja_steam/pages/category_page.dart';
import 'package:draja_steam/pages/home_page.dart';
import 'package:draja_steam/pages/transaction_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DateTime selectedDate;
  late List<Widget> _children;
  late int currentIndex;

  @override
  void initState() {
    // TODO: implement initState
    updateView(0, DateTime.now());
    super.initState();
  }

  // void onTapTapped(int index) {
  //   setState(() {
  //     currentIndex = index;
  //   });
  // }

  void updateView(int index, DateTime? date) {
    setState(() {
      if (date != null) {
        selectedDate = DateTime.parse(DateFormat('yyyy-mm-dd').format(date));
      }

      currentIndex = index;
      _children = [HomePage(selectedDate: selectedDate), CategoryPage()];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (currentIndex == 0)
      ? CalendarAppBar(
        accent: Colors.green,
        backButton: false,
        locale: 'id',
        onDateChanged: (value) {
          setState(() {
            selectedDate = value;
            updateView(0, selectedDate);
          });
        },
        firstDate: DateTime.now().subtract(Duration(days: 140)),
        lastDate: DateTime.now(),
      )
      : PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
            child: Text('Kategori', style: GoogleFonts.montserrat(fontSize: 20)),
          ),
        )
      ),
      floatingActionButton: Visibility(
        visible: (currentIndex == 0) ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TransactionPage(transactionWithCategory: null,)))
            .then((value) {
              setState(() {});
            });
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
        ),
      ),
      body: _children[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                updateView(0, DateTime.now());
              },
              icon: Icon(Icons.home)
            ),
            SizedBox(width: 20,),
            IconButton(
              onPressed: () {
                updateView(1, null);
              },
              icon: Icon(Icons.list)
            )
          ],
        ),
      ),
    );
  }
}