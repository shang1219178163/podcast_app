class Podcast {
  final String? id;
  final String? title;
  final String? author;
  final String? cover;
  final String? description;
  final String? subscribers;
  final String? category;

  Podcast({
    this.id,
    this.title,
    this.author,
    this.cover,
    this.description,
    this.subscribers,
    this.category,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      id: json['id'] as String?,
      title: json['title'] as String?,
      author: json['author'] as String?,
      cover: json['cover'] as String?,
      description: json['description'] as String?,
      subscribers: json['subscribers'] as String?,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'cover': cover,
      'description': description,
      'subscribers': subscribers,
      'category': category,
    };
  }
}
