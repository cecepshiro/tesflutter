import 'package:flutter/material.dart';
import 'package:bioapp/model/Biodata.dart';
import 'package:bioapp/service/ApiService.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormScreen extends StatefulWidget {
  Biodata biodata;
  FormScreen({this.biodata});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  ApiService api = new ApiService();
  TextEditingController ctrlDivisi = new TextEditingController();
  TextEditingController ctrlAlamat = new TextEditingController();
  TextEditingController ctrlsocialMedia = new TextEditingController();

  @override
  void initState() {
    if (this.widget.biodata != null) {
      ctrlDivisi.text = this.widget.biodata.divisi;
      ctrlAlamat.text = this.widget.biodata.alamat;
      ctrlsocialMedia.text = this.widget.biodata.socialMedia;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.biodata == null ? "Form Tambah" : "Form Update",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: ctrlDivisi,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Nama Divisi',
                hintText: 'Nama Divisi',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: ctrlAlamat,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Alamat Lengkap',
                hintText: 'Alamat Lengkap',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: ctrlsocialMedia,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Akun Sosial Media',
                hintText: 'Akun Sosial Media',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Spacer(),
                RaisedButton(
                  onPressed: () {
                    if (validateInput()) {
                      Biodata dataIn = new Biodata(
                          id: this.widget.biodata != null
                              ? this.widget.biodata.id
                              : "",
                          divisi: ctrlDivisi.text,
                          alamat: ctrlAlamat.text,
                          socialMedia: ctrlsocialMedia.text);
                      print("TESSSS");
                      print(this.widget.biodata);
                      if (this.widget.biodata != null) {
                        api.update(dataIn).then((result) {
                          print(result);
                          if (result != null) {
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Simpan data gagal"),
                            ));
                          }
                        });
                      } else {
                        api.create(dataIn).then((result) {
                          if (result != null) {
                            print("SUKSES");
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            print("GAGAL");
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Simpan data gagal"),
                            ));
                          }
                        });
                      }
                    } else {
                      _scaffoldState.currentState.showSnackBar(SnackBar(
                        content: Text("Data belum lengkap"),
                      ));
                    }
                  },
                  child: Text(
                    widget.biodata == null ? "Simpan" : "Ubah",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue[400],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool validateInput() {
    if (ctrlDivisi.text == "" ||
        ctrlAlamat.text == "" ||
        ctrlsocialMedia.text == "") {
      return false;
    } else {
      return true;
    }
  }
}
