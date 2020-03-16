import 'dart:convert';

class Biodata {
  final int id;
  final String divisi;
  final String alamat;
  final String socialMedia;

  Biodata({this.id, this.divisi, this.alamat, this.socialMedia});

  factory Biodata.fromJson(Map<String, dynamic> map) {
    return Biodata(
        id: map["id"] as int,
        divisi: map["divisi"] as String,
        alamat: map["alamat"] as String,
        socialMedia: map["social_media"] as String);
  }
  static List<Biodata> biodataFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<Biodata>.from(data.map((item) => Biodata.fromJson(item)));
  }
}
