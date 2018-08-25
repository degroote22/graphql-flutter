import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class ReadRepositoriesUserRepositoryConnectionRepository {
  ReadRepositoriesUserRepositoryConnectionRepository(this._d);

  final Map<String, dynamic> _d;

  String get id => this._d["id"];
  String get name => this._d["name"];
  bool get viewerHasStarred => this._d["viewerHasStarred"];

  String toString() {
    return this._d.toString();
  }
}

class ReadRepositoriesUserRepositoryConnection {
  ReadRepositoriesUserRepositoryConnection(this._d);

  final Map<String, dynamic> _d;

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

class ReadRepositoriesUser {
  ReadRepositoriesUser(this._d);

  final Map<String, dynamic> _d;

  ReadRepositoriesUserRepositoryConnection get repositories =>
      ReadRepositoriesUserRepositoryConnection(this._d["repositories"]);

  String toString() {
    return this._d.toString();
  }
}

class ReadRepositories {
  ReadRepositories(this._d);

  final Map<String, dynamic> _d;

  ReadRepositoriesUser get viewer => ReadRepositoriesUser(this._d["viewer"]);
}
