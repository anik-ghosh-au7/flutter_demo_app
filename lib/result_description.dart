import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  final query;
  Home(this.query);

  @override
  _HomeState createState() => _HomeState(this.query);
}

class _HomeState extends State<Home> {
  final query;
  var info;
  _HomeState(this.query);

  @override
  void initState() {
    info = {};
    super.initState();
    getData().then((value) {
      setState(() {
        info = value;
      });
    });
  }

  getData() async {
    String myUrl = 'https://api.duckduckgo.com/?q=$query&format=json';
    var req = await http.get(myUrl);
    info = json.decode(req.body);
    return info;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
          child: info.isEmpty
              ? new CircularProgressIndicator()
              : Visibility(
                  visible: (info['Abstract'].length > 0 ||
                      info['AbstractText'].length > 0),
                  child: SizedBox(
                    height: 400,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyText2,
                              children: <TextSpan>[
                                new TextSpan(
                                    text: 'By DuckDuckGo API: ',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold)),
                                new TextSpan(
                                    text: info['Abstract'].length > 0
                                        ? info['Abstract']
                                        : info['AbstractText']),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
    );
  }
}
