import 'package:dio/dio.dart';
import 'curriculum_data.dart';

class GeminiService {
  final Dio _dio = Dio();
  final String _apiKey = 'AIzaSyDrzvLOxZ-iCrHR4wV-69Bh4PpxCopKtN4';
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  // ==========================================
  // الـ Prompt الأساسي للمدرس
  // ==========================================
  String _buildSystemPrompt({
    CurriculumUnit? unit,
    CurriculumLesson? lesson,
    required String mode, // explain / exercise / chat
  }) {
    final unitContext = unit != null
        ? """
أنت تدرّس الآن:
📚 الوحدة: Unit ${unit.unitNumber} - ${unit.titleEn} (${unit.titleAr})
📐 القاعدة النحوية: ${unit.grammar} (${unit.grammarAr})
📝 المفردات المطلوبة: ${unit.vocabulary.take(8).join(', ')}
"""
        : "";

    final lessonContext = lesson != null
        ? """
📖 الدرس الحالي: Lesson ${lesson.lessonNumber} - ${lesson.titleEn} (${lesson.titleAr})
🔑 الكلمات المفتاحية: ${lesson.keyWords.join(', ')}
📌 نوع الدرس: ${lesson.type}
"""
        : "";

    final modeInstructions = switch (mode) {
      "explain" => """
مهمتك الآن: اشرح الدرس بأسلوب ممتع وبسيط.

أسلوب الشرح:
1. ابدأ بسؤال يجذب الانتباه
2. اشرح الفكرة الرئيسية بالعامية المصرية
3. اعطي أمثلة من الحياة اليومية
4. وضّح النطق بالعربي لكل كلمة إنجليزي مهمة
5. خلّص بنقاط سريعة

فورمات الرد:
🎯 **الفكرة الرئيسية:** [شرح مبسط بالعامية]
📖 **المحتوى:** [الشرح التفصيلي مع أمثلة]
🗣️ **النطق:** [نطق الكلمات المهمة بالعربي]
💡 **نقطة مهمة:** [تلميح أو قاعدة سريعة]
""",
      "exercise" => """
مهمتك الآن: ساعد الطالب يحل التمارين.

أسلوبك:
1. لو الطالب جاوب — صحح واشرح ليه الإجابة صح أو غلط
2. لو طلب المساعدة — قدّم تلميح أولاً قبل الإجابة الكاملة
3. اشجعه دايماً حتى لو غلط
4. اشرح القاعدة اللي وراء الإجابة الصح

فورمات الرد:
✅ أو ❌ **النتيجة:** [صح أو غلط]
💬 **الإجابة الصحيحة:** [الإجابة]
📚 **ليه؟:** [شرح بالعامية المصرية]
🌟 **تشجيع:** [كلمة تشجيع]
""",
      "chat" => """
مهمتك الآن: تتكلم مع الطالب وتدرّبه على الإنجليزي.

أسلوبك:
1. رد بالإنجليزي أولاً
2. صحح أي غلطة بلطف بالعربي
3. اكتب نطق أي كلمة صعبة بحروف عربية
4. افتح مواضيع مرتبطة بالدرس
5. استخدم مفردات الدرس في كلامك

فورمات الرد:
💬 **English:** [ردك بالإنجليزي]
🗣️ **النطق:** [نطق الكلمات الصعبة = حروف عربية]
✅ **تصحيح:** [لو في غلطة — اشرح بالعامية المصرية]
💡 **كلمة الجلسة:** [كلمة جديدة من مفردات الدرس + نطقها + معناها]
""",
      _ => "",
    };

    return """
أنت "نور" — مدرسة إنجليزي محترفة ومتخصصة في منهج الصف الثاني الإعدادي المصري (الترم الأول 2025-2026).

$unitContext
$lessonContext
$modeInstructions

قواعد مهمة جداً:
• دايماً تكلم الطالب بأسلوب حماسي ومشجع
• استخدم الإيموجي عشان الكلام يبقى ممتع
• لو الطالب بيكتب بالعربي، رد عليه بالعربي وشجعه يكتب بالإنجليزي
• خلّي ردودك مختصرة وواضحة — مش فقرات طويلة
• دايماً اربط الشرح بحياة الطالب اليومية
""";
  }

  // ==========================================
  // شرح درس كامل
  // ==========================================
  Future<String> explainLesson({
    required CurriculumUnit unit,
    required CurriculumLesson lesson,
    List<Map<String, dynamic>> history = const [],
    String userMessage = "اشرح لي الدرس",
  }) async {
    return _sendRequest(
      systemPrompt: _buildSystemPrompt(unit: unit, lesson: lesson, mode: "explain"),
      history: history,
      userMessage: userMessage,
    );
  }

