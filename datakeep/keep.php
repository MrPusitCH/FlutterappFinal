<?php 
require "connect.php"; // ✅ เชื่อมต่อฐานข้อมูล

if (!$con) {
    die(json_encode(["status" => "error", "message" => "❌ Connection error"]));
}

// 📌 รับค่าจาก Flutter ผ่าน HTTP POST
$name = $_POST['name'];
$phone = $_POST['phone'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];

// 📌 ตรวจสอบว่ามีชื่อซ้ำหรือไม่
$check_sql = "SELECT * FROM friends WHERE name = ?";
$stmt = mysqli_prepare($con, $check_sql);
mysqli_stmt_bind_param($stmt, "s", $name);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

if (mysqli_num_rows($result) > 0) {
    echo json_encode(["status" => "error", "message" => "❌ ชื่อนี้มีอยู่แล้ว"]);
} else {
    // 📌 เพิ่มข้อมูลเพื่อนลงฐานข้อมูล
    $insert_sql = "INSERT INTO friends (name, phone, latitude, longitude) VALUES (?, ?, ?, ?)";
    $stmt = mysqli_prepare($con, $insert_sql);
    mysqli_stmt_bind_param($stmt, "ssdd", $name, $phone, $latitude, $longitude);
    
    if (mysqli_stmt_execute($stmt)) {
        echo json_encode(["status" => "success", "message" => "✅ เพิ่มข้อมูลสำเร็จ"]);
    } else {
        echo json_encode(["status" => "error", "message" => "❌ ไม่สามารถเพิ่มข้อมูลได้"]);
    }
}

mysqli_close($con); // 📌 ปิดการเชื่อมต่อฐานข้อมูล
?>
