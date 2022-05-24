import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Dart Asyncronus Thinking Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _done = Completer<bool>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asyncronus Thinking'),
      ),
      body: Center(
        child: FutureBuilder<bool>(
          initialData: false,
          future: _done.future,
          builder: (context, snapshot) {
            final complete = snapshot.data!;
            if (complete) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Completer Done'),
                  ElevatedButton.icon(
                    onPressed: _nextPage,
                    icon: const Icon(Icons.arrow_right),
                    label: const Text('Next Page'),
                  ),
                ],
              );
            } else {
              return const Text('Waiting Completer');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressedDone,
        child: const Icon(Icons.done),
      ),
    );
  }

  void _onPressedDone() {
    if (!_done.isCompleted) {
      _done.complete(true);
    }
  }

  void _nextPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewPage(),
      ),
    );
  }
}

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  final _streamController = StreamController<bool>();
  bool _state = false;

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asyncronus Thinking'),
      ),
      body: Center(
        child: StreamBuilder<bool>(
          initialData: _state,
          stream: _streamController.stream,
          builder: (context, snapshot) {
            final complete = snapshot.data!;
            if (complete) {
              return const Text('Stream true');
            } else {
              return const Text('Stream false');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressedDone,
        child: Builder(
          builder: (_) {
            if (_state) {
              return const Icon(Icons.arrow_back);
            } else {
              return const Icon(Icons.done);
            }
          },
        ),
      ),
    );
  }

  void _onPressedDone() {
    setState(() {
      _state = !_state;
    });
    _streamController.add(_state);
  }
}
