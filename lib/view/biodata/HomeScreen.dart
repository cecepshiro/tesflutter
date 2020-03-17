import 'dart:convert';

import 'package:bioapp/service/ApiService.dart';
import 'package:bioapp/service/ApiServiceAuth.dart';
import 'package:bioapp/view/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:bioapp/view/biodata/FormScreen.dart';
import 'package:bioapp/model/Biodata.dart';
import 'package:shared_preferences/shared_preferences.dart';

ApiService api = new ApiService();
final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Biodata data;
  List<Biodata> allBiodata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text(
          'Bioapp',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[400],
        automaticallyImplyLeading: true,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return FormScreen();
              // }));
              logout();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: api.getAllBiodata(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Biodata>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    "Something wrong with message: ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              allBiodata = snapshot.data;
              if (allBiodata == null) {
                return Center(
                  child: Text("Data not found"),
                );
              } else {
                return buildBiodataListView(context, allBiodata);
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // print('Clicked');
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormScreen();
          }));
        },
      ),
    );
  }

  Widget buildBiodataListView(BuildContext context, List<Biodata> allBiodata) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: allBiodata.isEmpty
          ? Column(
              children: <Widget>[
                Text(
                  "No Transaction Data",
                  style: Theme.of(context).textTheme.title,
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                Biodata biodata = allBiodata[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(biodata.divisi + " " + biodata.alamat),
                              Spacer(),
                              Text(biodata.socialMedia),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Spacer(),
                              RaisedButton(
                                child: Text("Ubah",
                                    style: TextStyle(color: Colors.white)),
                                color: Colors.orange[400],
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return FormScreen(biodata: biodata);
                                  }));
                                },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              RaisedButton(
                                child: Text("Hapus",
                                    style: TextStyle(color: Colors.white)),
                                color: Colors.red[400],
                                onPressed: () {
                                  // int tmpId = biodata.id;
                                  // String id = tmpId.toString();
                                  // set up the buttons
                                  Widget cancelButton = FlatButton(
                                    child: Text("Batal"),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');
                                    },
                                  );
                                  Widget continueButton = FlatButton(
                                    child: Text("Ya"),
                                    onPressed: () {
                                      String id = biodata.id;
                                      api.delete(id).then((result) {
                                        if (result != null) {
                                          print("SUKSES");
                                          _scaffoldState.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text("Hapus data sukses"),
                                          ));
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');
                                          setState(() {});
                                        } else {
                                          print("GAGAL");
                                          _scaffoldState.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text("Hapus data gagal"),
                                          ));
                                        }
                                      });
                                    },
                                  );

                                  // set up the AlertDialog
                                  AlertDialog alert = AlertDialog(
                                    title: Text("Hapus"),
                                    content:
                                        Text("Yakin ingin menghapus data ini?"),
                                    actions: [
                                      cancelButton,
                                      continueButton,
                                    ],
                                  );

                                  // show the dialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: allBiodata.length,
            ),
    );
  }

  void logout() async {
    var res = await ApiServiceAuth().getData('/auth/logout');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }
}
