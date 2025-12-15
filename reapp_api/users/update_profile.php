<?php
header("Content-Type: application/json");
include "../config/koneksi.php";

$user_id = $_POST['user_id'] ?? null;
$name    = $_POST['name'] ?? '';
$phone   = $_POST['phone'] ?? '';

if (!$user_id || !$name || !$phone) {
    echo json_encode([
        "status" => "error",
        "message" => "Data tidak lengkap"
    ]);
    exit;
}

$q = $conn->query("
    UPDATE users
    SET name='$name', phone='$phone'
    WHERE id='$user_id'
");

if ($q) {
    $u = $conn->query("SELECT id, name, phone FROM users WHERE id='$user_id'")->fetch_assoc();
    echo json_encode([
        "status" => "success",
        "user" => $u
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Gagal update profil"
    ]);
}
