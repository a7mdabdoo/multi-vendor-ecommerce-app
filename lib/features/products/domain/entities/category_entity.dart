import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String slug;
  final String name;
  final String url;
  final String iconName;

  const CategoryEntity({
    required this.slug,
    required this.name,
    required this.url,
    required this.iconName,
  });

  @override
  List<Object?> get props => [slug, name, url, iconName];
}
