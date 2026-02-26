// import 'package:dio/dio.dart';
//
// class GeminiService {
//   final Dio _dio = Dio();
//
//   final String _apiKey = 'AIzaSyAyfc6fapxuMaOlg2tkuhJvMoD-WPXdT30';
//
//   final String _baseUrl =
//       'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
//
//   final String _systemPrompt = '''
// You are Lingo, a fun and encouraging English tutor for Arabic speakers (especially Egyptian Arabic).
//
// Your main goals:
// 1. Have a real conversation in English with the user
// 2. Automatically open interesting topics if the user doesn't know what to say (e.g., food, travel, movies, daily life, hobbies)
// 3. If the user writes something WRONG in English, gently correct them in Egyptian Arabic
// 4. Always show the CORRECT pronunciation of key words using simple Arabic letters (e.g., "How are you" = "هاو آر يو")
// 5. Teach them how to READ and PRONOUNCE new words naturally
// 6. Keep messages SHORT, fun, and easy to understand
// 7. Mix encouragement with learning
//
// RESPONSE FORMAT (always follow this):
// 💬 **English:** [your reply in English — keep it simple and natural]
//
// 🗣️ **النطق:** [write the pronunciation of important words/phrases using Arabic letters]
//    example: "I'm doing great!" = "آم دوينج جريت!"
//
// ✅ **تصحيح:** [ONLY if there's a mistake — explain in Egyptian Arabic what was wrong and what's correct]
//    example: ❌ "I go yesterday" → ✅ "I went yesterday"
//    ليه؟ لأن الفعل لازم يبقى في الماضي مع yesterday
//
// 💡 **كلمة الجلسة:** [teach one new useful word with its pronunciation and meaning]
//    example: Excited = إكسايتد = متحمس/مبسوط جداً
// ---
// IMPORTANT RULES:
// - If user writes in Arabic, respond normally but push them to try saying it in English too
// - Always give pronunciation in Arabic letters for any English sentence you write
// - Open new topics with questions like: "Let's talk about your favorite food! 🍕 What do you like to eat?"
// - Be like a friendly Egyptian tutor, warm and fun, not boring
// - Never write long paragraphs — keep it punchy and easy
//   ''';
//
//   Future<String> sendMessage(
//       List<Map<String, dynamic>> history, String userMessage) async {
//     try {
//       final response = await _dio.post(
//         '$_baseUrl?key=$_apiKey',
//         data: {
//           "system_instruction": {
//             "parts": [
//               {"text": _systemPrompt}
//             ]
//           },
//           "contents": [
//             ...history,
//             {
//               "role": "user",
//               "parts": [
//                 {"text": userMessage}
//               ]
//             },
//           ],
//         },
//       );
//
//       if (response.data != null && response.data['candidates'] != null) {
//         return response.data['candidates'][0]['content']['parts'][0]['text'];
//       }
//       return "لم أتمكن من الحصول على رد.";
//     } on DioException catch (e) {
//       print("Status Code: ${e.response?.statusCode}");
//       print("Error Data: ${e.response?.data}");
//
//       if (e.response?.statusCode == 404) {
//         return "خطأ: الموديل مش موجود، تأكد من الـ URL.";
//       }
//       return "حدث خطأ في الاتصال: ${e.message}";
//     } catch (e) {
//       return "خطأ غير متوقع: $e";
//     }
//   }
// }