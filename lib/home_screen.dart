import 'package:flutter/material.dart';

import 'TtsService.dart';
import 'curriculum_data.dart';
import 'gemini_service.dart';
import 'unit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // ==========================================
          // Header
          // ==========================================
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1565C0),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "مرحباً! 👋",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "English Prep 2",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "الصف الثاني الإعدادي • ترم 1 • 2025-2026",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Progress bar
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.auto_stories,
                                    color: Colors.white, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  "${curriculumUnits.length} وحدات • ${curriculumUnits.fold(0, (sum, u) => sum + u.lessons.length)} درس",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ==========================================
          // Quick Actions
          // ==========================================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ابدأ من هنا 🚀",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _QuickActionCard(
                        icon: Icons.chat_bubble_rounded,
                        label: "تكلم مع\nالمدرسة",
                        color: const Color(0xFF7C4DFF),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const _GeneralChatScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      _QuickActionCard(
                        icon: Icons.quiz_rounded,
                        label: "وحدة 1\nالجديدة",
                        color: const Color(0xFF1565C0),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  UnitScreen(unit: curriculumUnits[0]),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      _QuickActionCard(
                        icon: Icons.spellcheck_rounded,
                        label: "القاعدة\nالنحوية",
                        color: const Color(0xFF2E7D32),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  UnitScreen(unit: curriculumUnits[0], openGrammar: true),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ==========================================
          // Units Grid
          // ==========================================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: const Text(
                "الوحدات 📚",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final unit = curriculumUnits[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _UnitCard(unit: unit),
                  );
                },
                childCount: curriculumUnits.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// Quick Action Card Widget
// ==========================================
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// Unit Card Widget
// ==========================================
class _UnitCard extends StatelessWidget {
  final CurriculumUnit unit;

  const _UnitCard({required this.unit});

  Color get unitColor => Color(int.parse("FF${unit.color}", radix: 16));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UnitScreen(unit: unit)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [unitColor, unitColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        unit.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Unit ${unit.unitNumber}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          unit.titleEn,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          unit.titleAr,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${unit.lessons.length} دروس",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // Grammar tag
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: unitColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_fix_high,
                                size: 14, color: unitColor),
                            const SizedBox(width: 4),
                            Text(
                              unit.grammar,
                              style: TextStyle(
                                color: unitColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Lessons preview dots
                      Row(
                        children: List.generate(
                          unit.lessons.length,
                              (i) => Container(
                            margin: const EdgeInsets.only(left: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: unitColor.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Lessons list
                  ...unit.lessons.take(3).map(
                        (lesson) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Text(lesson.emoji,
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "L${lesson.lessonNumber}: ${lesson.titleEn}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF424242),
                              ),
                            ),
                          ),
                          _lessonTypeBadge(lesson.type),
                        ],
                      ),
                    ),
                  ),
                  if (unit.lessons.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "+ ${unit.lessons.length - 3} دروس أكتر...",
                        style: TextStyle(
                          color: unitColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lessonTypeBadge(String type) {
    final config = {
      "reading": ("قراءة", const Color(0xFF1565C0)),
      "listening": ("استماع", const Color(0xFF2E7D32)),
      "language": ("قواعد", const Color(0xFFE65100)),
      "story": ("قصة", const Color(0xFF6A1B9A)),
      "speaking": ("كلام", const Color(0xFF00695C)),
      "writing": ("كتابة", const Color(0xFFB71C1C)),
    }[type] ?? ("درس", const Color(0xFF424242));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: config.$2.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        config.$1,
        style: TextStyle(
          color: config.$2,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ==========================================
// General Chat Screen (محادثة حرة)
// ==========================================
class _GeneralChatScreen extends StatefulWidget {
  const _GeneralChatScreen();

  @override
  State<_GeneralChatScreen> createState() => _GeneralChatScreenState();
}

class _GeneralChatScreenState extends State<_GeneralChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _gemini = GeminiService();
  final List<_ChatMessage> _messages = [];
  final List<Map<String, dynamic>> _history = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add(_ChatMessage(
      text:
      "أهلاً! أنا نور، مدرستك الخاصة في الإنجليزي 🌟\n\nأقدر أساعدك في:\n• شرح الدروس والقواعد\n• التمارين\n• المحادثة بالإنجليزي\n\nابدأ وقولي إيه اللي عاوز تتعلمه! 😊",
      isUser: false,
    ));
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    _controller.clear();
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });

    _scrollToBottom();

    final response = await _gemini.chat(userMessage: text, history: _history);

    _history.add(GeminiService.userMessage(text));
    _history.add(GeminiService.modelMessage(response));

    setState(() {
      _messages.add(_ChatMessage(text: response, isUser: false));
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFF7C4DFF),
              radius: 16,
              child: Text("نور", style: TextStyle(color: Colors.white, fontSize: 10)),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("نور - مدرستك",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("متصلة الآن",
                    style: TextStyle(fontSize: 11, color: Colors.green)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const _TypingIndicator();
                }
                return SpeakableChatBubble(
                  text: _messages[index].text,
                  isUser: _messages[index].isUser,
                  color: const Color(0xFF7C4DFF),
                );
              },
            ),
          ),

          // Input
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
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
                        controller: _controller,
                        textDirection: TextDirection.rtl,
                        decoration: const InputDecoration(
                          hintText: "اكتب هنا...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF7C4DFF),
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

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFF7C4DFF) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isUser ? 18 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : const Color(0xFF1A1A2E),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 40,
              child: Text("...", style: TextStyle(fontSize: 20)),
            ),
            Text("نور بتكتب",
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}




// ==========================================
// زرار 🔊 يكرر الكلمة 3 مرات
// ==========================================
class SpeakWordButton extends StatefulWidget {
  final String word;
  final Color? color;
  final double size;
  final int repeatTimes;

  const SpeakWordButton({
    super.key,
    required this.word,
    this.color,
    this.size = 20,
    this.repeatTimes = 3,
  });

  @override
  State<SpeakWordButton> createState() => _SpeakWordButtonState();
}

class _SpeakWordButtonState extends State<SpeakWordButton>
    with SingleTickerProviderStateMixin {
  final _tts = TtsService();
  bool _isPlaying = false;
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _anim = Tween(begin: 0.9, end: 1.1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _speak() async {
    if (_isPlaying) {
      await _tts.stop();
      if (mounted) setState(() => _isPlaying = false);
      _ctrl.stop();
      return;
    }
    setState(() => _isPlaying = true);
    _ctrl.repeat(reverse: true);
    await _tts.speakWord(widget.word, times: widget.repeatTimes);
    if (mounted) {
      setState(() => _isPlaying = false);
      _ctrl.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.color ?? Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: _speak,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Transform.scale(
          scale: _isPlaying ? _anim.value : 1.0,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: c.withOpacity(_isPlaying ? 0.2 : 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isPlaying ? Icons.volume_up_rounded : Icons.volume_up_outlined,
              size: widget.size,
              color: c,
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// بطاقة مفردة: رقم + كلمة + نطق + معنى + صوت
// ==========================================
class VocabWordTile extends StatelessWidget {
  final String englishWord;
  final String arabicMeaning;
  final String? pronunciation;
  final Color color;
  final int index;

  const VocabWordTile({
    super.key,
    required this.englishWord,
    required this.arabicMeaning,
    this.pronunciation,
    required this.color,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration:
            BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
            child: Center(
              child: Text("$index",
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(englishWord,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.3)),
                if (pronunciation != null)
                  Text("🗣 $pronunciation",
                      style: TextStyle(
                          color: color.withOpacity(0.8), fontSize: 12)),
                Text(arabicMeaning,
                    style:
                    const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          SpeakWordButton(word: englishWord, color: color, size: 22, repeatTimes: 3),
        ],
      ),
    );
  }
}

// ==========================================
// Chat Bubble ذكي — AI bubble مع زراير صوت
// ==========================================
class SpeakableChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final Color color;

  const SpeakableChatBubble(
      {super.key, required this.text, required this.isUser, required this.color});

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(text,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, height: 1.5)),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.88),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
              child: _ParsedText(text: text, color: color),
            ),
            _WordsBar(text: text, color: color),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// نص مقسم: يميز الإنجليزي من العربي
// ==========================================
class _ParsedText extends StatelessWidget {
  final String text;
  final Color color;
  const _ParsedText({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: text.split('\n').map<Widget>((line) {
        if (line.trim().isEmpty) return const SizedBox(height: 4);

        if (line.trim().startsWith('💬')) {
          return _EnglishHighlight(line: line, color: color);
        }
        if (line.trim().startsWith('🗣')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(line,
                style: TextStyle(
                    color: color.withOpacity(0.85),
                    fontSize: 13,
                    fontStyle: FontStyle.italic)),
          );
        }
        if (line.trim().startsWith('✅') || line.trim().startsWith('❌')) {
          final ok = line.trim().startsWith('✅');
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: (ok ? Colors.green : Colors.red).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(line,
                style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: ok ? Colors.green[700] : Colors.red[700])),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(line,
              style: const TextStyle(
                  fontSize: 14, height: 1.55, color: Color(0xFF1A1A2E))),
        );
      }).toList(),
    );
  }
}

// ==========================================
// سطر إنجليزي مضلل + زرار صوت
// ==========================================
class _EnglishHighlight extends StatelessWidget {
  final String line;
  final Color color;
  const _EnglishHighlight({required this.line, required this.color});

  String get _clean => line
      .replaceAll(RegExp(r'💬|🔤'), '')
      .replaceAll('**English:**', '')
      .replaceAll('**Response:**', '')
      .replaceAll('**', '')
      .trim();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(line.replaceAll('**', ''),
                style: const TextStyle(
                    fontSize: 14, height: 1.55, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 8),
          SpeakWordButton(word: _clean, color: color, size: 20, repeatTimes: 3),
        ],
      ),
    );
  }
}

// ==========================================
// شريط الكلمات أسفل الـ bubble
// ==========================================
class _WordsBar extends StatelessWidget {
  final String text;
  final Color color;
  const _WordsBar({required this.text, required this.color});

  static const _stop = {
    'the', 'and', 'for', 'are', 'but', 'not', 'you', 'all', 'can', 'her',
    'was', 'one', 'our', 'out', 'day', 'get', 'has', 'him', 'his', 'how',
    'its', 'may', 'new', 'now', 'old', 'see', 'two', 'who', 'did', 'let',
    'put', 'say', 'she', 'too', 'use', 'english', 'correction', 'response',
    'needed', 'also', 'with', 'that', 'this', 'they', 'from', 'have',
    'been', 'what', 'when', 'will', 'your', 'each', 'well', 'then',
  };

  List<String> _extract() {
    final seen = <String>{};
    final result = <String>[];
    for (final m in RegExp(r"\b[A-Za-z][A-Za-z'-]{2,}\b").allMatches(text)) {
      final w = m.group(0)!;
      if (!seen.contains(w.toLowerCase()) && !_stop.contains(w.toLowerCase())) {
        seen.add(w.toLowerCase());
        result.add(w);
      }
    }
    return result.take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    final words = _extract();
    if (words.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
      decoration:
      BoxDecoration(border: Border(top: BorderSide(color: color.withOpacity(0.1)))),
      child: Row(
        children: [
          const Text("🔊", style: TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: words.map((w) => _WordChip(word: w, color: color)).toList()),
            ),
          ),
        ],
      ),
    );
  }
}

