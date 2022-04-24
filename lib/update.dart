import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//testing
String? _jenis;
String? _nama;
String? _jumlah;

class Update extends StatelessWidget {
  final String nama;
  final String jumlah;
  final String jenis;
  final String id;
  Update(this.id, this.nama, this.jumlah, this.jenis);

  TextEditingController _controllernama = TextEditingController();
  TextEditingController _controllerjumlah = TextEditingController();
  TextEditingController _controllerjenis = TextEditingController();

  String status = "";
  bool _isOpendialog = false;
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    _controllernama.text = this.nama;
    _controllerjumlah.text = this.jumlah;
    setjenis(this.jenis);
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Data'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _controllernama,
                    decoration: InputDecoration(
                      hintText: 'Input nama...',
                      labelText: 'Input name',
                    ),
                  ),
                  TextField(
                    controller: _controllerjumlah,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Input jumlah...',
                      labelText: 'Input jumlah',
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Jenis', style: TextStyle(fontSize: 20)),
                      ),
                      MyStatefulWidget(),],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _isOpendialog = true;
                      showDialog(
                          context: context,
                          builder: (alertContext) {
                            var res = UpdateScreenHistory(id,_controllernama.text,
                                _controllerjumlah.text, _jenis.toString());
                            res.then((value) {
                              var decode = jsonDecode(value.body as String);
                              if (decode['success'] == true) {
                                if (_isOpendialog) {
                                  Navigator.pop(alertContext);
                                }
                                isLoading = false;
                                // setState(() {
                                status = "Sukses";
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                            'Message: ${decode['message']}'),
                                      );
                                      // });
                                    });
                              } else {
                                // setState(() {
                                status = "Gagal";
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                            'Message: ${decode['message']}'),
                                      );
                                    });
                                isLoading = false;
                                // });
                              }
                            });
                            return AlertDialog(
                              content: Text('Update ......'),
                            );
                          }).then((_) => _isOpendialog = false);
                    },
                    child: Text('Submit'),
                  )
                ],
              ),
            ),
    );
  }

  Future<http.Response> UpdateScreenHistory(
      String idd, String nama, String jumlah, String jenis) {
    final http.Client _client = http.Client();
    return _client.put(
      Uri.parse('https://backend-dompetku.herokuapp.com/api/history/' + idd),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nama': nama,
        'jumlah': jumlah,
        'jenis': jenis,
      }),
    );
  }
}

enum Jenis { Pemasukan, Pengeluaran }

void setjenis(String data) {
  _jenis = data;
  
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  Jenis? _character;

  @override
  Widget build(BuildContext context) {
    if (_jenis=="Pemasukan") {
      _character = Jenis.Pemasukan;
    } else if(_jenis=="Pengeluaran") {
      _character = Jenis.Pengeluaran;
    }
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Pengeluaran'),
          leading: Radio<Jenis>(
            value: Jenis.Pengeluaran,
            groupValue: _character,
            onChanged: (Jenis? value) {
              setState(() {
                _character = value;
              });
              setjenis("Pengeluaran");
            },
          ),
        ),
        ListTile(
          title: const Text('Pemasukan'),
          leading: Radio<Jenis>(
            value: Jenis.Pemasukan,
            groupValue: _character,
            onChanged: (Jenis? value) {
              setState(() {
                _character = value;
              });

              setjenis("Pemasukan");
            },
          ),
        ),
      ],
    );
  }
}
