import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var dio = Dio();
  var url = 'http://s3.autogestor.net/1/vehicles/1/photos/1qCy0PnIVxaang3P1WJCTTnRtBZ0nJEG.jpg';
  var percent;
  var imageFilePath;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    if (directory is Directory) {
      final Directory _appDocDirFolder = Directory('${directory.path}/photos/');
      if (await _appDocDirFolder.exists()) {
        return _appDocDirFolder.path;
      } else {
        final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
        if (await _appDocDirNewFolder.exists()) {
          return _appDocDirNewFolder.path;
        }
      }
    }
    return '';
  }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(responseType: ResponseType.bytes, followRedirects: false, receiveTimeout: 0),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      percent = (received / total * 100).toStringAsFixed(0) + "%";
      print(percent);
      setState(() {});
    }
  }

  void _incrementCounter() async {
    final path = await _localPath;
    print('path: $path');
    imageFilePath = '$path/1qCy0PnIVxaang3P1WJCTTnRtBZ0nJEG.jpg';
    setState(() {});
    // var tempDir = await getTemporaryDirectory();
    // String fullPath = tempDir.path + "/boo2.pdf'";
    // print('full path $fullPath');
    //download2(dio, url, "$path/1qCy0PnIVxaang3P1WJCTTnRtBZ0nJEG.jpg");

    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text('Baixar imagem'),
            Text('$percent'),
            if (imageFilePath != null) Image.file(File(imageFilePath)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
