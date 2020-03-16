import 'dart:convert';
import 'package:bioapp/response/BiodataResponse.dart';
import 'package:http/http.dart' as http;
import 'package:bioapp/model/Biodata.dart';

class ApiService {
  static String baseUrl = "http://testflutter.compunerds.id/api/";
  BiodataResponse r = new BiodataResponse();

  Future<List<Biodata>> getAllBiodata() async {
    final response = await http.get(baseUrl + "biodata/index");
    r = BiodataResponse.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      List<Biodata> data = r.data.cast<Biodata>();
      return data;
    } else {
      return null;
    }
  }

  Future<Biodata> create(Biodata biodata) async {
    Map<String, dynamic> inputMap = {
      'divisi': biodata.divisi,
      'alamat': biodata.alamat,
      'social_media': biodata.socialMedia
    };
    final response = await http.post(
      baseUrl + "biodata/store",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: inputMap,
    );

    r = BiodataResponse.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      Biodata data = r.data[0];
      return data;
    } else {
      return null;
    }
  }

  Future<Biodata> update(Biodata biodata) async {
    Map<String, dynamic> inputMap = {
      'divisi': biodata.divisi,
      'alamat': biodata.alamat,
      'social_media': biodata.socialMedia,
      'id': biodata.id
    };
    final response = await http.post(
      baseUrl + "/biodata/update",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: inputMap,
    );

    r = BiodataResponse.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      Biodata data = r.data[0];
      return data;
    } else {
      return null;
    }
  }

  Future<Biodata> delete(String id) async {
    Map<String, dynamic> inputMap = {'id': id};
    final response = await http.post(
      baseUrl + "biodata/delete",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: inputMap,
    );

    r = BiodataResponse.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      Biodata data = r.data[0];
      return data;
    } else {
      return null;
    }
  }
}
