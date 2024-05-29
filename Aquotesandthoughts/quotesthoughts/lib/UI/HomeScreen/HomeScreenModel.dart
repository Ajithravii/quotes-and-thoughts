
class HomeScreenCategory{
  final String categoryName;
  final String categoryImage;
  final String categoryUid;

  HomeScreenCategory({required this.categoryName, required this.categoryImage, required this.categoryUid});

  HomeScreenCategory.fromJson(Map<String, dynamic> json)
      : categoryName = json['categoryName'],
        categoryImage = json['categoryImage'],
        categoryUid = json['categoryUid'];

  Map<String, dynamic> toJson() => {
    'categoryName': categoryName,
    'categoryImage': categoryImage,
    'categoryUid': categoryUid,
  };

}