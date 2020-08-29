import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Bluetooth Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const bluetoothChannel =
      const MethodChannel('com.example.bluetooth_sample/bluetoothchannel');

  List<String> _connectedDevicesList = new List<String>();

  Future<void> _getConnectedDevicesList() async {
    List<Object> connectedDevicesList = new List<Object>();
    try {
      connectedDevicesList =
          await bluetoothChannel.invokeMethod('getConnectedDevicesList');
      setState(() {
        connectedDevicesList.forEach((element) {
          _connectedDevicesList.add(element.toString());
        });
      });
    } on PlatformException catch (e) {
      showToast("Could not get connected bluetooth devices '${e.message}");
    }
  }

  @override
  void initState() {
    super.initState();
    _getConnectedDevicesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Paired Devices : ',
              style: TextStyle(color: Colors.blueAccent,
              fontSize: 16),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _connectedDevicesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${_connectedDevicesList[index]}',
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void showToast(String s) {
    bluetoothChannel.invokeMethod('showToast', <String, dynamic>{'message': s});
  }
}
