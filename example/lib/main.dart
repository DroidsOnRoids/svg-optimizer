import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Svg Optimizer demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Svg Optimizer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Non optimized svg:'),
              FutureBuilder(
                future: rootBundle.loadString('assets/svg_no_optimize/heart.svg'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!);
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const Text('Optimized svg:'),
              FutureBuilder(
                future: rootBundle.loadString('assets/svg/heart.svg'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!);
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
