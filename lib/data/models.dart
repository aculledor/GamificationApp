import 'dart:convert';

enum QuestionType { multi, text }

class Module {
  final String id;
  final List<String> topicIds;
  Module({required this.id, required this.topicIds});
  factory Module.fromJson(Map<String,dynamic> j) =>
      Module(id: j['id'], topicIds: List<String>.from(j['topicIds']));
}

class Topic {
  final String id;
  final String titleKey;
  final List<String> questionIds;
  Topic({required this.id, required this.titleKey, required this.questionIds});
  factory Topic.fromJson(Map<String,dynamic> j) => Topic(
    id: j['id'],
    titleKey: j['titleKey'],
    questionIds: List<String>.from(j['questionIds']),
  );
}

class AnswerOpt {
  final String id;
  final String textKey;
  final bool correct;
  AnswerOpt({required this.id, required this.textKey, required this.correct});
  factory AnswerOpt.fromJson(Map<String,dynamic> j) =>
    AnswerOpt(id: j['id'], textKey: j['textKey'], correct: j['correct'] ?? false);
}

class Question {
  final String id;
  final QuestionType type;
  final String textKey;
  final String? imageAsset;
  final String? videoUrl;
  final List<AnswerOpt> answers;
  final List<String>? correctFreeText; // keys -> must resolve to strings
  Question({
    required this.id,
    required this.type,
    required this.textKey,
    this.imageAsset,
    this.videoUrl,
    this.answers = const [],
    this.correctFreeText,
  });
  factory Question.fromJson(Map<String,dynamic> j) => Question(
    id: j['id'],
    type: (j['type'] == 'text') ? QuestionType.text : QuestionType.multi,
    textKey: j['textKey'],
    imageAsset: j['imageAsset'],
    videoUrl: j['videoUrl'],
    answers: j['answers'] == null ? const [] :
      (j['answers'] as List).map((e) => AnswerOpt.fromJson(e)).toList(),
    correctFreeText: j['correctFreeText'] == null ? null :
      List<String>.from(j['correctFreeText']),
  );
}

class ContentBundle {
  final List<Module> modules;
  final List<Topic> topics;
  final List<Question> questions;
  ContentBundle({required this.modules,required this.topics,required this.questions});
  factory ContentBundle.fromJson(Map<String,dynamic> j) => ContentBundle(
    modules: (j['modules'] as List).map((e)=>Module.fromJson(e)).toList(),
    topics: (j['topics'] as List).map((e)=>Topic.fromJson(e)).toList(),
    questions: (j['questions'] as List).map((e)=>Question.fromJson(e)).toList(),
  );
  Question? qById(String id)=>questions.firstWhere((q)=>q.id==id, orElse: ()=>Question(id:'',type:QuestionType.multi,textKey:'',answers:const[]));
}
