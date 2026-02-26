import 'package:flutter/material.dart';

import 'curriculum_data.dart';
import 'gemini_service.dart';
import 'home_screen.dart';
import 'lesson_screen.dart';

class UnitScreen extends StatefulWidget {
  final CurriculumUnit unit;
  final bool openGrammar;

  const UnitScreen({super.key, required this.unit, this.openGrammar = false});

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  Color get unitColor =>
      Color(int.parse("FF${widget.unit.color}", radix: 16));

  @override
  void initState() {
    super.initState();
    if (widget.openGrammar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openGrammarExplainer();
      });
    }
  }

  void _openGrammarExplainer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _GrammarScreen(unit: widget.unit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // ==========================================
          // Unit Header
          // ==========================================
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: unitColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [unitColor, unitColor.withOpacity(0.7)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Unit ${widget.unit.unitNumber}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.unit.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.unit.titleEn,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.unit.titleAr,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==========================================
                // Grammar & Vocab Cards
                // ==========================================
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.auto_fix_high,
                          title: "القاعدة",
                          value: widget.unit.grammar,
                          subValue: widget.unit.grammarAr,
                          color: unitColor,
                          onTap: _openGrammarExplainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.library_books,
                          title: "المفردات",
                          value: "${widget.unit.vocabulary.length} كلمة",
                          subValue: "اضغط للمراجعة",
                          color: unitColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    _VocabularyScreen(unit: widget.unit),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // ==========================================
                // Lessons Title
                // ==========================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Text(
                    "الدروس 📖",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // Lessons List
          // ==========================================
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final lesson = widget.unit.lessons[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _LessonCard(
                      lesson: lesson,
                      unit: widget.unit,
                      color: unitColor,
                    ),
                  );
                },
                childCount: widget.unit.lessons.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// Info Card
// ==========================================
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subValue;
  final Color color;
  final VoidCallback onTap;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subValue,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              subValue,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// Lesson Card
// ==========================================
class _LessonCard extends StatelessWidget {
  final CurriculumLesson lesson;
  final CurriculumUnit unit;
  final Color color;

  const _LessonCard({
    required this.lesson,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LessonScreen(unit: unit, lesson: lesson),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Number circle
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  lesson.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lesson ${lesson.lessonNumber}",
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    lesson.titleEn,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    lesson.titleAr,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Type badge + arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _typeBadge(lesson.type, color),
                const SizedBox(height: 4),
                Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeBadge(String type, Color color) {
    final labels = {
      "reading": "قراءة",
      "listening": "استماع",
      "language": "قواعد",
      "story": "قصة",
      "speaking": "كلام",
      "writing": "كتابة",
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        labels[type] ?? type,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ==========================================
// Grammar Screen
// ==========================================
class _GrammarScreen extends StatefulWidget {
  final CurriculumUnit unit;
  const _GrammarScreen({required this.unit});

  @override
  State<_GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<_GrammarScreen> {
  final _gemini = GeminiService();
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  final List<Map<String, dynamic>> _history = [];
  bool _isLoading = false;

  Color get unitColor =>
      Color(int.parse("FF${widget.unit.color}", radix: 16));

  @override
  void initState() {
    super.initState();
    _loadGrammarExplanation();
  }

  Future<void> _loadGrammarExplanation() async {
    setState(() => _isLoading = true);
    final response = await _gemini.explainGrammar(unit: widget.unit);
    setState(() {
      _messages.add({"role": "model", "text": response});
      _isLoading = false;
    });
    _history.add(GeminiService.modelMessage(response));
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;
    _controller.clear();

    setState(() {
      _messages.add({"role": "user", "text": text});
      _isLoading = true;
    });

    final response = await _gemini.explainGrammar(
      unit: widget.unit,
      history: _history,
      userMessage: text,
    );

    _history.add(GeminiService.userMessage(text));
    _history.add(GeminiService.modelMessage(response));

    setState(() {
      _messages.add({"role": "model", "text": response});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.unit.grammar} 📐"),
        backgroundColor: unitColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          Expanded(
            child: _isLoading && _messages.isEmpty
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: unitColor),
                  const SizedBox(height: 12),
                  Text("نور بتشرح لك القاعدة...",
                      style: TextStyle(color: unitColor)),
                ],
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("نور بتكتب...",
                        style: TextStyle(color: Colors.grey)),
                  );
                }
                final msg = _messages[index];
                final isUser = msg["role"] == "user";
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    constraints: BoxConstraints(
                      maxWidth:
                      MediaQuery.of(context).size.width * 0.85,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? unitColor : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: Text(
                      msg["text"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "اسأل عن القاعدة...",
                        filled: true,
                        fillColor: const Color(0xFFF5F7FA),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: unitColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// Vocabulary Screen
// ==========================================
class _VocabularyScreen extends StatelessWidget {
  final CurriculumUnit unit;
  const _VocabularyScreen({required this.unit});

  Color get unitColor =>
      Color(int.parse("FF${unit.color}", radix: 16));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("مفردات Unit ${unit.unitNumber} 📝"),
        backgroundColor: unitColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // شريط تشغيل الكل مع speed control
          VocabularyPlayerBar(
            vocabulary: unit.vocabulary,
            color: unitColor,
          ),
          // قائمة الكلمات
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: unit.vocabulary.length,
              itemBuilder: (context, index) {
                final word = unit.vocabulary[index];
                final parts = word.split(" - ");
                return VocabWordTile(
                  index: index + 1,
                  englishWord: parts.isNotEmpty ? parts[0] : word,
                  arabicMeaning: parts.length > 1 ? parts[1] : "",
                  color: unitColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}