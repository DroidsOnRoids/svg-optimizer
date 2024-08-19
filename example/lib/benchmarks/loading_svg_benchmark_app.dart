import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingSvgBenchmarkApp extends StatelessWidget {
  const LoadingSvgBenchmarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Benchmark App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BenchmarkPage(title: 'Benchmark App'),
    );
  }
}

class BenchmarkPage extends StatefulWidget {
  const BenchmarkPage({super.key, required this.title});

  final String title;

  @override
  State<BenchmarkPage> createState() => _BenchmarkPageState();
}

class _BenchmarkPageState extends State<BenchmarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getSvgPaths(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              return PicturesList(svgPaths: snapshot.data!);
            },
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<List<String>> getSvgPaths() async {
    final List<String> bigProjectImages =
        await getImagePaths('assets/benchmark_svg/big_project');
    final List<String> mediumProjectImages =
        await getImagePaths('assets/benchmark_svg/medium_project');
    final List<String> smallProjectImages =
        await getImagePaths('assets/benchmark_svg/small_project');
    return bigProjectImages + mediumProjectImages + smallProjectImages;
  }

  Future<List<String>> getImagePaths(String path) async =>
      jsonDecode(await rootBundle.loadString('AssetManifest.json'))
          .keys
          .where((String key) => key.contains(path))
          .toList();
}

const Key picturesListKey = ValueKey('picturesListKey');

class PicturesList extends StatelessWidget {
  final List<String> svgPaths;

  const PicturesList({
    super.key = picturesListKey,
    required this.svgPaths,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: svgPaths.asMap().entries.map(
          (e) {
            return Column(
              children: [
                Text(e.value),
                SvgPicture.asset(
                  e.value,
                  key: ValueKey('item_${e.key}_svg'),
                  width: 200,
                  height: 200,
                  placeholderBuilder: (_) => const CircularProgressIndicator(),
                ),
              ],
            );
          },
        ).toList(),
      );
}
