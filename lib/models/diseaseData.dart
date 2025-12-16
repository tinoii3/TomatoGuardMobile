class DiseaseData {
  final String englishName;
  final String thaiName;
  final String description;
  final String treatment;
  final String imageUrl;

  DiseaseData({
    required this.englishName,
    required this.thaiName,
    required this.description,
    required this.treatment,
    this.imageUrl = "",
  });
}
