import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

/// A repository contains the content for a project.
class ReadRepositoriesUserRepositoryConnectionRepository {
  ReadRepositoriesUserRepositoryConnectionRepository(this._d);

  final Map<String, dynamic> _d;

  String get id => this._d["id"];

  /// The name of the repository.
  String get name => this._d["name"];

  /// Returns a boolean indicating whether the viewing user has starred this starrable.
  bool get viewerHasStarred => this._d["viewerHasStarred"];

  String toString() {
    return this._d.toString();
  }
}

/// A list of repositories owned by the subject.
class ReadRepositoriesUserRepositoryConnection {
  ReadRepositoriesUserRepositoryConnection(this._d);

  final Map<String, dynamic> _d;

  /// A repository contains the content for a project.
  List<Option<ReadRepositoriesUserRepositoryConnectionRepository>> get nodes =>
      (this._d["nodes"] as List)
          .map<Option<ReadRepositoriesUserRepositoryConnectionRepository>>(
              (repository) => option(
                  repository != null,
                  ReadRepositoriesUserRepositoryConnectionRepository(
                      repository)))
          .toList();

  String toString() {
    return this._d.toString();
  }
}

/// A user is an individual's account on GitHub that owns repositories and can make new content.
class ReadRepositoriesUser {
  ReadRepositoriesUser(this._d);

  final Map<String, dynamic> _d;

  /// A list of repositories owned by the subject.
  ReadRepositoriesUserRepositoryConnection get repositories =>
      ReadRepositoriesUserRepositoryConnection(this._d["repositories"]);

  String toString() {
    return this._d.toString();
  }
}

class ReadRepositories {
  ReadRepositories(this._d);

  final Map<String, dynamic> _d;

  /// A user is an individual's account on GitHub that owns repositories and can make new content.
  ReadRepositoriesUser get viewer => ReadRepositoriesUser(this._d["viewer"]);

  String toString() {
    return this._d.toString();
  }
}