  // ==========================================
  // مساعدة في التمارين
  // ==========================================
  Future<String> helpWithExercise({
    required CurriculumUnit unit,
    required CurriculumLesson lesson,
    List<Map<String, dynamic>> history = const [],
    required String userMessage,
  }) async {
    return _sendRequest(
      systemPrompt: _buildSystemPrompt(unit: unit, lesson: lesson, mode: "exercise"),
      history: history,
      userMessage: userMessage,
    );
  }

  // ==========================================
  // محادثة حرة مع مراعاة الدرس
  // ==========================================
  Future<String> chat({
    CurriculumUnit? unit,
    CurriculumLesson? lesson,
    List<Map<String, dynamic>> history = const [],
    required String userMessage,
  }) async {
    return _sendRequest(
      systemPrompt: _buildSystemPrompt(unit: unit, lesson: lesson, mode: "chat"),
      history: history,
      userMessage: userMessage,
    );
  }

  // ==========================================
  // شرح قاعدة نحوية
  // ==========================================
  Future<String> explainGrammar({
    required CurriculumUnit unit,
    List<Map<String, dynamic>> history = const [],
    String userMessage = "اشرح لي القاعدة النحوية",
  }) async {
    final grammarPrompt = """
أنت مدرسة إنجليزي متخصصة. اشرح قاعدة "${unit.grammar}" (${unit.grammarAr}) لطالب في الصف الثاني الإعدادي.

اتبع الخطوات:
1. شرح القاعدة بالعامية المصرية البسيطة
2. التركيب (Structure/Formula)
3. 3 أمثلة من الحياة اليومية
4. متى نستخدمها بالضبط
5. الأخطاء الشائعة + إزاي تتجنبها

فورمات الرد:
📐 **القاعدة:** [اسم القاعدة + شرح بالعربي]
🔧 **التركيب:** [Formula]
✏️ **أمثلة:**
   1. ...
   2. ...
   3. ...
⚠️ **خطأ شائع:** [الغلطة الشائعة + الصح]
""";

    return _sendRequest(
      systemPrompt: grammarPrompt,
      history: history,
      userMessage: userMessage,
    );
  }

  // ==========================================
  // شرح مفردة معينة
  // ==========================================
  Future<String> explainWord({
    required String word,
    required String context,
  }) async {
    final prompt = """
أنت مدرسة إنجليزي. اشرح الكلمة الإنجليزية "$word" لطالب في الصف الثاني الإعدادي.

في الجملة: "$context"

اشرح بالفورمة دي:
🔤 **الكلمة:** $word
🗣️ **النطق:** [بالحروف العربية]
📝 **المعنى:** [بالعربي]
💬 **جملة مثال:** [جملة بسيطة]
🔄 **كلمة مشابهة:** [synonym لو موجود]
""";

    return _sendRequest(
      systemPrompt: prompt,
      history: [],
      userMessage: "اشرح الكلمة",
    );
  }

  // ==========================================
  // الدالة الأساسية للإرسال
  // ==========================================
  Future<String> _sendRequest({
    required String systemPrompt,
    required List<Map<String, dynamic>> history,
    required String userMessage,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl?key=$_apiKey',
        data: {
          "system_instruction": {
            "parts": [
              {"text": systemPrompt}
            ]
          },
          "contents": [
            ...history,
            {
              "role": "user",
              "parts": [
                {"text": userMessage}
              ]
            },
          ],
          "generationConfig": {
            "temperature": 0.8,
            "maxOutputTokens": 1000,
          }
        },
      );

      if (response.data != null && response.data['candidates'] != null) {
        return response.data['candidates'][0]['content']['parts'][0]['text'];
      }
      return "❌ مش قادر أجيب رد دلوقتي. جرب تاني!";
    } on DioException catch (e) {
      print("Status Code: ${e.response?.statusCode}");
      print("Error Data: ${e.response?.data}");

      if (e.response?.statusCode == 429) {
        return "⏳ كتير أوي على السيرفر دلوقتي، استنى ثانية وجرب تاني!";
      } else if (e.response?.statusCode == 404) {
        return "❌ مشكلة في الإعدادات، كلم المطور!";
      }
      return "❌ مشكلة في الاتصال: ${e.message}";
    } catch (e) {
      return "❌ خطأ غير متوقع: $e";
    }
  }

  // ==========================================
  // Helper: تحويل التاريخ للفورمات المطلوب
  // ==========================================
  static Map<String, dynamic> userMessage(String text) => {
        "role": "user",
        "parts": [
          {"text": text}
        ]
      };

  static Map<String, dynamic> modelMessage(String text) => {
        "role": "model",
        "parts": [
          {"text": text}
        ]
      };
}
