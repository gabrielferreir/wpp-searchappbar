import 'package:flutter/material.dart';
import 'package:whatsapp_appbar/custom_appbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Appbar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SearchScaffold(
      appBar: AppBar(
        title: Text('Search Appbar'),
        actions: [IconButton(icon: Icon(Icons.build), onPressed: () {})],
      ),
      drawer: Drawer(),
      body: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          title: Text('Line $index'),
        ),
        itemCount: 32,
      ),
      bodySearch: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          leading: Icon(Icons.chat),
          title: Text('Search $index'),
        ),
        itemCount: 32,
      ),
      maxHeight: 180,
      labelSearch: 'Search...',
      searchBottom: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Chip(
                    label: Text(
                      'Photos',
                      style: TextStyle(color: Colors.black87),
                    ),
                    avatar: Icon(Icons.photo, size: 18, color: Colors.black54)),
                SizedBox(width: 8),
                Chip(
                    label: Text(
                      'Videos',
                      style: TextStyle(color: Colors.black87),
                    ),
                    avatar:
                        Icon(Icons.videocam, size: 18, color: Colors.black54)),
                SizedBox(width: 8),
                Chip(
                    label: Text(
                      'Links',
                      style: TextStyle(color: Colors.black87),
                    ),
                    avatar: Icon(Icons.link, size: 18, color: Colors.black54)),
                SizedBox(width: 8),
              ],
            ),
            Row(
              children: [
                Chip(
                    label: Text(
                      'GIFs',
                      style: TextStyle(color: Colors.black87),
                    ),
                    avatar: Icon(Icons.gif, size: 18, color: Colors.black54)),
                SizedBox(width: 8),
                Chip(
                    label: Text(
                      'Audio',
                      style: TextStyle(color: Colors.black87),
                    ),
                    avatar:
                        Icon(Icons.headset, size: 18, color: Colors.black54)),
                SizedBox(width: 8),
                Chip(
                    label: Text(
                      'Documents',
                      style: TextStyle(color: Colors.black87),
                    ),
                    avatar: Icon(Icons.insert_drive_file,
                        size: 18, color: Colors.black54)),
                SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
