import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;

  // ==========================================
  // التهيئة الأولى
  // ==========================================
  Future<void> init() async {
    if (_isInitialized) return;

    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.42);   // بطيء شوية عشان يتعلم
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    // اختر أحسن صوت إنجليزي لو موجود
    final voices = await _tts.getVoices;
    if (voices != null) {
      final enVoices = (voices as List)
          .where((v) =>
      v['locale']?.toString().startsWith('en') == true)
          .toList();
      if (enVoices.isNotEmpty) {
        await _tts.setVoice({
          "name": enVoices.first['name'],
          "locale": enVoices.first['locale'],
        });
      }
    }

    _tts.setStartHandler(() => _isSpeaking = true);
    _tts.setCompletionHandler(() => _isSpeaking = false);
    _tts.setCancelHandler(() => _isSpeaking = false);

    _isInitialized = true;
  }

  // ==========================================
  // نطق كلمة واحدة — 3 مرات مع وقفة
  // ==========================================
  Future<void> speakWord(String word, {int times = 3}) async {
    await init();
    await stop();

    // نظف الكلمة من علامات الترقيم
    final clean = word
        .replaceAll(RegExp(r'[*_\[\]()#]'), '')
        .trim();

    for (int i = 0; i < times; i++) {
      await _tts.speak(clean);
      // انتظر ما تخلص + وقفة قصيرة بين كل مرة
      await Future.delayed(
        Duration(milliseconds: (clean.length * 70) + 600),
      );
    }
  }

  // ==========================================
  // نطق جملة كاملة — مرة وحدة (أو أكتر)
  // ==========================================
  Future<void> speakSentence(String sentence, {int times = 1}) async {
    await init();
    await stop();

    // استخرج النص الإنجليزي فقط (اشيل العربي والإيموجي)
    final english = _extractEnglish(sentence);
    if (english.isEmpty) return;

    // اضبط سرعة الجملة أسرع شوية من الكلمة
    await _tts.setSpeechRate(0.48);

    for (int i = 0; i < times; i++) {
      await _tts.speak(english);
      await Future.delayed(
        Duration(milliseconds: (english.length * 55) + 500),
      );
    }

    // رجع السرعة للطبيعي
    await _tts.setSpeechRate(0.42);
  }

  // ==========================================
  // نطق الكلمات المفتاحية من درس كامل
  // ==========================================
  Future<void> speakVocabularyList(List<String> words) async {
    await init();
    await stop();

    await _tts.setSpeechRate(0.38); // أبطأ للمفردات

    for (final word in words) {
      // كل كلمة في المفردات بالشكل "english - عربي"
      final parts = word.split(" - ");
      final english = parts.isNotEmpty ? parts[0].trim() : word.trim();

      if (english.isEmpty) continue;

      // قول الكلمة 2 مرة
      await _tts.speak(english);
      await Future.delayed(
        Duration(milliseconds: (english.length * 80) + 700),
      );
      await _tts.speak(english);
      await Future.delayed(
        Duration(milliseconds: (english.length * 80) + 1000),
      );
    }

    await _tts.setSpeechRate(0.42);
  }

  // ==========================================
  // وقف الكلام
  // ==========================================
  Future<void> stop() async {
    await _tts.stop();
    _isSpeaking = false;
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // ==========================================
  // Helper: استخرج النص الإنجليزي فقط
  // ==========================================
  String _extractEnglish(String text) {
    // اشيل السطور اللي فيها عربي أو إيموجي
    final lines = text.split('\n');
    final englishLines = lines.where((line) {
      // شيل السطور العربية والإيموجي والفارغة
      final stripped = line.replaceAll(RegExp(r'[^\x00-\x7F]'), '').trim();
      return stripped.length > 3 && !line.trim().startsWith('🗣') &&
          !line.trim().startsWith('✅') && !line.trim().startsWith('💡');
    }).toList();

    return englishLines
        .join(' ')
        .replaceAll(RegExp(r'\*+'), '')
        .replaceAll(RegExp(r'#+'), '')
        .replaceAll(RegExp(r'[^\x00-\x7F]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  // ==========================================
  // تغيير سرعة الكلام
  // ==========================================
  Future<void> setSpeed(double speed) async {
    await _tts.setSpeechRate(speed);
  }
}