class _WordChip extends StatefulWidget {
  final String word;
  final Color color;
  const _WordChip({required this.word, required this.color});

  @override
  State<_WordChip> createState() => _WordChipState();
}

class _WordChipState extends State<_WordChip> {
  final _tts = TtsService();
  bool _p = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() => _p = true);
        await _tts.speakWord(widget.word, times: 3);
        if (mounted) setState(() => _p = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: widget.color.withOpacity(_p ? 0.2 : 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.color.withOpacity(_p ? 0.6 : 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _p ? Icons.volume_up_rounded : Icons.volume_up_outlined,
              size: 12,
              color: widget.color,
            ),
            const SizedBox(width: 3),
            Text(widget.word,
                style: TextStyle(
                    color: widget.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// شريط تشغيل المفردات دفعة واحدة مع speed control
// ==========================================
class VocabularyPlayerBar extends StatefulWidget {
  final List<String> vocabulary;
  final Color color;

  const VocabularyPlayerBar(
      {super.key, required this.vocabulary, required this.color});

  @override
  State<VocabularyPlayerBar> createState() => _VocabularyPlayerBarState();
}

class _VocabularyPlayerBarState extends State<VocabularyPlayerBar> {
  final _tts = TtsService();
  bool _isPlaying = false;
  double _speed = 0.42;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.07),
        border:
        Border(bottom: BorderSide(color: widget.color.withOpacity(0.15))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (_isPlaying) {
                await _tts.stop();
                setState(() => _isPlaying = false);
                return;
              }
              setState(() => _isPlaying = true);
              await _tts.speakVocabularyList(widget.vocabulary);
              if (mounted) setState(() => _isPlaying = false);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                  color: widget.color, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 4),
                  Text(_isPlaying ? "وقف" : "استمع للكل",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text("🐢", style: TextStyle(fontSize: 14)),
          Expanded(
            child: Slider(
              value: _speed,
              min: 0.25,
              max: 0.65,
              divisions: 8,
              activeColor: widget.color,
              onChanged: (v) async {
                setState(() => _speed = v);
                await _tts.setSpeed(v);
              },
            ),
          ),
          const Text("🐇", style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}