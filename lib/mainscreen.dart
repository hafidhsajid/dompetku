import 'dart:collection';
import 'dart:convert';

import 'package:dompetku/create.dart';
import 'package:dompetku/update.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Mainscreen extends StatelessWidget {
  const Mainscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dompetku'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          // final List place = fetch();
          return InkWell(
            onTap: () {
              var get = fetch();
              get.then((value) {
                print("value:" + value.toString());
              });
            },
            child: Card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'A',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Rp. 0'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: 5,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateScreen()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  final String apiUrl = "https://backend-dompetku.herokuapp.com/api/history";
  Future<List<Map<String, dynamic>>?> fetch() async {
    http.Response response = await http
        .get(Uri.parse("https://backend-dompetku.herokuapp.com/api/history"));
    if (response.statusCode != 200) return null;
    return List<Map<String, dynamic>>.from(json.decode(response.body)['data']);
  }
}

class Testingget extends StatefulWidget {
  const Testingget({Key? key}) : super(key: key);

  @override
  State<Testingget> createState() => _TestinggetState();
}

class _TestinggetState extends State<Testingget> {
  List list = List.filled(0, null);
  var isLoading = false;
  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http
        .get(Uri.parse("https://backend-dompetku.herokuapp.com/api/history"));
    if (response.statusCode == 200) {
      final decode = json.decode(response.body)['data'];
      list = decode
          .map<HashMap<String, dynamic>>(
              (e) => HashMap<String, dynamic>.from(e))
          .toList();
      print("value:" + list.toString());
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Fetch Data JSON"),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            child: new Text("Fetch Data"),
            onPressed: _fetchData,
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: new Text(list[index]['nama']),
                    trailing: new Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png",
                      fit: BoxFit.cover,
                      height: 40.0,
                      width: 40.0,
                    ),
                  );
                }));
  }
}

class Testget1 extends StatefulWidget {
  const Testget1({Key? key}) : super(key: key);

  @override
  State<Testget1> createState() => _Testget1State();
}

class _Testget1State extends State<Testget1> {
  List list = List.filled(0, null);
  var isLoading = true;
  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await http
        .get(Uri.parse("https://backend-dompetku.herokuapp.com/api/history"));
    if (response.statusCode == 200) {
      final decode = json.decode(response.body)['data'];
      list = decode
          .map<HashMap<String, dynamic>>(
              (e) => HashMap<String, dynamic>.from(e))
          .toList();
      print("value:" + list.toString());
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      _fetchData();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('DOmpetku'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                // final TourismPlace place = tourismPlaceList[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Update(
                        list[index]['id'].toString(),
                        list[index]['nama'].toString(),
                        list[index]['jumlah'].toString(),
                        list[index]['jenis'].toString(),
                      );
                    })).then((value) => setState(() {
                          isLoading = true;
                        }));
                  },
                  child: Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (list[index]['jenis']=="Pengeluaran") ... [
                          Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.call_made,
                            size: 40,
                            color: Colors.red,
                          ),
                        ),
                        ]else ... [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.call_received,
                              size: 40,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  list[index]['nama'],
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Rp. " + list[index]['jumlah']),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: list.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateScreen()))
              .then((value) => setState(() {
                    isLoading = true;
                  }));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), //
    );
  }
}
