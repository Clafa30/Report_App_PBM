<?php
header('Content-Type: application/json');
include "../config/koneksi.php";

$phone = $_POST['phone'] ?? null;
$password = $_POST['password'] ?? null;

if (!$phone || !$password) {
    echo json_encode([
        "status" => "error",
        "message" => "Data tidak lengkap"
    ]);
    exit;
}

$q = $conn->query("SELECT * FROM users WHERE phone='$phone' LIMIT 1");

if ($q->num_rows == 0) {
    echo json_encode([
        "status"=>"error",
        "message"=>"Nomor HP tidak ditemukan"
    ]);
    exit;
}

$user = $q->fetch_assoc();

if (!password_verify($password, $user['password'])) {
    echo json_encode([
        "status"=>"error",
        "message"=>"Password salah"
    ]);
    exit;
}

echo json_encode([
    "status" => "success",
    "message" => "Login berhasil",
    "user" => [
        "id" => (string)$user['id'],
        "name" => $user['name'],
        "phone" => $user['phone'],
        "role" => $user['role']
    ]
]);
