import 'package:black_book/models/default/message.dart';

class TermsResponse {
  final List<TermsData> data;
  final MessageDefaultModel message;
  final String status;

  TermsResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  factory TermsResponse.fromJson(Map<String, dynamic> json) {
    return TermsResponse(
      data: (json['data'] as List)
          .map((item) => TermsData.fromJson(item))
          .toList(),
      message: MessageDefaultModel.fromJson(json['message']),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'message': message.toJson(),
      'status': status,
    };
  }
}

class TermsData {
  final int id;
  final String title;
  final String slug;
  final String content;
  final DateTime createdAt;

  TermsData({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
    required this.createdAt,
  });

  factory TermsData.fromJson(Map<String, dynamic> json) {
    return TermsData(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}