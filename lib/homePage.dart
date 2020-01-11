import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:clippy/browser.dart' as clippy;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String location = "Onde que eu to?.jpg";
  String distance = "A distância até a morena";
  String time = "Sem tempo, irmão.";
  StreamController<String> pageStream;

  @override
  void initState() {
    // TODO: implement initState

    pageStream = StreamController<String>();
    update();
    super.initState();
  }

  update() async {
    String link =
        "https://firestore.googleapis.com/v1/projects/marvelland-6969/databases/(default)/documents/locations/currentLocation";
    http.Response response = await http.get(link);
    print(response.statusCode);
    if (response.statusCode != 200) {
      print("Algo deu errado!");
      location = "Onde que eu to?.jpg";
      distance = "A distância até a morena";
      time = "Sem tempo, irmão.";
    } else {
      print(response.body);
      var json = jsonDecode(response.body);
      print("json: " + json.toString());
      var variables = json["fields"];
      print("variables: " + variables.toString());
      setState(() {
        try {
          location = variables["currentLocation"]["stringValue"];
          distance = double.parse(variables["currentDistance"]["stringValue"])
                  .toStringAsPrecision(3) +
              " m";
          time = variables["time"]["stringValue"];
        } catch (e) {
          print("Erro: $e");
        }
      });
    }
  }
  //https://stackoverflow.com/questions/46260055/how-to-make-copyable-text-widget-in-flutter
  //https://www.google.com/search?q=flutter+web+copy+text&rlz=1C1SQJL_pt-BRBR857BR857&oq=flutter+web+copy+&aqs=chrome.2.69i57j0l2j69i64.7886j0j7&sourceid=chrome&ie=UTF-8

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (contextt, constraints) {
      double scale = 0.46;
      if (constraints.maxWidth > 750) scale = 1;
      return Container(
        padding: EdgeInsets.all(5),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.loose,
                        child: SelectableText(
                          location,
                          style: TextStyle(
                              fontSize: 80 * scale, color: Colors.blue),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            print("Copied");
                            if (kIsWeb) {
                              // running on the web!
                              print("Click on web!");
                              await clippy.write(location);
                            } else {
                              print("Click on non-web!");
                              Clipboard.setData(ClipboardData(text: location));
                            }
                          },
                          icon: Icon(Icons.content_copy))
                    ],
                  ),
                  SelectableText(
                    time,
                    style: TextStyle(fontSize: 50 * (scale + 0.2)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.loose,
                        child: SelectableText(
                          distance,
                          style: TextStyle(fontSize: 40 * (scale + 0.1)),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            print("Update clicked!");
                            update();
                          },
                          icon: Icon(
                            Icons.replay,
                            color: Colors.greenAccent,
                          ))
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "Estive por aqui...",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Raph",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          ],
        ),
      );
    }));
  }
}
