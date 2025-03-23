// 📌 นำเข้าแพ็กเกจที่จำเป็นสำหรับการทำงานของแอป
import 'dart:convert'; // ใช้แปลงข้อมูล JSON ที่รับ-ส่งจากเซิร์ฟเวอร์
import 'package:flutter/material.dart'; // ใช้สร้าง UI ด้วย Flutter
import 'package:flutter_map/flutter_map.dart'; // ใช้สร้างแผนที่แบบอินเตอร์แอคทีฟ
import 'package:http/http.dart' as http; // ใช้สำหรับเรียก API ผ่าน HTTP
import 'package:latlong2/latlong.dart'; // ใช้จัดการค่าพิกัดของตำแหน่งบนแผนที่

// 📌 สร้างคลาส `DataKeepPage` ซึ่งเป็นหน้า UI สำหรับบันทึกประวัติของเพื่อน
class DataKeepPage extends StatefulWidget {
  const DataKeepPage({super.key});

  @override
  _DataKeepPageState createState() => _DataKeepPageState();
}

// 📌 คลาส State สำหรับ `DataKeepPage`
class _DataKeepPageState extends State<DataKeepPage> {
  // ✅ ตัวแปรควบคุมอินพุตของ TextField (ชื่อและเบอร์โทร)
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  LatLng? selectedLocation; // ✅ เก็บค่าตำแหน่งที่ผู้ใช้เลือกจากแผนที่

  // 📌 ฟังก์ชัน `saveFriend()` สำหรับบันทึกข้อมูลเพื่อนลงฐานข้อมูล MySQL
  Future<void> saveFriend() async {
    // ✅ ตรวจสอบว่าผู้ใช้กรอกข้อมูลครบหรือไม่
    if ([nameController.text, phoneController.text].contains('') ||
        selectedLocation == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("⚠️ กรุณากรอกข้อมูลให้ครบ")));
      return;
    }

    // ✅ แสดง Dialog โหลดข้อมูล ขณะกำลังส่งข้อมูลไปยังเซิร์ฟเวอร์
    showDialog(
      context: context, // กำหนดตำแหน่งของ Dialog ในแอป
      barrierDismissible: false, // ไม่สามารถปิด Dialog ด้วยการแตะขอบด้านนอก
      builder: (context) => const Center(child: CircularProgressIndicator()), // แสดงวงกลมหมุน (หมายถึงกำลังโหลด)
    );


    try {
      // ✅ ส่งข้อมูลไปยัง PHP ผ่าน HTTP POST
      final response = await http.post(
        Uri.parse("http://127.0.0.1/datakeep/keep.php"), // URL ของ PHP API
        body: {
          "name": nameController.text, // ส่งค่าชื่อไปยังเซิร์ฟเวอร์
          "phone": phoneController.text, // ส่งค่าเบอร์โทรไปยังเซิร์ฟเวอร์
          "latitude": "${selectedLocation!.latitude}", // ส่งค่าพิกัดละติจูด
          "longitude": "${selectedLocation!.longitude}", // ส่งค่าพิกัดลองจิจูด
        },
      ).timeout(const Duration(seconds: 5)); // กำหนด timeout 5 วินาที

      Navigator.pop(context); // ✅ ปิด Dialog โหลดข้อมูล

      final result = jsonDecode(response.body); // ✅ แปลง JSON ที่ได้รับเป็น Object

      // ✅ แจ้งผลลัพธ์การบันทึกข้อมูล
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result["status"] == "success"
              ? "✅ บันทึกข้อมูลสำเร็จ"
              : "❌ เกิดข้อผิดพลาด: ${result["message"]}")));

      // ✅ หากบันทึกสำเร็จ ให้เคลียร์ข้อมูลที่กรอกไปแล้ว
      if (result["status"] == "success") {
        setState(() {
          nameController.clear(); // ล้างค่าใน TextField
          phoneController.clear();
          selectedLocation = null; // รีเซ็ตค่าตำแหน่งแผนที่
        });
      }
    } catch (e) {
      Navigator.pop(context); // ปิด Dialog โหลดข้อมูล
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ สร้าง AppBar ด้านบนของหน้าแอป
      appBar: AppBar(
        title: const Text("📍 บันทึกประวัติเพื่อน"), // ชื่อหัวข้อใน AppBar
        backgroundColor: Colors.lightGreen, // สีพื้นหลังของ AppBar
      ),

      // ✅ ใช้ Column() เพื่อจัดเรียง Widget ตามแนวตั้ง
      body: Column(
        children: [
          // ✅ กล่องอินพุตข้อมูล (ชื่อ-นามสกุล, เบอร์โทร)
          Card(
            margin: const EdgeInsets.all(16), // กำหนดขอบห่างรอบ Card
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // ทำให้มุมโค้งมน
            elevation: 4, // เพิ่มเงาให้ Card ดูลอยขึ้น
            child: Padding(
              padding: const EdgeInsets.all(16.0),// ระยะห่าง 16.0 พิกเซลจากทุกๆ ด้านขอบ
              child: Column(
                children: [
                  // ✅ ช่องกรอกชื่อ
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "👤 ชื่อ-นามสกุล", // Label ของ TextField
                      border: OutlineInputBorder(), // ใส่เส้นขอบรอบช่องอินพุต
                    ),
                  ),
                  const SizedBox(height: 10), // เพิ่มระยะห่าง

                  // ✅ ช่องกรอกเบอร์โทร
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: "📞 เบอร์โทร",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone, // ตั้งค่าให้รองรับการกรอกตัวเลข
                  ),
                ],
              ),
            ),
          ),

          // ✅ แสดงแผนที่แบบเต็มจอ
          Expanded(
            child: Stack(
              children: [
                // ✅ ใช้ FlutterMap() เพื่อแสดงแผนที่
                FlutterMap(
                  options: MapOptions(
                    center: LatLng(13.736717, 100.523186), // พิกัดเริ่มต้น: กรุงเทพฯ
                    zoom: 12.0, // กำหนดระดับการซูม
                    onTap: (tapPosition, point) {
                      setState(() {
                        selectedLocation = point; // ✅ เมื่อแตะแผนที่ กำหนดค่าพิกัดที่เลือก
                      });
                    },
                  ),
                  children: [
                    // ✅ แสดงแผนที่ (เปลี่ยนเป็นแผนที่แบบไล่สี)
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),

                    // ✅ แสดงหมุดตำแหน่งที่เลือก (ถ้ามี)
                    if (selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 60.0,
                            height: 60.0,
                            point: selectedLocation!,
                            child: const Icon(Icons.pin_drop,
                                color: Colors.red, size: 40),
                          ),
                        ],
                      ),
                  ],
                ),

                // ✅ ปุ่มบันทึกแบบ Floating Button
                Positioned(
                  bottom: 20, // กำหนดให้ปุ่มอยู่ด้านล่าง
                  right: 20, // กำหนดให้ปุ่มอยู่ด้านขวา
                  child: FloatingActionButton.extended( //ปุ่มแบบลอย
                    onPressed: saveFriend, // เรียกฟังก์ชันบันทึกข้อมูล
                    icon: const Icon(Icons.save), // ไอคอนปุ่มบันทึก
                    label: const Text("บันทึกข้อมูล"), // ข้อความบนปุ่ม
                    backgroundColor: Colors.green, // สีพื้นหลังปุ่ม
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
