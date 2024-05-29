class QuoteModel{
  final String quote;
  final String category;
  final String quoteId;
  final String categoryId;

  QuoteModel({
    required this.quote,
    required this.category,
    required this.quoteId,
    required this.categoryId,});

  Map<String, dynamic> toMap() {
    return {
      'quote': quote,
      'category': category,
      'quoteId': quoteId,
      'categoryId': categoryId,
    };
  }

  QuoteModel.fromMap(Map<String, dynamic> res)
      : quote = res["quote"],
        category = res["category"],
        quoteId = res["quoteId"],
        categoryId = res["categoryId"];

  @override
  String toString() {
    return 'quote{quote: $quote, category: $category, quoteId: $quoteId, categoryId: $categoryId}';
  }

}