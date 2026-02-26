// ==========================================
// كل المنهج هنا — الصف الثاني الإعدادي ترم 1
// ==========================================

class CurriculumUnit {
  final int unitNumber;
  final String titleEn;
  final String titleAr;
  final String emoji;
  final String grammar;
  final String grammarAr;
  final List<String> vocabulary;
  final List<CurriculumLesson> lessons;
  final String color; // hex string

  const CurriculumUnit({
    required this.unitNumber,
    required this.titleEn,
    required this.titleAr,
    required this.emoji,
    required this.grammar,
    required this.grammarAr,
    required this.vocabulary,
    required this.lessons,
    required this.color,
  });
}

class CurriculumLesson {
  final int lessonNumber;
  final String titleEn;
  final String titleAr;
  final String type; // reading / listening / language / story / speaking / writing
  final String emoji;
  final String mainText; // النص الأساسي للدرس
  final List<ExerciseItem> exercises;
  final List<String> keyWords;

  const CurriculumLesson({
    required this.lessonNumber,
    required this.titleEn,
    required this.titleAr,
    required this.type,
    required this.emoji,
    required this.mainText,
    required this.exercises,
    required this.keyWords,
  });
}

class ExerciseItem {
  final String instruction;
  final String type; // mcq / fill / correct / write / match
  final List<String> questions;
  final List<String>? answers;

  const ExerciseItem({
    required this.instruction,
    required this.type,
    required this.questions,
    this.answers,
  });
}

// ==========================================
// البيانات الفعلية للمنهج
// ==========================================

