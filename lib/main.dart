
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

  @override
  void dispose() {
    slangController.dispose();
    super.dispose();
  }

  void translateSlang(String slang) {
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
                labelText: 'Enter a slang term (Capital)',
              ),
              onSubmitted: (value) {
                translateSlang(value);
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                translateSlang(slangController.text);
              },
              child: Text('Translate'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Translation: $translation',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}