class Podcast {
  final String? id;
  final String? title;
  final String? author;
  final String? subscribers;
  final String? cover;

  const Podcast({
    this.id,
    this.title,
    this.author,
    this.subscribers,
    this.cover,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      id: json['id'] as String?,
      title: json['title'] as String?,
      author: json['author'] as String?,
      subscribers: json['subscribers'] as String?,
      cover: json['cover'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'subscribers': subscribers,
      'cover': cover,
    };
  }
}
