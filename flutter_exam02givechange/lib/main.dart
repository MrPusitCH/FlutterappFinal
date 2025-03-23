import 'package:flutter/material.dart'; // นำเข้าแพ็กเกจสำหรับ UI ของ Flutter

// ฟังก์ชัน main() เป็นจุดเริ่มต้นของแอป
void main() {
  runApp(const ChangeCalculatorApp()); // เรียกใช้งานแอป ChangeCalculatorApp
}

// สร้าง StatelessWidget เป็นโครงสร้างหลักของแอป
class ChangeCalculatorApp extends StatelessWidget {
  const ChangeCalculatorApp({super.key}); //❌ ไม่มี const → Flutter ต้องสร้าง Widget ใหม่ตลอด

  @override
Widget build(BuildContext context) {
  return const MaterialApp(
    title: 'Login App', // ตั้งชื่อแอป
    home: ChangeCalculatorPage(), // เปิดแอปมาให้แสดงหน้า ChangeCalculatorPage
    );
  }
}

// ใช้ StatefulWidget เพราะมีการเปลี่ยนค่าใน UI
class ChangeCalculatorPage extends StatefulWidget {
  const ChangeCalculatorPage({super.key});

  @override
  _ChangeCalculatorPageState createState() => _ChangeCalculatorPageState(); //เพื่อให้ UI อัพเดทค่าได้
}

// คลาสสำหรับจัดการ State ของ ChangeCalculatorPage
class _ChangeCalculatorPageState extends State<ChangeCalculatorPage> {
  // ตัวควบคุม TextField เพื่อรับค่าราคาสินค้าและเงินที่จ่าย
  final _totalController = TextEditingController();
  final _cashController = TextEditingController();

  // ตัวแปรเก็บข้อความแสดงเงินทอน
  String _changeText = "";

  // ตัวแปรเก็บจำนวนธนบัตรและเหรียญที่ต้องทอน
  Map<int, int> _changeBreakdown = {};

  // ฟังก์ชันคำนวณเงินทอน
  void _calculateChange() {
    setState(() {
      int total = int.tryParse(_totalController.text) ?? 0; // รับค่าราคาสินค้า
      int cash = int.tryParse(_cashController.text) ?? 0; // รับค่าจำนวนเงินที่จ่าย
      int change = cash - total; // คำนวณเงินทอน

      if (change < 0) {
        _changeText = "เงินไม่พอจ่าย!"; // ถ้าเงินไม่พอ ให้แจ้งเตือน
        _changeBreakdown = {}; // ล้างค่าที่คำนวณไว้ก่อนหน้า
        return;
      }

      _changeText = "เงินทอน: $change บาท"; // แสดงเงินทอน
      _changeBreakdown = _getChangeBreakdown(change); // เรียกฟังก์ชันคำนวณธนบัตร/เหรียญ
    });
  }

  // ฟังก์ชันคำนวณธนบัตรและเหรียญที่ต้องทอน (ใช้ Greedy Algorithm)
  Map<int, int> _getChangeBreakdown(int amount) {
    // รายการธนบัตรและเหรียญที่ใช้ทอน
    List<int> denominations = [500, 100, 50, 20, 10, 5, 2, 1];
    Map<int, int> result = {};

    for (int value in denominations) {
      if (amount >= value) {
        result[value] = amount ~/ value; // หาจำนวนธนบัตร/เหรียญ (หารปัดเศษลง)
        amount %= value; // คำนวณเงินที่เหลือ
      }
    }
    return result; // คืนค่า Map ที่มีจำนวนธนบัตร/เหรียญ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('คำนวณเงินทอน'), // แสดงชื่อบนแถบ AppBar
        backgroundColor: Colors.redAccent, // กำหนดสี AppBar เป็นสีแดง
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // กำหนดระยะห่างรอบ UI
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // จัด UI ให้ชิดซ้าย
          children: [
            // ช่องกรอกราคาสินค้า
            TextField(
              controller: _totalController, // เชื่อมกับตัวแปรควบคุม
              keyboardType: TextInputType.number, // กำหนดให้ใส่ได้แค่ตัวเลข
              decoration: const InputDecoration(labelText: 'ราคาสินค้า(บาท)'), // แสดงข้อความแนะนำ
            ),
            const SizedBox(height: 10), // เพิ่มช่องว่าง

            // ช่องกรอกเงินสดที่จ่าย
            TextField(
              controller: _cashController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'เงินสดที่จ่าย(บาท)'),
            ),
            const SizedBox(height: 20),

            // ปุ่มคำนวณเงินทอน (อยู่ตรงกลาง)
            Center(
              child: ElevatedButton(
                onPressed: _calculateChange, // เรียกฟังก์ชันคำนวณเมื่อกดปุ่ม
                child: const Text('คำนวณเงินทอน(บาท)'),
              ),
            ),
            const SizedBox(height: 20),

            // แสดงผลเงินทอน
            Text(
              _changeText, // ข้อความแสดงเงินทอน
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // แสดงรายการธนบัตรและเหรียญที่ต้องทอน
            if (_changeBreakdown.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _changeBreakdown.entries.map((entry) {
                  return Text('${entry.value} x ${entry.key} บาท'); // แสดงจำนวนธนบัตร/เหรียญที่ต้องทอน
                }).toList(), //ถ้าไม่ใช้จะเป็น (2, 4, 6, 8, 10) // ❌ Iterable (ไม่ใช่ List จริง ๆ)
              ),
          ],
        ),
      ),
    );
  }
}
