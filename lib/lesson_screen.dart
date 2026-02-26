import 'package:flutter/material.dart';

import 'curriculum_data.dart';
import 'gemini_service.dart';
import 'home_screen.dart';

class LessonScreen extends StatefulWidget {
  final CurriculumUnit unit;
  final CurriculumLesson lesson;

  const LessonScreen({super.key, required this.unit, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Color get unitColor =>
      Color(int.parse("FF${widget.unit.color}", radix: 16));

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "L${widget.lesson.lessonNumber}: ${widget.lesson.titleEn}",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.lesson.titleAr,
              style:
              const TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: unitColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(
              icon: Icon(Icons.menu_book_rounded, size: 18),
              text: "شرح",
            ),
            Tab(
              icon: Icon(Icons.quiz_rounded, size: 18),
              text: "تمارين",
            ),
            Tab(
              icon: Icon(Icons.chat_bubble_rounded, size: 18),
              text: "محادثة",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ExplainTab(unit: widget.unit, lesson: widget.lesson),
          _ExercisesTab(unit: widget.unit, lesson: widget.lesson),
          _ChatTab(unit: widget.unit, lesson: widget.lesson),
        ],
      ),
    );
  }
}

// ==========================================
// Tab 1: شرح الدرس
// ==========================================
class _ExplainTab extends StatefulWidget {
  final CurriculumUnit unit;
  final CurriculumLesson lesson;

  const _ExplainTab({required this.unit, required this.lesson});

  @override
  State<_ExplainTab> createState() => _ExplainTabState();
}

class _ExplainTabState extends State<_ExplainTab>
    with AutomaticKeepAliveClientMixin {
  final _gemini = GeminiService();
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  final List<Map<String, dynamic>> _history = [];
  bool _isLoading = false;
  bool _firstLoad = true;

  Color get unitColor =>
      Color(int.parse("FF${widget.unit.color}", radix: 16));

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadInitialExplanation();
  }

  Future<void> _loadInitialExplanation() async {
    setState(() => _isLoading = true);
    final response = await _gemini.explainLesson(
      unit: widget.unit,
      lesson: widget.lesson,
      userMessage: "اشرح لي درس ${widget.lesson.titleEn} باختصار ومتعة",
    );
    _history.add(GeminiService.modelMessage(response));
    setState(() {
      _messages.add({"role": "model", "text": response});
      _isLoading = false;
      _firstLoad = false;
    });
  }

  Future<void> _askQuestion() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;
    _controller.clear();

    setState(() {
      _messages.add({"role": "user", "text": text});
      _isLoading = true;
    });

    _scrollToBottom();

    final response = await _gemini.explainLesson(
      unit: widget.unit,
      lesson: widget.lesson,
      history: _history,
      userMessage: text,
    );

    _history.add(GeminiService.userMessage(text));
    _history.add(GeminiService.modelMessage(response));

    setState(() {
      _messages.add({"role": "model", "text": response});
      _isLoading = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        // النص الأصلي (collapsible)
        _TextPreviewCard(
            lesson: widget.lesson, color: unitColor),

        // المحادثة مع المدرسة
        Expanded(
          child: _firstLoad && _isLoading
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: unitColor),
                const SizedBox(height: 12),
                Text("نور بتشرح الدرس...",
                    style: TextStyle(color: unitColor)),
              ],
            ),
          )
              : ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: _messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      CircularProgressIndicator(
                          color: unitColor, strokeWidth: 2),
                      const SizedBox(width: 10),
                      Text("نور بتفكر...",
                          style: TextStyle(color: unitColor)),
                    ],
                  ),
                );
              }
              final msg = _messages[index];
              final isUser = msg["role"] == "user";
              return SpeakableChatBubble(
                text: msg["text"]!,
                isUser: isUser,
                color: unitColor,
              );
            },
          ),
        ),

        // Quick questions
        if (!_isLoading)
          _QuickQuestionsBar(
            questions: const [
              "اشرح تاني بأبسط",
              "إيه الكلمات المهمة؟",
              "ادي مثال",
              "إيه علاقتها بالقاعدة؟",
            ],
            color: unitColor,
            onSelected: (q) {
              _controller.text = q;
              _askQuestion();
            },
          ),

        // Input
        _ChatInputBar(
          controller: _controller,
          color: unitColor,
          hint: "اسأل عن الدرس...",
          onSend: _askQuestion,
        ),
      ],
    );
  }
}

// ==========================================
// Tab 2: التمارين
// ==========================================
class _ExercisesTab extends StatefulWidget {
  final CurriculumUnit unit;
  final CurriculumLesson lesson;

