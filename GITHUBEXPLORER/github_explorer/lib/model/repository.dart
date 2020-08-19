class Repository {
  final int id;
  final String name;
  final String description;
  final int ratingStarsCount;
  final String repoCreatedDate;
  final int watchersCount;
  final String language;

  Repository.fromJSON(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        name = jsonMap['name'],
        description = jsonMap['description'],
        ratingStarsCount = jsonMap['stargazers_count'],
        repoCreatedDate = jsonMap['created_at'],
        watchersCount = jsonMap['watchers_count'],
        language = jsonMap['language'];

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ratingStarsCount': ratingStarsCount,
      'repoCreatedDate': repoCreatedDate,
      'watchersCount': watchersCount,
      'language': language
    };
  }
}
