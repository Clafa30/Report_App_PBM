class ReportModel {
  final String id;
  final String description;
  final String beforeImage;
  final String afterImage;
  final String createdAt;
  final String status;
  final String picName;

  ReportModel({
    required this.id,
    required this.description,
    required this.beforeImage,
    required this.afterImage,
    required this.createdAt,
    required this.status,
    required this.picName,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'].toString(),
      description: json['description'] ?? '',
      beforeImage:
          "http://10.0.2.2/report_app/reapp_api/uploads/before/${json['before_img']}",
      afterImage:
          "http://10.0.2.2/report_app/reapp_api/uploads/after/${json['after_img']}",
      createdAt: json['created_at'] ?? '',
      status: json['status'] ?? 'pending',
      picName: json['pic_name'] ?? 'Unknown',
    );
  }
}
