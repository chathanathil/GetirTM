class PopularSearch {
  final String query;
  final int id;

  const PopularSearch({
    this.query,
    this.id,
  });

  static PopularSearch fromJson(dynamic json) {
    return PopularSearch(
      query: json['query'] as String,
      id: json['id'] as int,
    );
  }
}
