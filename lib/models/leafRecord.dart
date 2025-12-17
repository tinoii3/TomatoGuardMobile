class LeafRecord {
  final int? recordId;
  final int diseaseId;
  final String imagePath;
  final bool isHealthy;
  final double confidence;
  final DateTime createdAt;
  
  final String? diseaseName; 

  LeafRecord({
    this.recordId,
    required this.diseaseId,
    required this.imagePath,
    required this.isHealthy,
    required this.confidence,
    required this.createdAt,
    this.diseaseName,
  });

  // แปลงข้อมูลจาก Object เป็น Map เพื่อบันทึกลง SQLite
  Map<String, dynamic> toMap() {
    return {
      'record_id': recordId,
      'disease_id': diseaseId,
      'image_path': imagePath,
      'is_healthy': isHealthy ? 1 : 0,
      'confidence_score': confidence,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory LeafRecord.fromMap(Map<String, dynamic> map) {
    return LeafRecord(
      recordId: map['record_id'],
      diseaseId: map['disease_id'],
      imagePath: map['image_path'],
      isHealthy: map['is_healthy'] == 1,
      confidence: map['confidence_score'],
      createdAt: DateTime.parse(map['created_at']),
      diseaseName: map['disease_name'],
    );
  }
}