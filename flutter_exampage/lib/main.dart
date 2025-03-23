import 'package:flutter/material.dart';
import 'package:flutter_exampage/oddnum.dart';
import 'package:flutter_exampage/givechange.dart';
import 'package:flutter_exampage/datakeep.dart'; // ✅ นำเข้า datakeep.dart

void main() {
  runApp(const MyApp());
}

//1-------------------------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ✅ ซ่อนแถบ debug
      home: DefaultTabController(
        length: 3, // ✅ มี 3 Tab
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Lobby',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.blue[100],
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.format_list_numbered, color: Colors.blueAccent),
                  text: 'แสดงเลขคี่ไม่เกิน 1000',
                ),
                Tab(
                  icon: Icon(Icons.monetization_on, color: Colors.redAccent),
                  text: 'ทอนเงิน',
                ),
                Tab(
                  icon: Icon(Icons.person_pin_circle, color: Colors.green),
                  text: 'บันทึกประวัติ',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              OddNumbersPage(), // ✅ Tab 1: แสดงเลขคี่
              ChangeCalculatorPage(), // ✅ Tab 2: คำนวณเงินทอน
              DataKeepPage(), // ✅ Tab 3: บันทึกข้อมูลเพื่อน
            ],
          ),
        ),
      ),
    );
  }
}
