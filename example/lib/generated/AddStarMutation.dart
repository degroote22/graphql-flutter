import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

Map<String, dynamic> addStarVariables({@required String starrableId}) {
  return {"starrableId": starrableId};
}

class AddStarAddStarPayloadStarrable {
  AddStarAddStarPayloadStarrable(this._d);

  final Map<String, dynamic> _d;

  bool get viewerHasStarred => this._d["viewerHasStarred"];

  String toString() {
    return this._d.toString();
  }
}

class AddStarAddStarPayload {
  AddStarAddStarPayload(this._d);

  final Map<String, dynamic> _d;

  AddStarAddStarPayloadStarrable get starrable =>
      AddStarAddStarPayloadStarrable(this._d["starrable"]);

  String toString() {
    return this._d.toString();
  }
}

class AddStar {
  AddStar(this._d);

  final Map<String, dynamic> _d;

  Option<AddStarAddStarPayload> get addStar => option(
      this._d["addStar"] != null, AddStarAddStarPayload(this._d["addStar"]));
}
