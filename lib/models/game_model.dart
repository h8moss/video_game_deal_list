class GameModel {
  GameModel(this.name);
  factory GameModel.fromJson(dynamic json) {
    return GameModel(json['title']);
  }

  String name;
}
