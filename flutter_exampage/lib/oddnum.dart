import 'package:flutter/material.dart'; // นำเข้าแพ็กเกจ Flutter Material สำหรับใช้ UI Widgets

// สร้างหน้าจอ OddNumbersPage เพื่อแสดงเลขคี่ทั้งหมดที่ไม่เกิน 1000
class OddNumbersPage extends StatelessWidget {
  const OddNumbersPage({super.key}); // ✅ ใช้ const ได้ เนื่องจากไม่มี state ที่เปลี่ยนแปลง

  // สร้างลิสต์ของเลขคี่ตั้งแต่ 1 ถึง 999
  // ใช้ `static final` เพื่อให้ลิสต์ถูกสร้างขึ้นเพียงครั้งเดียว ไม่ต้องคำนวณใหม่ทุกครั้ง
  static final List<int> oddNumbers = List.generate(500, (index) => index * 2 + 1); //เมื่อ index = 0 → (0 * 2) + 1

   @override
  Widget build(BuildContext context) {
    // คำนวณจำนวนตัวเลขทั้งหมด (เลขคี่ 1 - 999)
    List<int> oddNumbers = List.generate(500, (index) => index * 2 + 1);
 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "แสดงเลขจำนวนคี่แบบตาราง (1 - 999)",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // เลื่อนได้แนวนอน
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, // เลื่อนได้แนวตั้ง
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        for (int row = 0; row < 25; row++) // มี 25 แถว
                          Row(
                            children: [
                              for (int col = 0; col < 20; col++) // มี 20 คอลัมน์
                                if ((row * 20 + col) < oddNumbers.length) // เช็คไม่ให้เกิน 999
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Container(
                                      width: 50,  // กำหนดขนาดช่องตาราง
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        border: Border.all(color: Colors.black, width: 0.5),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "${oddNumbers[row * 20 + col]}", // แสดงตัวเลขคี่
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}