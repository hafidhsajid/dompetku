import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//testing
class Update extends StatefulWidget {
  final String id;
  final String nama;
  final String jumlah;
  final String jenis;
  const Update(this.id, this.nama, this.jumlah, this.jenis);

  @override
  State<Update> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<Update> {
  TextEditingController _controllernama = TextEditingController();
  TextEditingController _controllerjumlah = TextEditingController();
  TextEditingController _controllerjenis = TextEditingController();
  String jenis = "-1";
  String status = "";
  bool _isOpendialog = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                      ListTile(
                        title: Text("Pengeluaran"),
                        leading: Radio(
                          value: "Pengeluaran",
                          groupValue: jenis,
                          onChanged: (value) {
                            setState(() {
                              jenis = value as String;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                      ListTile(
                        title: Text("Pemasukan"),
                        leading: Radio(
                          value: "Pemasukan",
                          groupValue: jenis,
                          onChanged: (value) {
                            setState(() {
                              jenis = value as String;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _isOpendialog = true;
                      showDialog(
                          context: context,
                          builder: (alertContext) {
                            var res = UpdateScreenHistory(_controllernama.text,
                                _controllerjumlah.text, jenis);
                            res.then((value) {
                              var decode = jsonDecode(value.body as String);
                              if (decode['success'] == true) {
                                if (_isOpendialog) {
                                  Navigator.pop(alertContext);
                                }
                                isLoading = false;
                                setState(() {
                                  status = "Sukses";
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(
                                              'Message: ${decode['message']}'),
                                        );
                                      });
                                });
                              } else {
                                setState(() {
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
                                });
                              }
                            });
                            return AlertDialog(
                              content: Text('Update ......'),
                            );
                          }).then((_) => _isOpendialog = false);
                      setState(() {
                        isLoading = true;
                      });
                    },
                    child: Text('Submit'),
                  )
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _controllernama.dispose();
    super.dispose();
  }

  Future<http.Response> UpdateScreenHistory(
      String nama, String jumlah, String jenis) {
    final http.Client _client = http.Client();
    return _client.put(
      Uri.parse(
          'https://backend-dompetku.herokuapp.com/api/history/' + widget.id),
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

  @override
  void initState() {
    super.initState();

    _controllernama = TextEditingController(text: widget.nama);
    _controllerjumlah = TextEditingController(text: widget.jumlah);
    if (widget.jenis == "Pengeluaran") {
      jenis = "Pengeluaran";
    } else if (widget.jenis == "Pemasukan") {
      jenis = "Pemasukan";
    } else {
      jenis = "-1";
    }
  }
}
