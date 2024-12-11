import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String?
      filePath; // مسار الملف الذي يختاره المستخدم // Path of the selected file
  String? analysisResult; // نتائج تحليل النص // Analysis results
  Map<String, int>?
      wordCounts; // تخزين الكلمات وعدد تكرارها // Map to store words and their counts
  bool isLoading = false; // حالة التحميل // Loading state indicator

  String?
      createFilePath; // هنا بيتم تخزين مسار الملف الذي تم إنشاؤه // Here the path of the created file is stored

  // دالة لاختيار ملف نصي // Function to select a text file
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
      });
      analyzeFile(
          filePath!); // تحليل النص بعد اختيار الملف // Analyze the text after selecting the file
    }
  }

  // دالة لتحليل النصوص باستخدام Isolate // Function to analyze the text using Isolate
  Future<void> analyzeFile(String path) async {
    setState(() {
      isLoading = true; // تفعيل حالة التحميل // Enable loading state
    });

    // قراءة محتوى الملف // Read the file content
    String content = await File(path).readAsString();

    // إنشاء منفذ للتواصل بين Isolates // Create a port for communication between isolates
    final receivePort = ReceivePort();

    // تشغيل isolate لمعالجة النصوص // Spawn an isolate to process the text
    await Isolate.spawn(processText, [content, receivePort.sendPort]);

    // انتظار النتائج من isolate // Wait for results from the isolate
    final results = await receivePort.first as Map<String, dynamic>;

    setState(() {
      isLoading = false; // إلغاء حالة التحميل // Disable loading state
      analysisResult = '''
Total Words: ${results['totalWords']}
Unique Words: ${results['uniqueWords']}
Most Frequent Word: ${results['mostFrequentWord']} (${results['mostFrequentCount']} times)
''';
      wordCounts = results[
          'wordCounts']; // تخزين النتائج في المتغير // Store the results in the variable
    });
  }

  // دالة للبحث عن كلمة وعدد تكرارها // Function to search for a word and its count
  void searchWord(String word) {
    if (wordCounts == null) return;

    final count = wordCounts![word.toLowerCase()] ?? 0;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
            "Word Search"), // نافذة البحث عن كلمة // Search word dialog
        content: Text(
            'The word "$word" appears $count times.'), // عدد التكرارات // Word count
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> createAndSaveWordsFile() async {
    try {
      // Step 1: Generate 1,000 random words // إنشاء 1000 كلمة عشوائية
      const List<String> wordPool = [
        "apple",
        "banana",
        "cherry",
        "date",
        "elderberry",
        "fig",
        "grape",
        "honeydew",
        "kiwi",
        "lemon",
        "mango",
        "nectarine",
        "orange",
        "papaya",
        "quince",
        "raspberry",
        "strawberry",
        "tangerine",
        "ugli",
        "violet",
        "watermelon",
        "xigua",
        "yam",
        "zucchini",
        "karim",
        "mohamed"
      ];
      final random = Random();
      final List<String> words = List.generate(
        1000,
        (_) => wordPool[random.nextInt(wordPool.length)],
      );

      // Step 2: Convert the list of words into a single string // تحويل القائمة إلى نص واحد
      final content = words.join(' ');

      // Step 3: Get the directory to save the file // الحصول على المسار لحفظ الملف
      final directory = await getApplicationSupportDirectory();
      final filePath = '${directory.path}/random_words.txt';

      setState(() {
        this.filePath = filePath;
      });

      // Step 4: Save the content to a file // حفظ النص في الملف
      final file = File(filePath);
      await file.writeAsString(content);

      // Step 5: Print success message // عرض رسالة النجاح
      if (kDebugMode) {
        print('File saved at: $filePath');
      }
    } catch (e) {
      // Handle any errors // التعامل مع الأخطاء
      if (kDebugMode) {
        print('Error creating file: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Analyzer'), // عنوان التطبيق // App title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              if (filePath == null)
                ElevatedButton(
                  onPressed:
                      pickFile, // زر اختيار الملف // Button to pick a file
                  child: const Text('Select File'),
                )
              else
                ElevatedButton(
                  onPressed: () => analyzeFile(
                      filePath!), // زر تحليل الملف // Button to analyze the file
                  child: const Text('Analyze File'),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    createAndSaveWordsFile, // زر إنشاء ملف الكلمات // Button to create words file
                child: const Text('Create Words File'),
              ),
              if (filePath != null)
                Text(
                    'Selected File: $filePath'), // عرض مسار الملف // Display the selected file path
              if (isLoading)
                const CircularProgressIndicator() // مؤشر تحميل // Loading indicator
              else if (analysisResult != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                        analysisResult!), // عرض نتائج التحليل // Display analysis results
                  ),
                ),
              if (wordCounts != null)
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search for a word', // حقل البحث // Search field
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted:
                      searchWord, // تنفيذ عملية البحث // Perform search
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// دالة معالجة النصوص في Isolate // Worker function to process the text in an isolate
void processText(List<dynamic> args) {
  final String content =
      args[0]; // النص الذي سيتم تحليله // Text to be analyzed
  final SendPort sendPort =
      args[1]; // المنفذ لإرسال البيانات // Port to send data

  // تنظيف النصوص وتجزئتها إلى كلمات // Clean and tokenize text
  List<String> words = content
      .replaceAll(
          RegExp(r'[^\w\s]'), '') // إزالة علامات الترقيم // Remove punctuation
      .toLowerCase() // تحويل النص إلى أحرف صغيرة // Convert text to lowercase
      .split(RegExp(r'\s+')); // فصل النص إلى كلمات // Split text into words

  // عد الكلمات وتحديد الكلمات الفريدة // Count words and find unique words
  Map<String, int> wordCounts = {};
  Set<String> uniqueWords = {};

  for (var word in words) {
    if (word.isEmpty) continue;
    wordCounts[word] =
        (wordCounts[word] ?? 0) + 1; // تحديث عداد الكلمة // Update word count
    uniqueWords.add(
        word); // إضافة الكلمة إلى مجموعة الكلمات الفريدة // Add word to the unique words set
  }

  // العثور على الكلمة الأكثر تكرارًا // Find the most frequent word
  String? mostFrequentWord;
  int mostFrequentCount = 0;

  wordCounts.forEach((word, count) {
    if (count > mostFrequentCount) {
      mostFrequentCount = count;
      mostFrequentWord = word;
    }
  });

  // إرسال النتائج إلى isolate الرئيسي // Send results back to the main isolate
  sendPort.send({
    'totalWords': words.length, // العدد الإجمالي للكلمات // Total word count
    'uniqueWords':
        uniqueWords.length, // عدد الكلمات الفريدة // Unique word count
    'mostFrequentWord':
        mostFrequentWord, // الكلمة الأكثر تكرارًا // Most frequent word
    'mostFrequentCount':
        mostFrequentCount, // عدد تكراراتها // Frequency of the most frequent word
    'wordCounts': wordCounts, // عداد الكلمات // Word counts
  });
}
