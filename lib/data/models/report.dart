import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Report extends Equatable {
  final String id;
  final String name;
  final String reportUrl;

  const Report({
    this.id = '0',
    required this.name,
    required this.reportUrl,
  });
  factory Report.empty() {
    return const Report(
      name: 'unknown',
      reportUrl: '',
    );
  }
  Report copyWith({String? name, String? reportUrl, String? imageUrl}) {
    return Report(
      id: id,
      name: name ?? this.name,
      reportUrl: reportUrl ?? this.reportUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'reportUrl': reportUrl,
    };
  }

  static Report fromSnapshot(DocumentSnapshot snap) {
    return Report(
      id: snap.id,
      name: snap['report']['name'],
      reportUrl: snap['report']['reportUrl'],
    );
  }

  static Report fromJson(Map json) {
    return Report(
      name: json['name'],
      reportUrl: json['reportUrl'],
      id: json['_id'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        reportUrl,
      ];
}
