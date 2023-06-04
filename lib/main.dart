import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:slango/dictionary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dictionary.loadTranslations();
  runApp(SlangoApp());
}

class SlangoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slango',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black,
        ),
      ),
      home: SlangoScreen(),
    );
  }
}

class SlangoScreen extends StatefulWidget {
  @override
  _SlangoScreenState createState() => _SlangoScreenState();
}

class _SlangoScreenState extends State<SlangoScreen> {
  final slangController = TextEditingController();
  String translation = '';
  List<Map<String, String>> slangsOfTheDay = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    generateSlangsOfTheDay();

    // Schedule timer to update slangs of the day every 24 hours
    timer = Timer.periodic(Duration(hours: 24), (_) {
      setState(() {
        generateSlangsOfTheDay();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    slangController.dispose();
    super.dispose();
  }

  void generateSlangsOfTheDay() {
    final allSlangs = dictionary.slangTranslations.keys.toList();
    final random = Random();
    slangsOfTheDay.clear();
    for (var i = 0; i < 5; i++) {
      final randomSlang = allSlangs[random.nextInt(allSlangs.length)];
      final meaning = dictionary.slangTranslations[randomSlang];
      slangsOfTheDay.add({'slang': randomSlang, 'meaning': meaning ?? ''});
    }
  }

  void translateSlang() {
    final slang = slangController.text;
    if (slang.isEmpty) {
      setState(() {
        translation = '';
      });
      return;
    }

    if (dictionary.slangTranslations.containsKey(slang)) {
      setState(() {
        translation = dictionary.slangTranslations[slang] ?? '';
      });
    } else {
      setState(() {
        translation = 'Translation not found.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slango'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: slangController,
              decoration: InputDecoration(
                labelText: 'Enter a slang term',
              ),
              onSubmitted: (_) => translateSlang(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: translateSlang,
              child: Text('Translate'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Translation: $translation',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 32.0),
            Text(
              'Slangs of the Day:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Column(
              children: slangsOfTheDay
                  .map((slangData) => ListTile(
                        title: Text(
                          '${slangData['slang']}: ${slangData['meaning']}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
