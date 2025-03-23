<?php
// 📌 ข้อมูลการเชื่อมต่อฐานข้อมูล MySQL
$db_name = "friend_db";   // ✅ เปลี่ยนเป็นชื่อฐานข้อมูลของคุณ
$db_user = "root";        // ✅ ชื่อผู้ใช้ MySQL (ถ้าใช้ XAMPP/MAMP จะเป็น root)
$db_pass = "";            // ✅ รหัสผ่าน MySQL (ถ้าใช้ XAMPP/MAMP ปกติจะเป็นค่าว่าง)
$db_host = "localhost";   // ✅ ที่อยู่เซิร์ฟเวอร์ (ส่วนใหญ่เป็น localhost)

// 📌 เปิดการแจ้งเตือนข้อผิดพลาด
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

// 📌 เชื่อมต่อกับฐานข้อมูล
$con = mysqli_connect($db_host, $db_user, $db_pass, $db_name);

// 📌 ตรวจสอบการเชื่อมต่อ
if (!$con) {
    die("❌ Connection failed: " . mysqli_connect_error());
}

// 📌 ตั้งค่าการเข้ารหัสเป็น UTF-8 เพื่อรองรับภาษาไทย
mysqli_set_charset($con, "utf8mb4");

// 📌 แจ้งเตือนว่าเชื่อมต่อสำเร็จ (ใช้เฉพาะตอน debug)
// echo "✅ Connected successfully";

?>
