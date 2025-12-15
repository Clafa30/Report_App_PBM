<?php
include "../config/koneksi.php";

$user_id = $_GET['user_id'] ?? null;
if (!$user_id) {
    echo json_encode(["status"=>"error","reports"=>[]]);
    exit;
}

$q = $conn->query("
    SELECT * FROM reports
    WHERE user_id='$user_id'
    ORDER BY created_at DESC
");

$data = [];
while ($r = $q->fetch_assoc()) {
    $r['before_url'] = $r['before_img']
        ? "http://10.0.2.2/report_app/reapp_api/uploads/before/".$r['before_img']
        : null;

    $r['after_url'] = $r['after_img']
        ? "http://10.0.2.2/report_app/reapp_api/uploads/after/".$r['after_img']
        : null;

    $data[] = $r;
}

echo json_encode([
    "status" => "success",
    "reports" => $data
]);
