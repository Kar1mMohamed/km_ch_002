# 📝 Text Analyzer Flutter App

<div dir="rtl">

تطبيق Flutter لتحليل النصوص وإنشاء ملفات كلمات عشوائية باستخدام **🔀Isolates** لتحسين الأداء والتعامل مع العمليات الثقيلة بكفاءة.

---

### ✨ **الميزات** | Features

1. **تحليل النصوص**: اختر ملف نصي لتحليله وعرض:
   - إجمالي عدد الكلمات.
   - عدد الكلمات الفريدة.
   - الكلمة الأكثر تكرارًا.
   
   **Analyze text files**: Select a text file and display:
   - Total word count.
   - Unique word count.
   - Most frequent word.

2. **البحث عن الكلمات**: ابحث عن كلمة معينة وعرض عدد مرات تكرارها.
   
   **Search Words**: Find a specific word and view its count.

3. **إنشاء ملفات كلمات عشوائية**: أنشئ ملف يحتوي على 1,000 كلمة عشوائية واحفظه محليًا.
   
   **Generate Random Word File**: Create a file with 1,000 random words and save it locally.


## 🛠️ شرح الكود
🔀 Isolates: تم استخدام Isolates لتحليل النصوص بكفاءة وتحسين استجابة التطبيق.

Efficient processing using Isolates to offload heavy tasks and maintain UI responsiveness.

📂 File Picker: مكتبة لاختيار الملفات النصية من الجهاز.

File Picker is used to select text files from the device.

📃 Random Word Generation: يتم إنشاء ملف يحتوي على 1,000 كلمة عشوائية باستخدام قائمة كلمات مسبقة.

Random Word Generation creates a file with 1,000 random words based on a predefined list.

## 🖥️ طريقة الاستخدام | Usage
Select File: اختر ملف نصي لتحليله.

Analyze File: قم بتحليل الملف للحصول على الإحصائيات.

Search for Words: ابحث عن كلمة محددة في النص.

Create Word File: أنشئ ملف جديد يحتوي على كلمات عشوائية.

Select File: Choose a text file to analyze.

Analyze File: Process the file to get statistics.

Search for Words: Find a specific word in the text.

Create Word File: Generate a new file with random words.

## 📚 التقنيات المستخدمة | Tech Stack
Flutter: واجهة المستخدم.
Dart: لغة البرمجة.
file_picker: اختيار الملفات النصية.
path_provider: الوصول إلى مسارات النظام.
Isolates: معالجة النصوص في مسارات منفصلة.