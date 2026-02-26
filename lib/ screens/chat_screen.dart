//
//
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter_tts/flutter_tts.dart';
//
// import '../ services/gemini_service.dart';
//
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final GeminiService _geminiService = GeminiService();
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final SpeechToText _speech = SpeechToText();
//   final FlutterTts _tts = FlutterTts();
//
//   final List<Map<String, dynamic>> _history = []; // تاريخ المحادثة للـ API
//   final List<Map<String, String>> _messages = []; // الرسائل للعرض
//   bool _isLoading = false;
//   bool _isListening = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initTts();
//   }
//
//   void _initTts() async {
//     await _tts.setLanguage('en-US');
//     await _tts.setSpeechRate(0.5); // سرعة كلام مناسبة للتعلم
//     await _tts.setVolume(1.0);
//   }
//
//   // إرسال الرسالة
//   void _sendMessage(String text) async {
//     if (text.trim().isEmpty) return;
//
//     setState(() {
//       _messages.add({'role': 'user', 'text': text});
//       _history.add({
//         'role': 'user',
//         'parts': [{'text': text}]
//       });
//       _isLoading = true;
//     });
//
//     _controller.clear();
//     _scrollToBottom();
//
//     final response = await _geminiService.sendMessage(_history, text);
//
//     setState(() {
//       _messages.add({'role': 'bot', 'text': response});
//       _history.add({
//         'role': 'model',
//         'parts': [{'text': response}]
//       });
//       _isLoading = false;
//     });
//
//     // الـ AI يتكلم الرد تلقائياً
//     await _tts.speak(response);
//     _scrollToBottom();
//   }
//
//   // تسجيل الصوت
//   void _toggleListening() async {
//     if (_isListening) {
//       await _speech.stop();
//       setState(() => _isListening = false);
//     } else {
//       bool available = await _speech.initialize();
//       if (available) {
//         setState(() => _isListening = true);
//         _speech.listen(
//           onResult: (result) {
//             _controller.text = result.recognizedWords;
//             if (result.finalResult) {
//               setState(() => _isListening = false);
//             }
//           },
//           localeId: 'en_US',
//         );
//       }
//     }
//   }
//
//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 300), () {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('🎓 English Tutor AI'),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//         actions: [
//           // زرار لمسح المحادثة
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () => setState(() {
//               _messages.clear();
//               _history.clear();
//             }),
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           // منطقة الرسائل
//           Expanded(
//             child: _messages.isEmpty
//                 ? const Center(
//               child: Text(
//                 '👋 Say Hello to start practicing!\nقول Hello عشان نبدأ 😊',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             )
//                 : ListView.builder(
//               controller: _scrollController,
//               padding: const EdgeInsets.all(16),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isUser = msg['role'] == 'user';
//                 return _buildMessageBubble(msg['text']!, isUser);
//               },
//             ),
//           ),
//
//           // Loading indicator
//           if (_isLoading)
//             const Padding(
//               padding: EdgeInsets.all(8),
//               child: Row(
//                 children: [
//                   SizedBox(width: 16),
//                   SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   ),
//                   SizedBox(width: 8),
//                   Text('Tutor is typing...', style: TextStyle(color: Colors.grey)),
//                 ],
//               ),
//             ),
//
//           // منطقة الإدخال
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//             ),
//             child: Row(
//               children: [
//                 // زرار الميكروفون
//                 IconButton(
//                   icon: Icon(
//                     _isListening ? Icons.mic : Icons.mic_none,
//                     color: _isListening ? Colors.red : Colors.deepPurple,
//                   ),
//                   onPressed: _toggleListening,
//                 ),
//
//                 // حقل الكتابة
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: _isListening
//                           ? '🎤 Listening...'
//                           : 'Type in English...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 10,
//                       ),
//                     ),
//                     onSubmitted: _sendMessage,
//                   ),
//                 ),
//
//                 const SizedBox(width: 8),
//
//                 // زرار الإرسال
//                 CircleAvatar(
//                   backgroundColor: Colors.deepPurple,
//                   child: IconButton(
//                     icon: const Icon(Icons.send, color: Colors.white, size: 20),
//                     onPressed: () => _sendMessage(_controller.text),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMessageBubble(String text, bool isUser) {
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         padding: const EdgeInsets.all(14),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.75,
//         ),
//         decoration: BoxDecoration(
//           color: isUser ? Colors.deepPurple : Colors.grey.shade100,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(16),
//             topRight: const Radius.circular(16),
//             bottomLeft: Radius.circular(isUser ? 16 : 0),
//             bottomRight: Radius.circular(isUser ? 0 : 16),
//           ),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isUser ? Colors.white : Colors.black87,
//             fontSize: 15,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     _speech.stop();
//     _tts.stop();
//     super.dispose();
//   }
// }