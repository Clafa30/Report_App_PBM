class CommentModel {
  final String id;
  final String reportId;
  final String userId;
  final String userName;
  final String comment;
  final String createdAt;

  CommentModel({
    required this.id,
    required this.reportId,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'].toString(),
      reportId: json['report_id'].toString(),
      userId: json['user_id'].toString(),
      userName: json['user_name'] ?? 'User',
      comment: json['comment'],
      createdAt: json['created_at'],
    );
  }
}
