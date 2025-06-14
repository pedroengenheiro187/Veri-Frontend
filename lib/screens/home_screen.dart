
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? image1;
  File? image2;
  String resultText = "";
  bool isLoading = false;

  final picker = ImagePicker();

  Future<void> pickImage(int imageNumber) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) {
          image1 = File(pickedFile.path);
        } else {
          image2 = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> analyzeImages() async {
    if (image1 == null || image2 == null) return;

    setState(() => isLoading = true);

    final uri = Uri.parse('https://veri-backend-vj78.onrender.com/analyze');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('image1', image1!.path));
    request.files.add(await http.MultipartFile.fromPath('image2', image2!.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      setState(() {
        resultText = "Semelhança: ${result['hash_similarity']}%\n${result['conclusion']}";
      });
    } else {
      setState(() {
        resultText = "Erro ao analisar imagens: ${response.statusCode}";
      });
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VeriPoste')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(onPressed: () => pickImage(1), child: Text("Selecionar Imagem 1")),
            if (image1 != null) Image.file(image1!, height: 100),
            ElevatedButton(onPressed: () => pickImage(2), child: Text("Selecionar Imagem 2")),
            if (image2 != null) Image.file(image2!, height: 100),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: analyzeImages,
              child: isLoading ? CircularProgressIndicator(color: Colors.white) : Text("Analisar"),
            ),
            SizedBox(height: 20),
            Text(resultText, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
