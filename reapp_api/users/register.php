<?php
include "../config/koneksi.php";

$data = json_decode(file_get_contents("php://input"), true);

$name     = $data['name'];
$phone    = $data['phone'];
$password = password_hash($data['password'], PASSWORD_DEFAULT);

// Cek nomor HP sudah ada atau belum
$cek = $conn->query("SELECT * FROM users WHERE phone='$phone'");
if ($cek->num_rows > 0) {
    echo json_encode(["status"=>"error", "message"=>"Nomor HP sudah terdaftar"]);
    exit;
}

$query = $conn->query("
    INSERT INTO users (name, phone, password)
    VALUES ('$name', '$phone', '$password')
");

if ($query) {
    echo json_encode(["status"=>"success", "message"=>"Registrasi berhasil"]);
} else {
    echo json_encode(["status"=>"error", "message"=>"Gagal mendaftar"]);
}
?>