const List<CurriculumUnit> curriculumUnits = [
  CurriculumUnit(
    unitNumber: 1,
    titleEn: "Gen Alpha",
    titleAr: "جيل ألفا",
    emoji: "📱",
    grammar: "Present Continuous",
    grammarAr: "المضارع المستمر",
    color: "1565C0",
    vocabulary: [
      "generation - جيل",
      "digital natives - مواطنون رقميون",
      "trends - توجهات / موضة",
      "emojis - رموز تعبيرية",
      "memes - ميمز",
      "screen time - وقت الشاشة",
      "balance - توازن",
      "smartphones - هواتف ذكية",
      "connect - يتواصل",
      "include - يشمل",
      "in common - مشترك",
      "far apart - بعيدين عن بعض",
    ],
    lessons: [
      CurriculumLesson(
        lessonNumber: 1,
        titleEn: "Meet Gen Alpha",
        titleAr: "تعرف على جيل ألفا",
        type: "reading",
        emoji: "📖",
        mainText: """
Gen Alpha: The Young Digital Natives

Do you know that you are one of Gen Alpha, who were born from around 2010 to the mid-2020s? Today's young generation, Gen Alpha, is changing the way we live and communicate. They are digital natives, because they learn to use technology before they can read, and they usually spend a lot of time online, exploring the latest trends. They like creating short videos to show their hobbies or opinions.

At the moment, many Gen Alpha children are using social media to learn about the world and to connect with others. They are constantly discovering new trends that quickly spread across their digital communities. For example, they share memes and sometimes send emojis instead of words because they like showing emotions in a creative, fun way.

Teachers and parents often wonder how this generation will grow up with so much technology around them. Right now, many parents are trying to limit screen time while also encouraging useful digital skills. Gen Alpha rarely spends a day without using technology, but they are also learning to balance online activities with real-life connections.

This generation represents a powerful trend that is shaping the future. Gen Alpha always looks for new ways to express themselves and likes using digital tools to create their identity in the modern world.
        """,
        keyWords: ["generation", "digital natives", "trends", "emojis", "screen time", "balance"],
        exercises: [
          ExerciseItem(
            instruction: "Answer the following questions:",
            type: "write",
            questions: [
              "What is the main idea of this text?",
              "Why do Gen Alpha children use social media?",
              "According to the passage, why is Gen Alpha called 'digital natives'?",
              "How does Gen Alpha express their feelings online?",
              "What are parents currently trying to balance for Gen Alpha regarding technology?",
            ],
            answers: [
              "The main idea is that Gen Alpha is a young generation that grows up with technology and digital tools.",
              "They use social media to learn about the world and to connect with others.",
              "Because they learn to use technology before they can read.",
              "They share memes and send emojis to express emotions in a creative way.",
              "Parents are trying to limit screen time while also encouraging useful digital skills.",
            ],
          ),
          ExerciseItem(
            instruction: "Match the words with their meanings:",
            type: "match",
            questions: [
              "digital natives",
              "trends",
              "emojis",
              "screen time",
              "balance",
              "generation",
            ],
            answers: [
              "individuals who have grown up with technology",
              "popular new developments in digital content",
              "small digital images to express emotions",
              "the amount of time spent looking at a screen",
              "a situation where different things are of equal weight",
              "a group of people born around the same time",
            ],
          ),
        ],
      ),
      CurriculumLesson(
        lessonNumber: 2,
        titleEn: "Gen Alpha's Digital Life",
        titleAr: "الحياة الرقمية لجيل ألفا",
        type: "listening",
        emoji: "🎧",
        mainText: """
هذا الدرس عبارة عن استماع (Listening) عن الحياة الرقمية لجيل ألفا.

الموضوع الرئيسي: كيف يستخدم جيل ألفا التكنولوجيا في حياتهم اليومية وتأثير ذلك عليهم.

النقاط الأساسية من المحتوى:
• جيل ألفا يتعلم التكنولوجيا قبل القراءة
• الآباء يحاولون تحديد وقت الشاشة
• ليس كل وقت الشاشة سيء — هناك مهارات رقمية مفيدة
• جيل ألفا يتعلم الموازنة بين الأنشطة الإلكترونية والحقيقية
        """,
        keyWords: ["balance", "limit", "emojis", "screen time"],
        exercises: [
          ExerciseItem(
            instruction: "Write True (T) or False (F):",
            type: "mcq",
            questions: [
              "Gen Alpha can read before they use technology.",
              "Parents are trying to limit screen time.",
              "The speaker believes that all screen time is bad for Gen Alpha.",
              "Gen Alpha are slow learners and they aren't adaptive.",
              "Gen Alpha is also learning to balance online activities with real-life connections.",
            ],
            answers: ["F", "T", "F", "F", "T"],
          ),
          ExerciseItem(
            instruction: "Complete the sentences with: balance – limit – emojis",
            type: "fill",
            questions: [
              "Leila tries hard to _______ her work with her personal life.",
              "You should _______ your screen time. It's good for you.",
              "Some _______ express our feelings.",
            ],
            answers: ["balance", "limit", "emojis"],
          ),
        ],
      ),
      CurriculumLesson(
        lessonNumber: 3,
        titleEn: "The Digital Bridge",
        titleAr: "الجسر الرقمي",
        type: "reading",
        emoji: "🌉",
        mainText: """
The Gen Z-Alpha Bridge: How Digital Trends Unite Young Generations

Generation Z and Generation Alpha are two young generations in the world today. Gen Z includes people born between 1997 and 2012. Gen Alpha includes children born from 2010 till now. Even though they are different ages, they have some important things in common – they are growing up in a digital world.

Both generations use smartphones, tablets, and computers every day. They like watching videos on YouTube, using apps, and playing online games. Social media and online games help them connect, learn, and have fun with others – even if they live far apart.

Digital trends like short videos, emojis, and memes are popular with both groups. Many Gen Z and Gen Alpha kids also care about the environment, being kind, and treating people with fairness. They often use technology to share their thoughts and support important causes.

Even though Gen Z is older than Gen Alpha, both generations speak the same digital language. Technology helps them understand each other and work together to make the world a better place.
        """,
        keyWords: ["connect", "include", "in common", "far apart", "smartphones", "cases"],
        exercises: [
          ExerciseItem(
            instruction: "Choose the correct answer:",
            type: "mcq",
            questions: [
              "What is the passage mostly about?\na. Playing sports\nb. Digital trends connecting Gen Z and Gen Alpha\nc. Traveling to different countries\nd. How to use a computer",
              "When were Gen Z people born?\na. 2000 to 2020\nb. 1990 to 2000\nc. 1997 to 2012\nd. 2010 to 2025",
              "What do Gen Z and Gen Alpha both enjoy?\na. Riding bikes\nb. Using digital devices and apps\nc. Reading newspapers\nd. Playing only board games",
              "What do these generations care about?\na. Only video games\nb. Pets and animals\nc. The environment and fairness\nd. Nothing at all",
            ],
            answers: ["b", "c", "b", "c"],
          ),
        ],
      ),
      CurriculumLesson(
        lessonNumber: 4,
        titleEn: "Story Time: The Little Inventor",
        titleAr: "وقت القصة: المخترعة الصغيرة",
        type: "story",
        emoji: "📚",
        mainText: """
The Little Inventor — Chapter One: The Creative Fair

In a village, there lived a curious girl named Amal. Amal loved to build things. Her room was full of old toys, wires, and little machines she had created. Sometimes, the other children annoyed her and said, "You are strange."

But Amal's parents always told her, "Your identity is what makes you special. Never be afraid to express who you are."

One day, the teacher announced a "Creative Fair." Each child had to present something they were passionate about. Amal decided to build a talking robot! She was excited but also worried. "What if others laugh at me again?" she thought.

Her best friend, Yara, encouraged her, "Just be yourself, Amal. We believe in you."

Amal started working day and night. She also made sure to use the internet safely while looking for ideas, remembering her digital responsibility. She asked for permission before downloading anything and never shared her personal information.
        """,
        keyWords: ["curious", "identity", "special", "passionate", "permission", "annoyed", "fair"],
        exercises: [
          ExerciseItem(
            instruction: "Match the words with their meanings:",
            type: "match",
            questions: ["identity", "passionate", "permission", "curious", "fair", "special"],
            answers: [
              "this is who you are",
              "very strong feeling or excitement about something",
              "being allowed to do something",
              "wanting to know or learn something",
              "an event when people gather to show something",
              "different from others in a good way",
            ],
          ),
          ExerciseItem(
            instruction: "Choose the correct answer:",
            type: "mcq",
            questions: [
              "Amal was ___.\na. lazy  b. shy  c. curious  d. weak",
              "Amal's parents always advised her to ___ herself.\na. tease  b. express  c. punish  d. face",
              "Yara ___ Amal to be herself.\na. shared  b. believed  c. encouraged  d. warned",
              "Amal asked ___ permission before downloading anything.\na. on  b. in  c. at  d. for",
            ],
            answers: ["c", "b", "c", "d"],
          ),
          ExerciseItem(
            instruction: "Answer the following questions:",
            type: "write",
            questions: [
              "What kind of things did Amal like to build?",
              "How did Amal feel when she thought other children laughed at her?",
              "What was the 'Creative Fair' about?",
              "How did Yara help Amal feel better?",
              "What steps did Amal take to stay safe online?",
            ],
            answers: [
              "She liked to build machines, toys with wires, and a talking robot.",
              "She felt worried and scared.",
              "Each child had to present something they were passionate about.",
              "Yara encouraged her and told her to just be herself.",
              "She asked for permission before downloading and never shared personal information.",
            ],
          ),
        ],
      ),
      CurriculumLesson(
        lessonNumber: 5,
        titleEn: "Let's Talk",
        titleAr: "هيا نتكلم",
        type: "speaking",
        emoji: "🗣️",
        mainText: """
Finding Balance – An Interview About Digital Habits

Host: Today we're talking to Saja, a 14-year-old student, about how her generation, often called digital natives, is handling life with technology. Hi, Saja!

Saja: Hi! Thanks for having me with you today.

Host: So, how much screen time do you usually have each day?

Saja: I think around 5 to 6 hours, including homework. I use my smartphone for doing my homework, researching, chatting, and sometimes watching memes or short videos.

Host: Many students follow online trends or post using emojis. Do you think that's good or bad?

Saja: I think that using emojis and memes can be funny and creative.

Host: Do you ever try to find a balance between real life and screen time?

Saja: Yes, I try. I put my phone away during meals. In my opinion, we should limit screen time before bed. I also try to spend more time outside with friends or do sports.

Host: That's great advice! Any tips for other students?

Saja: Just be careful! It's okay to enjoy your screen, but don't let it control you.

---
Conversation Tips:
Use expressions like:
• "In my opinion..." = في رأيي
• "I think..." = أعتقد
• "For example..." = على سبيل المثال
• "That's true, but..." = هذا صحيح، لكن
        """,
        keyWords: ["In my opinion", "I think", "That's true but", "I understand but", "I get it but"],
        exercises: [
          ExerciseItem(
            instruction: "Answer the questions about the dialog:",
            type: "write",
            questions: [
              "How does Saja describe her daily screen time?",
              "What does she use her smartphone for?",
              "Do you agree with Saja's tips about using phones carefully? Why or why not?",
              "What would you add to Saja's advice to help other students stay balanced?",
            ],
            answers: [
              "She has around 5 to 6 hours of screen time including homework.",
              "For homework, researching, chatting, and watching memes or short videos.",
              "Open answer — personal opinion.",
              "Open answer — personal opinion.",
            ],
          ),
        ],
      ),
      CurriculumLesson(
        lessonNumber: 6,
        titleEn: "Expressing Identity Online",
        titleAr: "التعبير عن الهوية أونلاين",
        type: "writing",
        emoji: "✍️",
        mainText: """
Writing Task: A Blog Post

هتكتب blog post عن "A Day in the Life of a Gen Alpha Teen"

الـ Blog هو زي مجلة أونلاين بتكتب فيها عن مواضيع مختلفة.

الكلمات المطلوبة (لازم تستخدم 6 على الأقل):
trends – emojis – digital – screen time – balance – in common – include – smartphones – connect – games

القاعدة المستخدمة: Present Continuous
مثال: "Today, I am waking up early and checking my phone..."

هيكل الـ Blog:
1. مقدمة: مين أنت وإيه يومك
2. وسط: الأنشطة الرقمية اللي بتعملها
3. خاتمة: رأيك في التوازن بين التكنولوجيا والحياة الحقيقية

الطول: 90 - 100 كلمة
        """,
        keyWords: ["trends", "emojis", "digital", "screen time", "balance", "smartphones", "connect"],
        exercises: [
          ExerciseItem(
            instruction: "Complete the blog with suitable words from the box:\ntrends – emojis – digital – screen time – balance – in common – include – smartphones – connect – games",
            type: "fill",
            questions: [
              "They are true (1)___ natives because they grow up using technology from a very young age.",
              "They follow the latest (2)___ like watching short videos.",
              "using (3)___, and playing online (4)___.",
              "They spend a lot of (5)___ on their (6)___.",
              "This makes them (7)___ with others.",
              "Many Gen Alpha kids have things (8)___ with Generation Z.",
              "They are learning to find a (9)___ between using screens and real-world activities.",
            ],
            answers: ["digital", "trends", "emojis", "games", "screen time", "smartphones", "connect", "in common", "balance"],
          ),
        ],
      ),
    ],
  ),

  CurriculumUnit(
    unitNumber: 2,
    titleEn: "My Digital Footprint",
    titleAr: "بصمتي الرقمية",
    emoji: "👣",
    grammar: "Present Simple Passive + Modal Verbs",
    grammarAr: "المبني للمجهول في المضارع البسيط + أفعال الإمكانية",
    color: "2E7D32",
    vocabulary: [
      "determine - يحدد",
      "privacy - خصوصية",
      "footprint - بصمة",
      "secure - آمن",
      "trace - يتتبع",
      "setting - إعداد",
      "update - يحدث",
      "data - بيانات",
      "clues - أدلة",
      "online identity - الهوية الإلكترونية",
    ],
    lessons: [
      CurriculumLesson(
        lessonNumber: 1,
        titleEn: "What is a Digital Footprint?",
        titleAr: "إيه هي البصمة الرقمية؟",
        type: "reading",
        emoji: "📖",
        mainText: """
كل مرة بتستخدم فيها الإنترنت، بتسيب وراك آثار رقمية تُسمى "Digital Footprint" أو البصمة الرقمية.

النوعين:
• Active footprint: المعلومات اللي بتنشرها بنفسك (صور، تعليقات، posts)
• Passive footprint: المعلومات اللي بتتجمع عنك من غير ما تعرف (مواقع بتزورها، إعلانات بتشوفها)

ليه مهمة؟
• ممكن حد يشوف كل اللي عملته أونلاين
• بيؤثر على سمعتك في المستقبل
• لازم تحمي privacy بتاعتك

ازاي تحمي نفسك؟
• اعمل update للـ privacy settings
• متشاركش معلومات شخصية
• فكر قبل ما تنشر أي حاجة
• استخدم passwords قوية
        """,
        keyWords: ["digital footprint", "privacy", "secure", "data", "trace", "settings"],
        exercises: [
          ExerciseItem(
            instruction: "Answer the questions:",
            type: "write",
            questions: [
              "What is a digital footprint?",
              "What is the difference between active and passive footprint?",
              "Why is it important to protect your digital footprint?",
              "How can you protect your privacy online?",
            ],
            answers: [
              "It is the trail of data you leave behind when you use the internet.",
              "Active: information you share yourself. Passive: information collected about you without your knowledge.",
              "Because it can affect your reputation and someone can see everything you did online.",
              "Update privacy settings, don't share personal info, think before posting, use strong passwords.",
            ],
          ),
        ],
      ),
      CurriculumLesson(
        lessonNumber: 2,
        titleEn: "Online Safety Tips",
        titleAr: "نصائح الأمان أونلاين",
        type: "listening",
        emoji: "🎧",
        mainText: """
موضوع الاستماع: نصائح عشان تكون آمن أونلاين

النقاط الأساسية:
1. Never share your personal information (name, address, phone number) with strangers online
2. Always ask a parent or trusted adult before downloading anything
3. Use strong passwords and change them regularly
4. Report anything that makes you feel uncomfortable
5. Remember: not everyone online is who they say they are

الـ Modal Verbs المستخدمة:
• should / shouldn't - المفروض / مش المفروض
• must / mustn't - لازم / ممنوع
• can / can't - تقدر / مش تقدر
• have to - لازم (إجباري)
        """,
        keyWords: ["should", "must", "can", "privacy", "secure", "safe"],
        exercises: [
          ExerciseItem(
            instruction: "Choose should or shouldn't:",
            type: "fill",
            questions: [
              "You ___ share your password with anyone.",
              "You ___ update your privacy settings.",
              "You ___ talk to strangers online.",
              "You ___ tell a trusted adult if something worries you online.",
            ],
            answers: ["shouldn't", "should", "shouldn't", "should"],
          ),
        ],
      ),
    ],
  ),

  CurriculumUnit(
    unitNumber: 3,
    titleEn: "Facing Challenges",
    titleAr: "مواجهة التحديات",
    emoji: "💪",
    grammar: "Past Simple + Past Continuous",
    grammarAr: "الماضي البسيط + الماضي المستمر",
    color: "E65100",
    vocabulary: [
      "challenge - تحدي",
      "discouraged - محبط",
      "determination - تصميم",
      "obstacle - عقبة",
      "courage - شجاعة",
      "traffic jam - زحمة مرور",
      "monorail - المونوريل",
      "creativity - إبداع",
      "inspired - مُلهَم",
      "displayed - مُعروض",
      "stressed - متوتر",
    ],
    lessons: [
      CurriculumLesson(
        lessonNumber: 1,
        titleEn: "Overcoming Challenges",
        titleAr: "التغلب على التحديات",
        type: "reading",
        emoji: "📖",
        mainText: """
A Motivational Article About Overcoming Challenges

Everyone faces challenges in life. The important thing is not to give up. Here are some stories of people who overcame great obstacles.

Determination is the key to success. When you feel discouraged, remember that every challenge is an opportunity to grow. Many great inventors and leaders faced failures before they succeeded.

For example, the monorail in Egypt was inspired by the need to solve traffic jams in big cities. The engineers faced many obstacles, but their creativity and determination helped them succeed.

Tips to overcome challenges:
• Stay positive and believe in yourself
• Ask for help when you need it
• Learn from your mistakes
• Never give up!
        """,
        keyWords: ["challenge", "determination", "obstacle", "courage", "inspired", "overcome"],
        exercises: [
          ExerciseItem(
            instruction: "Answer the questions:",
            type: "write",
            questions: [
              "What is the key to success according to the text?",
              "What was the monorail inspired by?",
              "Give two tips to overcome challenges.",
            ],
            answers: [
              "Determination is the key to success.",
              "It was inspired by the need to solve traffic jams in big cities.",
              "Stay positive / Ask for help / Learn from mistakes / Never give up.",
            ],
          ),
        ],
      ),
    ],
  ),

  CurriculumUnit(
    unitNumber: 4,
    titleEn: "Art and Expression",
    titleAr: "الفن والتعبير",
    emoji: "🎨",
    grammar: "Cause, Result and Contrast Connectors",
    grammarAr: "روابط السبب والنتيجة والتناقض",
    color: "6A1B9A",
    vocabulary: [
      "artwork - عمل فني",
      "sculptures - منحوتات",
      "materials - مواد",
      "special - خاص",
      "imagination - خيال",
      "valuable - ثمين",
      "gallery - معرض فني",
      "sculptor - نحات",
      "agriculture - زراعة",
      "symbol - رمز",
      "promote - يروج",
      "recognition - تقدير / اعتراف",
      "original - أصلي",
    ],
    lessons: [
      CurriculumLesson(
        lessonNumber: 1,
        titleEn: "Art Around Us",
        titleAr: "الفن من حولنا",
        type: "reading",
        emoji: "📖",
        mainText: """
Art is everywhere! From paintings in a gallery to sculptures in the street, art is a powerful way to express ideas and emotions.

Art forms:
• Painting - الرسم
• Sculpture - النحت  
• Photography - التصوير
• Music - الموسيقى
• Dance - الرقص
• Digital art - الفن الرقمي

Famous Egyptian art uses symbols from agriculture and daily life to tell stories about the past. Modern Egyptian artists use their imagination to create original works that promote Egyptian culture worldwide.

Connectors used in art writing:
• because / since (سبب)
• so / therefore / as a result (نتيجة)
• but / however / although (تناقض)
        """,
        keyWords: ["artwork", "imagination", "symbol", "original", "promote", "gallery", "sculptor"],
        exercises: [
          ExerciseItem(
            instruction: "Complete with the correct connector (because / so / but / although):",
            type: "fill",
            questions: [
              "I love art ___ it makes me feel creative.",
              "The painting was old, ___ it was very valuable.",
              "She worked hard, ___ she won the art competition.",
              "___ he was young, he created amazing sculptures.",
            ],
            answers: ["because", "but", "so", "Although"],
          ),
        ],
      ),
    ],
  ),

  CurriculumUnit(
    unitNumber: 5,
    titleEn: "Around the World",
    titleAr: "حول العالم",
    emoji: "🌍",
    grammar: "Comparative and Superlative",
    grammarAr: "أسلوب المقارنة والتفضيل",
    color: "00695C",
    vocabulary: [
      "culture - ثقافة",
      "tradition - تقليد",
      "heritage - تراث",
      "festival - مهرجان",
      "landmark - معلم سياحي",
      "population - عدد السكان",
      "climate - مناخ",
      "continent - قارة",
    ],
    lessons: [
      CurriculumLesson(
        lessonNumber: 1,
        titleEn: "Exploring Cultures",
        titleAr: "استكشاف الثقافات",
        type: "reading",
        emoji: "📖",
        mainText: """
Our world is full of amazing cultures and traditions. Every country has its own unique heritage, festivals, and landmarks.

Egypt: Home of the ancient pyramids and the Nile River. Famous for its rich history and warm hospitality.

Japan: Known for its cherry blossom festivals and technological innovation.

Brazil: Famous for its colorful Carnival festival and the Amazon rainforest.

Comparing cultures helps us understand each other better and appreciate our differences.
        """,
        keyWords: ["culture", "tradition", "heritage", "festival", "landmark"],
        exercises: [
          ExerciseItem(
            instruction: "Use comparative or superlative form:",
            type: "fill",
            questions: [
              "Egypt is ___ (old) than Japan.",
              "The Amazon is the ___ (large) rainforest in the world.",
              "Brazil's Carnival is ___ (colorful) than most festivals.",
            ],
            answers: ["older", "largest", "more colorful"],
          ),
        ],
      ),
    ],
  ),

  CurriculumUnit(
    unitNumber: 6,
    titleEn: "Young Innovators",
    titleAr: "المبتكرون الشباب",
    emoji: "🚀",
    grammar: "Future Tense (will / going to)",
    grammarAr: "المستقبل",
    color: "B71C1C",
    vocabulary: [
      "innovation - ابتكار",
      "inventor - مخترع",
      "technology - تكنولوجيا",
      "solution - حل",
      "environment - بيئة",
      "sustainable - مستدام",
      "project - مشروع",
      "competition - منافسة",
    ],
    lessons: [
      CurriculumLesson(
        lessonNumber: 1,
        titleEn: "Young Inventors",
        titleAr: "المخترعون الشباب",
        type: "reading",
        emoji: "📖",
        mainText: """
Young people today are changing the world through innovation and creativity!

Many students around the world are creating amazing inventions to solve real problems:
• Solar-powered water purifiers for clean water in villages
• Apps to help elderly people connect with their families
• Robots to help in schools and hospitals
• Eco-friendly packaging to reduce plastic waste

These young inventors show us that age is not a barrier to innovation. With determination, creativity, and the right tools, anyone can make a difference.

Egyptian youth are also making their mark in innovation competitions worldwide.
        """,
        keyWords: ["innovation", "inventor", "solution", "sustainable", "competition"],
        exercises: [
          ExerciseItem(
            instruction: "Write sentences using will or going to:",
            type: "write",
            questions: [
              "I / invent / a new app / next year",
              "She / going to / join / the science competition",
              "They / will / solve / the water problem",
            ],
            answers: [
              "I will invent a new app next year.",
              "She is going to join the science competition.",
              "They will solve the water problem.",
            ],
          ),
        ],
      ),
    ],
  ),
];
