class Article {
  final String title;
  final String content;
  final String image;

  Article({
    required this.title,
    required this.content,
    required this.image,
  });

  // Convert Article to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'image_path': image,
    };
  }

  // Convert Firestore document to Article object
  factory Article.fromFirestore(Map<String, dynamic> data) {
    return Article(
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      image: data['image_path'] ?? '',
    );
  }
}
