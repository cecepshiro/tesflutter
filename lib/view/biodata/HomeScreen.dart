import 'package:bioapp/service/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:bioapp/view/biodata/FormScreen.dart';
import 'package:bioapp/model/Biodata.dart';

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
          'Simple CRUD Apps',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange[400],
        automaticallyImplyLeading: true,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FormScreen();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.add,
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
                                color: Colors.orange[400],
                                onPressed: () {
                                  int tmpId = biodata.id;
                                  String id = tmpId.toString();
                                  api.delete(id).then((result) {
                                    if (result != null) {
                                      print("SUKSES");
                                      _scaffoldState.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text("Hapus data sukses"),
                                      ));
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
}
