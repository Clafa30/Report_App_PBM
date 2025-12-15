<?php
header("Content-Type: application/json");
include "../config/koneksi.php";

$report_id = $_POST['report_id'] ?? null;
$user_id   = $_POST['user_id'] ?? null;
$comment   = $_POST['comment'] ?? null;

if (!$report_id || !$user_id || !$comment) {
    echo json_encode([
        "status" => "error",
        "message" => "Data tidak lengkap"
    ]);
    exit;
}

$stmt = $conn->prepare("
    INSERT INTO comments (report_id, user_id, comment)
    VALUES (?, ?, ?)
");

$stmt->bind_param("iis", $report_id, $user_id, $comment);

if ($stmt->execute()) {
    echo json_encode([
        "status" => "success",
        "message" => "Komentar berhasil dikirim"
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Gagal menyimpan komentar"
    ]);
}

$stmt->close();
$conn->close();
