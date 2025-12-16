class LeafRecord {
  final int? recordId;      // อิงตาม ER: record_id
  final int diseaseId;      // อิงตาม ER: disease_id
  final String imagePath;   // อิงตาม ER: image_path
  final bool isHealthy;     // อิงตาม ER: is_healthy
  final double confidence;  // อิงตาม ER: confidence_score
  final DateTime createdAt; // อิงตาม ER: created_at
  
  // Field เสริมสำหรับ Join ตาราง (ไม่อยู่ใน DB leaf_records แต่เอาไว้โชว์)
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
      'is_healthy': isHealthy ? 1 : 0, // SQLite เก็บ bool เป็น 0, 1
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