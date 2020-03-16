import 'package:bioapp/model/Biodata.dart';

class BiodataResponse {
  bool status;
  List<Biodata> data;

  BiodataResponse({this.status, this.data});

  factory BiodataResponse.fromJson(Map<String, dynamic> map) {
    // cast dynamic object to model (Biodata)
    var allBiodata = map['data'] as List;
    List<Biodata> biodataList =
        allBiodata.map((i) => Biodata.fromJson(i)).toList();
    return BiodataResponse(status: map["status"], data: biodataList);
  }
}