  const _ExercisesTab({required this.unit, required this.lesson});

  @override
  State<_ExercisesTab> createState() => _ExercisesTabState();
}

class _ExercisesTabState extends State<_ExercisesTab>
    with AutomaticKeepAliveClientMixin {
  final _gemini = GeminiService();
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  final List<Map<String, dynamic>> _history = [];
  bool _isLoading = false;
  int _currentExercise = 0;

  Color get unitColor =>
      Color(int.parse("FF${widget.unit.color}", radix: 16));

  @override
  bool get wantKeepAlive => true;

  Future<void> _sendAnswer(String text) async {
    if (text.isEmpty || _isLoading) return;
    _controller.clear();

    setState(() {
      _messages.add({"role": "user", "text": text});
      _isLoading = true;
    });

    final response = await _gemini.helpWithExercise(
      unit: widget.unit,
      lesson: widget.lesson,
      history: _history,
      userMessage: text,
    );

    _history.add(GeminiService.userMessage(text));
    _history.add(GeminiService.modelMessage(response));

    setState(() {
      _messages.add({"role": "model", "text": response});
      _isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final exercises = widget.lesson.exercises;

    if (exercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("🎯", style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            const Text("مفيش تمارين محددة لهذا الدرس"),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _sendAnswer(
                    "اعملي تمارين على درس ${widget.lesson.titleEn}");
              },
              style: ElevatedButton.styleFrom(backgroundColor: unitColor),
              child: const Text("اطلب تمارين من نور",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Exercise selector
        if (exercises.length > 1)
          Container(
            height: 44,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: exercises.length,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () => setState(() => _currentExercise = i),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: _currentExercise == i
                          ? unitColor
                          : unitColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "تمرين ${i + 1}",
                      style: TextStyle(
                        color: _currentExercise == i ? Colors.white : unitColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        // Current exercise
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Exercise card
              SliverToBoxAdapter(
                child: _ExerciseCard(
                  exercise: exercises[_currentExercise],
                  color: unitColor,
                  onAnswerSelected: _sendAnswer,
                ),
              ),

              // AI conversation
              if (_messages.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        if (index == _messages.length) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                CircularProgressIndicator(
                                    color: unitColor, strokeWidth: 2),
                                const SizedBox(width: 10),
                                const Text("نور بتصحح...",
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          );
                        }
                        final msg = _messages[index];
                        return SpeakableChatBubble(
                          text: msg["text"]!,
                          isUser: msg["role"] == "user",
                          color: unitColor,
                        );
                      },
                      childCount:
                      _messages.length + (_isLoading ? 1 : 0),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Input
        _ChatInputBar(
          controller: _controller,
          color: unitColor,
          hint: "اكتب إجابتك هنا...",
          onSend: () => _sendAnswer(_controller.text.trim()),
        ),
      ],
    );
  }
}

// ==========================================
// Tab 3: المحادثة الحرة
// ==========================================
class _ChatTab extends StatefulWidget {
  final CurriculumUnit unit;
  final CurriculumLesson lesson;

  const _ChatTab({required this.unit, required this.lesson});

  @override
  State<_ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<_ChatTab>
    with AutomaticKeepAliveClientMixin {
  final _gemini = GeminiService();
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  final List<Map<String, dynamic>> _history = [];
  bool _isLoading = false;

  Color get unitColor =>
      Color(int.parse("FF${widget.unit.color}", radix: 16));

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _messages.add({
      "role": "model",
      "text":
      "🌟 أهلاً! دلوقتي هنتكلم بالإنجليزي عن موضوع الدرس: **${widget.lesson.titleEn}** ✨\n\nابدأ وقولي حاجة بالإنجليزي!\nأو اسأل: 'How do I start?'",
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;
    _controller.clear();

    setState(() {
      _messages.add({"role": "user", "text": text});
      _isLoading = true;
    });

    _scrollToBottom();

    final response = await _gemini.chat(
      unit: widget.unit,
      lesson: widget.lesson,
      history: _history,
      userMessage: text,
    );

    _history.add(GeminiService.userMessage(text));
    _history.add(GeminiService.modelMessage(response));

    setState(() {
      _messages.add({"role": "model", "text": response});
      _isLoading = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        // Topic chips
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Text("مواضيع: ",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                ...widget.lesson.keyWords.take(5).map(
                      (word) => _TopicChip(
                    word: word,
                    color: unitColor,
                    onTap: () {
                      _controller.text = "Tell me about '$word'";
                      _send();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Messages
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: _messages.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: unitColor),
                        ),
                        const SizedBox(width: 8),
                        const Text("نور بتكتب...",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }
              final msg = _messages[index];
              return SpeakableChatBubble(
                text: msg["text"]!,
                isUser: msg["role"] == "user",
                color: unitColor,
              );
            },
          ),
        ),

        // Quick starters
        if (_messages.length <= 1)
          _QuickQuestionsBar(
            questions: const [
              "How do I start?",
              "What is a digital native?",
              "Tell me about trends",
              "What is screen time?",
            ],
            color: unitColor,
            onSelected: (q) {
              _controller.text = q;
              _send();
            },
          ),

        _ChatInputBar(
          controller: _controller,
          color: unitColor,
          hint: "اكتب بالإنجليزي أو العربي...",
          onSend: _send,
        ),
      ],
    );
  }
}

// ==========================================
// Shared Widgets
// ==========================================

class _TextPreviewCard extends StatefulWidget {
  final CurriculumLesson lesson;
  final Color color;

  const _TextPreviewCard({required this.lesson, required this.color});

  @override
  State<_TextPreviewCard> createState() => _TextPreviewCardState();
}

class _TextPreviewCardState extends State<_TextPreviewCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: widget.color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: widget.color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.lesson.emoji),
                const SizedBox(width: 8),
                Text(
                  "النص الأصلي ${_expanded ? '▲' : '▼'}",
                  style: TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Text(
                  _expanded ? "إخفاء" : "عرض",
                  style: TextStyle(color: widget.color, fontSize: 12),
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Text(
                widget.lesson.mainText.trim(),
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.7,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatefulWidget {
  final ExerciseItem exercise;
  final Color color;
  final Function(String) onAnswerSelected;

  const _ExerciseCard({
    required this.exercise,
    required this.color,
    required this.onAnswerSelected,
  });

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> {
  int? _selectedQ;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instruction header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.08),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(Icons.assignment_rounded, color: widget.color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.exercise.instruction,
                    style: TextStyle(
                      color: widget.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Questions
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: List.generate(
                widget.exercise.questions.length,
                    (i) => GestureDetector(
                  onTap: () {
                    setState(() => _selectedQ = i);
                    final q = widget.exercise.questions[i];
                    widget.onAnswerSelected(
                        "السؤال: $q\n\nإجابتي: اشرح لي إجابة السؤال ده.");
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _selectedQ == i
                          ? widget.color.withOpacity(0.08)
                          : const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _selectedQ == i
                            ? widget.color.withOpacity(0.4)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _selectedQ == i
                                ? widget.color
                                : widget.color.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "${i + 1}",
                              style: TextStyle(
                                color: _selectedQ == i
                                    ? Colors.white
                                    : widget.color,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.exercise.questions[i],
                            style: const TextStyle(fontSize: 13, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Hint button
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    widget.onAnswerSelected(
                        "ساعدني في تمرين ${widget.exercise.instruction}. ادي لي تلميح.");
                  },
                  icon: Icon(Icons.lightbulb_outline,
                      color: widget.color, size: 16),
                  label:
                  Text("تلميح", style: TextStyle(color: widget.color)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: widget.color),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    widget.onAnswerSelected(
                        "إيه الإجابات الكاملة لتمرين: ${widget.exercise.instruction}؟ اشرح كل إجابة.");
                  },
                  icon: Icon(Icons.visibility, color: widget.color, size: 16),
                  label: Text("الإجابات",
                      style: TextStyle(color: widget.color)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: widget.color),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final Color color;

  const _MessageBubble({super.key, required this.text, required this.isUser, required this.color});



  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          color: isUser ? color : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : const Color(0xFF1A1A2E),
            fontSize: 14,
            height: 1.55,
          ),
        ),
      ),
    );
  }
}

class _QuickQuestionsBar extends StatelessWidget {
  final List<String> questions;
  final Color color;
  final Function(String) onSelected;

  const _QuickQuestionsBar({
    required this.questions,
    required this.color,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: questions.length,
        itemBuilder: (context, i) => GestureDetector(
          onTap: () => onSelected(questions[i]),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                questions[i],
                style: TextStyle(
                    color: color, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final Color color;
  final String hint;
  final VoidCallback onSend;

  const _ChatInputBar({
    required this.controller,
    required this.color,
    required this.hint,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    hintStyle:
                    const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  onSubmitted: (_) => onSend(),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onSend,
              child: Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  final String word;
  final Color color;
  final VoidCallback onTap;

  const _TopicChip({
    required this.word,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          word,
          style: TextStyle(color: color, fontSize: 11),
        ),
      ),
    );
  }
}