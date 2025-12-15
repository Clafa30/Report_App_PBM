<?php
include "../config/koneksi.php";

$user_id    = $_POST["user_id"];
$description = $_POST["description"];

$before_img = "";
$after_img  = "";

// Upload Before
if (isset($_FILES["before"])) {
    $before_img = "before_" . time() . ".jpg";
    move_uploaded_file($_FILES["before"]["tmp_name"], "../uploads/before/" . $before_img);
}

// Upload After
if (isset($_FILES["after"])) {
    $after_img = "after_" . time() . ".jpg";
    move_uploaded_file($_FILES["after"]["tmp_name"], "../uploads/after/" . $after_img);
}

$q = $conn->query("
    INSERT INTO reports (user_id, description, before_img, after_img)
    VALUES ('$user_id','$description','$before_img','$after_img')
");

if ($q) {
    echo json_encode(["status"=>"success","message"=>"Report berhasil dikirim"]);
} else {
    echo json_encode(["status"=>"error","message"=>"Gagal mengirim report"]);
}
?>
