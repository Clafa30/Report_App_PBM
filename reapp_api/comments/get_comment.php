<?php
header("Content-Type: application/json");
include "../config/koneksi.php";

if (!isset($_GET['report_id'])) {
    echo json_encode([
        "status" => "error",
        "message" => "report_id wajib"
    ]);
    exit;
}

$report_id = intval($_GET['report_id']);

$sql = "
  SELECT
    c.comment,
    c.created_at,
    u.name AS user_name
  FROM comments c
  JOIN users u ON u.id = c.user_id
  WHERE c.report_id = ?
  ORDER BY c.created_at ASC
";

$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode([
        "status" => "error",
        "message" => $conn->error
    ]);
    exit;
}

$stmt->bind_param("i", $report_id);
$stmt->execute();

$result = $stmt->get_result();

$comments = [];
while ($row = $result->fetch_assoc()) {
    $comments[] = $row;
}

echo json_encode([
    "status" => "success",
    "comments" => $comments
]);
