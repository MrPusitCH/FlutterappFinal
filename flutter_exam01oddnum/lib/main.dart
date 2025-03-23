import 'package:flutter/material.dart'; // นำเข้าแพ็กเกจ Flutter Material สำหรับใช้ UI Widgets

// ฟังก์ชันเริ่มต้นของแอป Flutter
void main() {
  runApp(const OddNumbersApp()); // เรียกใช้งาน Widget หลักของแอป (OddNumbersApp)
}

// สร้างคลาส OddNumbersApp เป็น StatelessWidget ซึ่งเป็นโครงสร้างพื้นฐานของแอป
class OddNumbersApp extends StatelessWidget {
  const OddNumbersApp({super.key}); // กำหนด key ให้กับ widget เพื่อช่วย Flutter จัดการ state ได้ดีขึ้น

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // ซ่อนแถบ debug บนมุมขวาบนของแอป
      home: OddNumbersPage(), // ตั้งหน้าเริ่มต้นของแอปให้เป็น OddNumbersPage
    );
  }
}

// สร้างหน้าจอ OddNumbersPage เพื่อแสดงเลขคี่ทั้งหมดที่ไม่เกิน 1000
class OddNumbersPage extends StatelessWidget {
  const OddNumbersPage({super.key}); // ✅ ใช้ const ได้ เนื่องจากไม่มี state ที่เปลี่ยนแปลง

  // สร้างลิสต์ของเลขคี่ตั้งแต่ 1 ถึง 999
  // ใช้ `static final` เพื่อให้ลิสต์ถูกสร้างขึ้นเพียงครั้งเดียว ไม่ต้องคำนวณใหม่ทุกครั้ง
  static final List<int> oddNumbers = List.generate(500, (index) => index * 2 + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เลขคี่ไม่เกิน 1000'), // กำหนดชื่อของ AppBar
        backgroundColor: Colors.blueAccent, // กำหนดสีพื้นหลังของ AppBar
      ),
      body: ListView.builder(
        itemCount: oddNumbers.length, // จำนวนรายการในลิสต์ = 500 รายการ (เลขคี่)
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              oddNumbers[index].toString(), // แสดงตัวเลขที่เป็นเลขคี่
              style: const TextStyle(fontSize: 20), // กำหนดขนาดตัวอักษรให้ใหญ่ขึ้น
            ),
          );
        },
      ),
    );
  }
}
