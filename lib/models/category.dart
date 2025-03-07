import 'podcast.dart';

class Category {
  final String? id;
  final String? name;
  final String? icon;
  final List<Podcast>? podcasts;

  const Category({
    this.id,
    this.name,
    this.icon,
    this.podcasts,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String?,
      name: json['name'] as String?,
      icon: json['icon'] as String?,
      podcasts: json['podcasts'] != null
          ? (json['podcasts'] as List<dynamic>).map((e) => Podcast.fromJson(e as Map<String, dynamic>)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'podcasts': podcasts?.map((e) => e.toJson()).toList(),
    };
  }
}
