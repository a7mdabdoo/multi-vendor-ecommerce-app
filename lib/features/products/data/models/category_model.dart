import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.slug,
    required super.name,
    required super.url,
    required super.iconName,
  });

  factory CategoryModel.fromJson(dynamic json) {
    if (json is String) {
      return CategoryModel(
        slug: json,
        name: _capitalize(json.replaceAll('-', ' ')),
        url: 'https://dummyjson.com/products/category/$json',
        iconName: _getCategoryIcon(json),
      );
    } else if (json is Map<String, dynamic>) {
      final slug = json['slug'] as String? ?? 'general';
      final name = json['name'] as String? ?? _capitalize(slug.replaceAll('-', ' '));
      final url = json['url'] as String? ?? 'https://dummyjson.com/products/category/$slug';
      return CategoryModel(
        slug: slug,
        name: name,
        url: url,
        iconName: _getCategoryIcon(slug),
      );
    }
    return const CategoryModel(
      slug: 'all',
      name: 'All Categories',
      url: '',
      iconName: 'category',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'url': url,
      'iconName': iconName,
    };
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  static String _getCategoryIcon(String slug) {
    final lower = slug.toLowerCase();
    if (lower.contains('beauty') || lower.contains('skin')) return 'beauty';
    if (lower.contains('fragrance')) return 'fragrance';
    if (lower.contains('furniture') || lower.contains('home')) return 'home';
    if (lower.contains('grocer')) return 'grocery';
    if (lower.contains('laptop') || lower.contains('computer')) return 'laptop';
    if (lower.contains('phone') || lower.contains('smart')) return 'phone';
    if (lower.contains('shirt') || lower.contains('dress') || lower.contains('cloth')) return 'fashion';
    if (lower.contains('shoe')) return 'shoes';
    if (lower.contains('watch')) return 'watch';
    if (lower.contains('jewel')) return 'jewelry';
    return 'category';
  }
}
